#!/usr/bin/perl
# Dave MacFarlane 2011
# david.macfarlane2@mcgill.ca
# Take the TaskID of a completed CBrain (CIVET) task, process the files, and insert
# them into the MRI browser
# TODO - Determine if "native" coordinate space is ever used, and pass appropriately to InsertScan
#   - Copy files to appropriate subdirectory on pinch
#   - Use full path of FileName in insert statement (of copied file)
#   - Determine appropriate AcquisitionProtocolID for all file types
#   - Error checking/don't insert if parameter not passed
#   - Ensure proper FileType for non-mnc/obj/xfm
#   - Keep a log somewhere
#   - Produce mincpic and jiv

require CbrainAPI;
use strict;
use NeuroDB::DBI;
use Getopt::Tabular;

my $profile;
my $loris_user;
my @args = ();

my @arg_table = 
        (['-profile', "string", 1, \$profile, "Set the profile to use in ~/.neurodb"],
);

my $result = GetOptions(\@arg_table, \@ARGV);
my $TaskID = $ARGV[0];

if(!defined($profile)) {
    print "profile is required\n";
    exit(-1);
}

# Group functions that deal with the database together 
{
    { package Settings; do "$ENV{HOME}/.neurodb/$profile" }
        if (!defined(@Settings::db)) {
            print "\n\tERROR: You don't have a configuration file named '$profile' in:  $ENV{HOME}/.neurodb/ \n\n";
            exit(33);
    }

    my $dbh = &NeuroDB::DBI::connect_to_db(@Settings::db);
    my $configsth= $dbh->prepare("SELECT c.Value FROM ConfigSettings cs LEFT JOIN Config c ON (c.ConfigID=cs.ID) WHERE cs.Name=?");
    my $filesth = $dbh->prepare("SELECT FileID FROM files WHERE file LIKE ? LIMIT 1");
    my $sessionsth = $dbh->prepare("SELECT s.ID FROM session s JOIN candidate c USING (CandID) WHERE CandID = ? AND Visit_label = ? AND c.Active='Y' and s.Active='Y' AND c.Cancelled='N' AND s.Cancelled='N'");
    my $useridsth = $dbh->prepare("SELECT UserID FROM CBrainTasks WHERE TaskID = ?");
    my $acqsth = $dbh->prepare("SELECT ID FROM mri_scan_type WHERE Scan_type = ?");
    my $insertsth = $dbh->prepare("INSERT INTO files (SessionID, File, CoordinateSpace, ClassifyAlgorithm, OutputType, AcquisitionProtocolID, FileType, InsertedByUserID, InsertTime, SourcePipeline, SourceFileID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), ?, ?)");
    my $checkMD5 = $dbh->prepare("SELECT pf.Value FROM parameter_file pf JOIN parameter_type pt USING (ParameterTypeID) WHERE pt.Name='md5hash' AND pf.Value=?");
    my $getMD5PT = $dbh->prepare("SELECT pt.ParameterTypeID FROM parameter_type pt WHERE pt.Name='md5hash'");
    my $insertMD5 = $dbh->prepare("INSERT INTO parameter_file (FileID, ParameterTypeID, Value, InsertTime) VALUES (?, ?, ?, now())");
    sub _GetSingleVal {
        my $sth = shift;
        my @param = @_;
        $sth->execute(@param);
        my @results = $sth->fetchrow_array;
        return $results[0];
    }
    my $md5PT = _GetSingleVal($getMD5PT);
    $getMD5PT->finish;

    sub GetConfigOption {
        my $name = shift;
        return _GetSingleVal($configsth, $name);
    }
    sub InsertScan {
        my $SessionID = shift;
        my $FileName = shift;
        my $AcqProtoID = shift;
        my $InsertUserID = shift;
        my $SourceFileID = shift;
        my $CoordinateSpace = shift; 
        my $ClassifyAlg = '';
        my $OutputType = 'native';
        my $FileType = GetFileType($FileName);
        my $md5 = shift;
        my $md5check = _GetSingleVal($checkMD5, $md5);
        if(!$md5check) {
            $insertsth->execute($SessionID, $FileName, $CoordinateSpace, $ClassifyAlg, $OutputType, $AcqProtoID, $FileType, $InsertUserID, "CBrain-$TaskID", $SourceFileID);
            #print "mysql_insertid" . $insertsth->{mysql_insertid} . "\n";
            #print "MD5PT: $md5PT, MD5: $md5\n";
            #print "insertid" . $insertsth->{insertid} . "\n";
            $insertMD5->execute($insertsth->{mysql_insertid}, $md5PT, $md5);
        } else {
            print "Error: file with MD5 hash $md5 already inserted. Can not insert $FileName.\n";
        }
    }

    sub GetFileID {
        my $file = shift;
        return _GetSingleVal($filesth, '%' . $file);
    }

    sub GetSessionID {
        my $CandID = shift;
        my $VL = shift;
        return _GetSingleVal($sessionsth, $CandID, $VL);
    }

    sub GetInsertedUser {
        my $TaskID = shift;
        return _GetSingleVal($useridsth, $TaskID);
    }
    sub GetAcquisitionProtocolID {
        my $filename = shift;
        if($filename =~ m/cls_clean.mnc$/) {
            return _GetSingleVal($acqsth, "clean_cls");
        } elsif($filename =~ m/_gm.mnc$/) {
            return _GetSingleVal($acqsth, "gray_matter");
        } elsif($filename =~ m/_wm.mnc$/) {
            return _GetSingleVal($acqsth, "white_matter");
        } elsif($filename =~ m/_csf.mnc$/) {
            return _GetSingleVal($acqsth, "csf_matter");
        } elsif($filename =~ m/_t1.mnc$/) {
            return _GetSingleVal($acqsth, "t1w");
        } elsif($filename =~ m/_t1_nuc.mnc$/) {
            return _GetSingleVal($acqsth, "t1w");
        }
        return undef;
    }
    sub DisconnectDBH {
        $filesth->finish;
        $sessionsth->finish;
        $useridsth->finish;
        $acqsth->finish;
        $insertsth->finish;
        $checkMD5->finish;
        $configsth->finish;

        $dbh->disconnect;
    }
}
my $FileHost = GetConfigOption("FilesHost");
my $RemoteUser = GetConfigOption("FilesUserName");

