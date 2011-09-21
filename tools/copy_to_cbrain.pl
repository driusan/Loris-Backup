#!/usr/bin/perl

require CbrainAPI;
use strict;
use DBI;
use Getopt::Tabular;

my $profile;
my $loris_user;
my @args = ();

my @arg_table = 
        (['-profile', "string", 1, \$profile, "Set the profile to use in ~/.neurodb"],
        ["-lorisuser", "string", 1, \$loris_user, "Loris user who launched task"]
);

my $result = GetOptions(\@arg_table, \@ARGV);
if(!defined($loris_user)) {
    print "Lorisuser parameter is required\n";
    exit(-1);
}


# Group prepared statements together and throw in some helper functions to execute them
# This is the only interaction we have directly with the DB
BEGIN {
    my $dbh = DBI->connect("DBI:mysql:database=loris;host=localhost;port=3306", "root", "abc123!");
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

my $civetprefix = "ibis_civet";

# Username/password to login to cbrain with.
# This should be converted into commandline
# options. The password should be a 
# hash once CBrain API allows it.
my $UserName = GetConfigOption("CBrainUsername");
my $Password = GetConfigOption("CBrainPassword");

my $UserID = GetUserID($loris_user);
print "ProviderID: $ProviderID\n";
print "ToolConfigID: $ToolConfigID\n";
print "cbrainhost: $cbrainhost\n";
print "UserName: $UserName\n";
print "Password: $Password\n";
print "\n"
if(!$UserID) {
    print "Loris User does not exist\n";
    exit(-1);
}
print "$loris_user : $UserID\n\n";

my $timestamp = time();
my %subject_map = ();

system("ssh -n ibis\@pinch.bic.mni.mcgill.ca \"mkdir /data/ibis/data/cbrain/$timestamp\"");
while(my $line = <>) {
    chomp($line);
    print "$line\n";
    my @paths = split('/', $line);
    $subject_map{$paths[$#paths]} = $paths[$#paths];
    system("ssh -n ibis\@pinch.bic.mni.mcgill.ca \"ln $line /data/ibis/data/cbrain/$timestamp/\"");
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
