#!/usr/bin/perl
# Dave MacFarlane 2011
# david.macfarlane2@mcgill.ca
# Script to send minc files to a CBrain server using CBrain API, 
# launch a CIVET task, and store the CBrain TaskID in the Loris database
# Takes list of files from STDIN
# Requires public keys to be setup for the user executing it to pinch
# TODO: - remote file copying should to be done more efficiently, instead of one ssh execution per file (+1 for the mkdir)
#   - remote server should be config option. As should remote and local path of minc file, username, and remote directory

require CbrainAPI;
use NeuroDB::DBI;
use strict;
use Getopt::Tabular;

my $profile;
my $loris_user;
my @args = ();

my @arg_table = 
        (['-profile', "string", 1, \$profile, "Set the profile to use in ~/.neurodb"],
        ["-lorisuser", "string", 1, \$loris_user, "Loris user who launched task"]
);

my $result = GetOptions(\@arg_table, \@ARGV);
if(!defined($profile)) {
    print "profile is required\n";
    exit(-1);
} 
if(!defined($loris_user)) {
    print "Lorisuser parameter is required\n";
    exit(-1);
}


# input option error checking

# Group prepared statements together and throw in some helper functions to execute them
# This is the only interaction we have directly with the DB
{
    { package Settings; do "$ENV{HOME}/.neurodb/$profile" }
    if (!defined(@Settings::db)) { 
        print "\n\tERROR: You don't have a configuration file named '$profile' in:  $ENV{HOME}/.neurodb/ \n\n"; 
        exit(33); 
    } 

    my $dbh = &NeuroDB::DBI::connect_to_db(@Settings::db);
    my $configsth= $dbh->prepare("SELECT c.Value FROM ConfigSettings cs LEFT JOIN Config c ON (c.ConfigID=cs.ID) WHERE cs.Name=?");
    my $useridsth = $dbh->prepare("SELECT ID FROM users WHERE UserId=? LIMIT 1");
    my $newtasksth = $dbh->prepare("INSERT INTO CBrainTasks (UserID, Timestamp, CBrainHost, TaskID, Status) VALUES (?, ?, ?, ?, ?)");
    sub _GetSingleVal {
        my $sth = shift;
        my $param = shift;
        $sth->execute($param);
        my @results = $sth->fetchrow_array;
        return $results[0];
    }
    sub GetConfigOption {
        my $name = shift;
        return _GetSingleVal($configsth, $name);
    }
    sub GetUserID { 
        my $name = shift;
        return _GetSingleVal($useridsth, $name);
    }

    sub InsertNewTask {
        my $UserID = shift;
        my $timestamp = shift;
        my $cbrainhost = shift;
        my $TaskID = shift;
        $newtasksth->execute($UserID, $timestamp, $cbrainhost, $TaskID, 'Unknown');
    }
    sub DisconnectDBH {
        $configsth->finish;
        $useridsth->finish;
        $newtasksth->finish;

        $dbh->disconnect();
    }
}

# Magic values that Pierre asked me to use
# They should be un-hardcoded once the API
# allows it.
my $ProviderID = GetConfigOption("CBrainProviderID");
my $ToolConfigID = GetConfigOption("CBrainToolConfigID");
my $cbrainhost = GetConfigOption("CBrainHost");

my $civetprefix = "civet";

# Username/password to login to cbrain with.
# This should be converted into commandline
# options. The password should be a 
# hash once CBrain API allows it.
my $UserName = GetConfigOption("CBrainUsername");
my $Password = GetConfigOption("CBrainPassword");

my $FilePath = GetConfigOption("CBrainFilePath");
my $RemoteUser = GetConfigOption("FilesUserName");
my $FileHost = GetConfigOption("FilesHost");

my $UserID = GetUserID($loris_user);
print "ProviderID: $ProviderID\n";
print "ToolConfigID: $ToolConfigID\n";
print "cbrainhost: $cbrainhost\n";
print "UserName: $UserName\n";
print "Password: $Password\n";
print "\n";
if(!$UserID) {
    print "Loris User does not exist\n";
    exit(-1);
}
print "$loris_user : $UserID\n\n";

my $timestamp = time();
my %subject_map = ();

# Would be more efficient to do something like:
# ssh pinch 'cd /data/ibis/data/cbrain/;mkdir 1316622635; for file in `cat filelists/cbrain.1316622635.txt`; do ln $file /data/ibis/data/cbrain/1316622635/; done'
# with appropriate config options for directories, hosts, usernames, and not using ssh if not remote
system("ssh -n $RemoteUser\@$FileHost \"mkdir $FilePath/$timestamp\"");
while(my $line = <>) {
    chomp($line);
    print "$line\n";
    my @paths = split('/', $line);
    $subject_map{$paths[$#paths]} = $paths[$#paths];
    system("ssh -n $RemoteUser\@$FileHost \"ln $line $FilePath/$timestamp/\"");
}

my $agent = CbrainAPI->new(
    cbrain_server_url => $cbrainhost 
);
$agent->login($UserName, $Password);
my $CollectionId = $agent->register_file($timestamp, 'FileCollection', $ProviderID);
print "CollectionId: $CollectionId\n";
my $TaskIDs = $agent->create_civet_task_for_collection($ToolConfigID, "CIVET run launched at $timestamp", $CollectionId, $civetprefix, \%subject_map, 
{ 
  'output_filename_pattern'  => '{subject}-{cluster}-{task_id}-{run_number}'
});
print $agent->error_message();
print "Looping through @$TaskIDs\n";
foreach my $TaskID (@$TaskIDs) {
    print "TaskID: $TaskID\n";
    InsertNewTask($UserID, $timestamp, $cbrainhost, $TaskID, 'Unknown');
}


DisconnectDBH();
