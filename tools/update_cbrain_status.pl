#!/usr/bin/perl
# Dave MacFarlane 2011
# david.macfarlane2@mcgill.ca
# Poll CBrain server to update the status of tasks in CBrainTasks table
# TODO: - Unhardcode $dbh parameters (use -profile?)
#       - Use CBrainHost from CBrainTasks for that particular task
#       - Execute script to process completed files instead of just marking as Completed in DB?

require CbrainAPI;
use strict;
use DBI;
use Getopt::Tabular;

my $profile;
my $loris_user;
my @args = ();

my @arg_table = 
        (['-profile', "string", 1, \$profile, "Set the profile to use in ~/.neurodb"],
);

my $result = GetOptions(\@arg_table, \@ARGV);

# Magic values that Pierre asked me to use
# They should be un-hardcoded once the API
# allows it.
my $ProviderID = 136;
my $ToolConfigID = 7;
my $ToolConfigID = 76;
my $cbrainhost = 'http://bianca.cbrain.mcgill.ca:3000/';
my $civetprefix = "ibis";

# Username/password to login to cbrain with.
# This should be converted into commandline
# options. The password should be a 
# hash once CBrain API allows it.
my $UserName = "loris";
my $Password = "qwer";

my $dbh = DBI->connect("DBI:mysql:database=loris;host=localhost;port=3306", "root", "abc123!");

my $sth = $dbh->prepare("SELECT TaskID FROM CBrainTasks WHERE Status IN (?, ?, ?, ?, ?, ?, ?)");
$sth->execute("Unknown", "New", "Setting Up", "Queued", "Data Ready", "On CPU",  "Post Processing");
my $upsth = $dbh->prepare("UPDATE CBrainTasks SET Status=? WHERE TaskID=?");
my $compsth = $dbh->prepare("UPDATE CBrainTasks SET CompletedAt = now() WHERE TaskID=?");
my $session = CbrainAPI->new(
    cbrain_server_url => $cbrainhost
);
$session->login($UserName, $Password);

while(my @row = $sth->fetchrow_array) {
    my $task = $session->show_task($row[0]);

    print "$row[0]: ";
    print $task->{'status'};
    if($task->{'status'} =~ m/Completed/) {
        $compsth->execute($row[0]);
    }
    print "\n";
    $upsth->execute($task->{'status'}, $row[0]);
}

$dbh->disconnect();