sub GetFiles {
    my $type = shift;
    my $directory = shift;
    my @files = undef;
    if($type =~ m/^classify$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/classify/*pve_csf.mnc /data/ibis/data/cbrain/$directory/classify/*pve_gm.mnc /data/ibis/data/cbrain/$directory/classify/*pve_wm.mnc /data/ibis/data/cbrain/$directory/classify/*cls_clean.mnc\"`;
    } elsif($type =~ m/^native$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/native/*.mnc\"`;
    } elsif($type =~ m/^surfaces$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/surfaces/*gray_surface*.obj /data/ibis/data/cbrain/$directory/surfaces/*tlink_20mm*.dat /data/ibis/data/cbrain/$directory/surfaces/*mid_surface*_81920.obj /data/ibis/data/cbrain/$directory/surfaces/*white_surface*_calibrated_81920.obj\"`;
    } elsif($type =~ m/^thickness$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/thickness/*cerebral_volume.dat /data/ibis/data/cbrain/$directory/thickness/*native_rms_rsl_tlink_20mm_*.txt\"`;
    } elsif($type =~ m/^transforms_linear$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/transforms/linear/*_t1_tal.xfm\"`;
    } elsif($type =~ m/^transforms_nonlinear$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/transforms/nonlinear/*_nlfit_It.xfm\"`;
    } elsif($type =~ m/^mask$/) {
        @files = `ssh -n $RemoteUser\@$FileHost \"ls /data/ibis/data/cbrain/$directory/mask/*.mnc\"`;
    }
    chomp(@files);
    return @files;
}

sub ProcessFiles {
    my $type = shift;
    my $civet_filename = shift;
    my $SessionID = shift;
    my $UserID = shift;
    my $SourceFileID = shift;
    foreach my $file (GetFiles($type, $civet_filename)) {
        my @path = split('/', $file);
        my $basename = $path[$#path];
        my $AcqProtoID = GetAcquisitionProtocolID($basename);
        my $FileType = GetFileType($basename);
        my $md5 = `ssh -n $RemoteUser\@$FileHost \"md5 $file\"`;
        print "$type: $basename Session: $SessionID User: $UserID AcqProtocolID: $AcqProtoID FileType: $FileType MD5: $md5\n";
        if($type =~ m/nonlinear/) {
            InsertScan($SessionID, $basename, $AcqProtoID, $UserID, $SourceFileID, "nonlinear", $md5);
        } else {
            # Should there be an elsif for native here? Or are native things linear?
            InsertScan($SessionID, $basename, $AcqProtoID, $UserID, $SourceFileID, "linear", $md5);
        }
    }

}
sub GetFileType {
    my $file = shift;
    my @pieces = split(/\./, $file);
    return $pieces[$#pieces];
}

my $UserID = GetInsertedUser($TaskID);
print "TaskID: $TaskID\n";
my @files = `ssh -n $RemoteUser\@$FileHost \"ls -d /data/ibis/data/cbrain/*.mnc-*-$TaskID-[0-9]*\"`;
foreach my $file (@files) {
    chomp($file);

    my @path = split('/', $file);
    my $civet_filename = $path[$#path];
    my @filepieces = split('-', $civet_filename);
    my $sourcemnc = $filepieces[0];
    my @source_pieces = split('_', $sourcemnc);
    my $CandID = $source_pieces[1];
    my $VisitLabel = $source_pieces[2];
    my $SessionID = GetSessionID($CandID, $VisitLabel);
    my $SourceFileID = GetFileID($sourcemnc); 
    ProcessFiles('classify', $civet_filename, $SessionID, $UserID, $SourceFileID);
    ProcessFiles('native', $civet_filename, $SessionID, $UserID, $SourceFileID);
    ProcessFiles('surfaces', $civet_filename, $SessionID, $UserID, $SourceFileID);
    ProcessFiles('thickness', $civet_filename, $SessionID, $UserID, $SourceFileID);
    ProcessFiles('transforms_linear', $civet_filename, $SessionID, $UserID, $SourceFileID);
    ProcessFiles('transforms_nonlinear', $civet_filename, $SessionID, $UserID, $SourceFileID);
    ProcessFiles('mask', $civet_filename, $SessionID, $UserID, $SourceFileID);
}

DisconnectDBH();
