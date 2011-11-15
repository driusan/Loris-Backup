#!/usr/bin/perl
# Dave MacFarlane 2011
# david.macfarlane2@mcgill.ca
# Poll CBrain server to update the status of tasks in CBrainTasks table
# TODO: - Unhardcode $dbh parameters (use -profile?)
#       - Use CBrainHost from CBrainTasks for that particular task
#       - Execute script to process completed files instead of just marking as Completed in DB?

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
if(!defined($profile)) {
    print "profile is required\n";
    exit(-1);
}

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
    my $updatetasksth = $dbh->prepare("INSERT INTO CBrainTasks (UserID, Timestamp, CBrainHost, TaskID, Status) VALUES (?, ?, ?, ?, ?)");
    my $upsth = $dbh->prepare("UPDATE CBrainTasks SET Status=? WHERE TaskID=?");
    my $compsth = $dbh->prepare("UPDATE CBrainTasks SET CompletedAt = now() WHERE TaskID=?");
    my $incsth = $dbh->prepare("SELECT TaskID FROM CBrainTasks WHERE Status IN (?, ?, ?, ?, ?, ?, ?)");
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
    sub GetIncompleteTasks {
        my @tasks;
        $incsth->execute("Unknown", "New", "Setting Up", "Queued", "Data Ready", "On CPU",  "Post Processing");
        while(my @row = $incsth->fetchrow_array) {
            push(@tasks, $row[0]);
        }
        return @tasks;
    }
    sub UpdateTask {
        my $TaskID = shift;
        my $Status = shift;
        $upsth->execute($Status, $TaskID);
    }
    sub CompleteTask {
        my $TaskID = shift;
        $compsth->execute($TaskID);
        `perl ./process_completed_civet_task.pl -profile $profile $TaskID`;
    }
    sub DisconnectDBH {
        $configsth->finish;
        $updatetasksth->finish;
        $upsth->finish;
        $compsth->finish;
        $incsth->finish;
        
        $dbh->disconnect;
    }
}

my $ProviderID = GetConfigOption("CBrainProviderID");
my $ToolConfigID = GetConfigOption("CBrainToolConfigID");;
my $cbrainhost = GetConfigOption("CBrainHost");
my $civetprefix = "civet";

my $UserName = GetConfigOption("CBrainUsername");
my $Password = GetConfigOption("CBrainPassword");

my @tasks = GetIncompleteTasks();

my $session = CbrainAPI->new(
    cbrain_server_url => $cbrainhost
);
$session->login($UserName, $Password);

foreach my $taskid (@tasks) {
    my $task = $session->show_task($taskid);

    print "$taskid: ";
    print $task->{'status'};
    if($task->{'status'} =~ m/Completed/) {
        CompleteTask($taskid);
    }
    print "\n";
    UpdateTask($taskid, $task->{'status'});
}

DisconnectDBH();

