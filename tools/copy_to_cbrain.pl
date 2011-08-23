#!/usr/bin/perl

require CbrainAPI;

# Magic values that Pierre asked me to use
# They should be un-hardcoded once the API
# allows it.
$ProviderID = 136;
$ToolConfigID = 7;

# Username/password to login to cbrain with.
# This should be converted into commandline
# options. The password should be a 
# hash once CBrain API allows it.
$UserName = "loris";
$Password = "qwer";


$timestamp = time();

my $agent = CbrainAPI->new(
    cbrain_server_url => "http://bianca.cbrain.mcgill.ca:3000/"
);
$agent->login($UserName, $Password);
system("ssh -n ibis\@pinch.bic.mni.mcgill.ca \"mkdir /data/ibis/data/cbrain/$timestamp\"");
while(my $line = <>) {
    chomp($line);
    print "$line\n";
    system("ssh -n ibis\@pinch.bic.mni.mcgill.ca \"ln $line /data/ibis/data/cbrain/$timestamp/\"");
    #system("ssh -n ibis\@pinch.bic.mni.mcgill.ca \"cp $line /data/ibis/data/cbrain/$timestamp/\"");
}

$CollectionId = $agent->register_file($timestamp, 'FileCollection', $ProviderID);
