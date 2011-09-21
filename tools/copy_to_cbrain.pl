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

# Magic values that Pierre asked me to use
# They should be un-hardcoded once the API
# allows it.
my $ProviderID = 136;
my $ToolConfigID = 7;
my $ToolConfigID = 76;
my $cbrainhost = 'http://bianca.cbrain.mcgill.ca:3000/';
my $civetprefix = "ibis_civet";

# Username/password to login to cbrain with.
# This should be converted into commandline
# options. The password should be a 
# hash once CBrain API allows it.
my $UserName = "loris";
my $Password = "qwer";

my $dbh = DBI->connect("DBI:mysql:database=loris;host=localhost;port=3306", "root", "abc123!");

my $sth = $dbh->prepare("SELECT ID FROM users Where UserID=? LIMIT 1");
$sth->execute($loris_user);
my @results = $sth->fetchrow_array;
$sth->finish;
my $UserID = $results[0];
if(!$UserID) {
    print "Loris User does not exist\n";
    exit(-1);
}
print "$loris_user : $UserID\n";

#$configh->execute([3]);
my $timestamp = time();
my %subject_map = ();

system("ssh -n ibis\@pinch.bic.mni.mcgill.ca \"mkdir /data/ibis/data/cbrain/$timestamp\"");
while(my $line = <>) {
    chomp($line);
    print "$line\n";
    my @pieces = split(/_/, $line);
    my @paths = split('/', $line);
    print "$pieces[1] $paths[$#paths]\n";
    #$subject_map{$paths[$#paths]} = $pieces[1];
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
my $sth = $dbh->prepare("INSERT INTO CBrainTasks (UserID, Timestamp, CBrainHost, TaskID, Status) VALUES (?, ?, ?, ?, ?)");
foreach my $TaskID (@$TaskIDs) {
    print "TaskID: $TaskID\n";
    $sth->execute($UserID, $timestamp, $cbrainhost, $TaskID, 'Unknown');
}


$dbh->disconnect();
