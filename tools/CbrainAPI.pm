#!/usr/bin/perl

##############################################################################
#                                                                            #
# CBRAIN Project Perl API
#                                                                            #
##############################################################################
#                                                                            #
#                       CONFIDENTIAL & PROPRIETARY                           #
#       Nothing herein is to be disclosed in any way without the prior       #
#              express written permission of Pierre Rioux                    #
#                                                                            #
#                Copyright 2008 MNI, All rights reserved.                    #
#                                                                            #
##############################################################################

require 5.005;
use strict;
use warnings;

=head1 NAME

CbrainAPI - API for accessing CBRAIN portal servers

=head1 SYNOPSIS

  use CbrainAPI;
  print "This is CbrainAPI-$CbrainAPI::VERSION\n";

=head1 DESCRIPTION

The CbrainAPI.pm module is a perl class that provides a simple
user agent for connecting to CBRAIN portal servers.

=head1 SIMPLE USAGE

  use CbrainAPI;

  # Create our API user agent
  my $agent = CbrainAPI->new( 
     cbrain_server_url => "https://example.com:abcd/",
  );

  # Login
  $agent->login("username","my*Pass*Word");

  # Register a file named 'abcd.txt' as a CBRAIN 'TextFile',
  # which happens to be visible on CBRAIN SshDataProvider #6 .
  # This assumes the files is there, and the DP is online
  # and accessible to the current user.
  $agent->register_file('abcd.txt', 'TextFile', 6);

=head1 AUTHOR

Pierre Rioux, CBRAIN project, August 2011

=head1 METHODS

=cut

package CbrainAPI;

use LWP::UserAgent;
use HTTP::Cookies;
use URI::Escape;

our $VERSION = "1.0";
sub Version { $VERSION ; }



=head2 new(opt => val, opt => val)

Creates a new CBRAIN user agent.

=head3 Required options:

=over 

=item cbrain_server_url

prefix to the server's web site, as in "http://hostname[:port]/".

=back

=head3 Other options:

=over 

=item cookie_store_file

a text file where cookies will be stored. By
default, the module will save them in a temporary file in /tmp.

=back

=head3 Example:

  my $agent = CbrainAPI->new(
    cbrain_server_url => 'http://example.com:3000/',
    cookie_store_file => "$HOME/my_persistent_store.txt",
  );

=cut
sub new {
  my $self  = shift      || __PACKAGE__;
  my $class = ref($self) || $self;

  my $options  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $cookie_store = $options->{'cookie_store_file'} || "/tmp/cbrain_api_cookiejar.$$.txt";
  my $server_url   = $options->{'cbrain_server_url'} || die "Need to be provided with 'cbrain_server_url'.\n";
  $server_url =~ s#/*$#/#;

  my $session = {
     'ua'                => undef,
     'auth_token'        => undef,
     'user'              => undef,
     'cookie_store_file' => $cookie_store,
     'cbrain_server_url' => $server_url,
  };
  bless($session,$class);
  return $session;
}

=head2 login(username,password)

Connects to the server, supplies the credentials
and maintains the tokens necessary for the session.

=head3 Example:

  $agent->login('jack', '&jill');

=cut
sub login {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $user  = shift || die "Need to be provided with a username.\n";
  my $pw    = shift || die "Need to be provided with a password.\n";

  # Create the user agent object
  my $ua = $self->{'ua'} = LWP::UserAgent->new();
  $ua->agent("CbrainPerlAPI/$VERSION");
  $ua->cookie_jar(HTTP::Cookies->new(file => $self->{'cookie_store_file'}, autosave => 1));
  
  # Login to CBRAIN
  my $logreq  = $self->prep_req(GET => "/session/new");
  my $logform = $ua->request($logreq);
  unless ($logform->is_success) {
    die "Cannot connect to server: " . $logform->status_line . "\n";
  }

  # Extract token
  my $logform_content = $logform->content();
  my $auth_token = $1 if $logform_content =~ m#<authenticity_token>(.+)</authenticity_token>#;
  if (!defined($auth_token) || $auth_token eq "") {
    die "Cannot obtain authentication token?!? Server response:\n$logform_content\n";
  }
  $self->{'auth_token'} = $auth_token;

  # Post login/password
  $logreq = $self->prep_req(POST => "/session");
  $self->content_uri_escape_params(
      login              => $user,
      password           => $pw
  );
  #$logreq->content_type('application/json');
  #$logreq->content("{ authenticity_token: \"$auth_token\", login: \"$user\", password: \"$pw\" }");
  my $logres = $ua->request($logreq);
  unless ($logres->is_success) {
    die "Cannot login: "  . $logres->status_line . "\n";
  }
  $self->{'user'} = $user;
  return 1;
}

=head2 register_file(basename, cbraintype, data_provider_id)

Registers a file with CBRAIN. The file is provided as a plain
I<basename>, and must already exist on a filesystem mounted
by a CBRAIN browsable DataProvider (whose ID is given in
the argument I<data_provider_id>. The I<cbraintype> must
be a string matching one of the predefined CBRAIN userfile
types.

=head3 Example:

  $agent->register_file( "abcd.mnc",   "MincFile", 9 );
  $agent->register_file( "lotsa_minc", "MincCollection", 9 );

=cut
sub register_file {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $basename  = shift || die "Need to be provided with a basename.\n";
  my $basetype  = shift || die "Need to be provided with a filetype.\n";
  my $dp_id     = shift || die "Need to be provided with a data provider_id.\n";

  my $ua        = $self->{'ua'} || die "Not logged in.";

  my $req = $self->prep_req(POST => "/data_providers/$dp_id/register");
  $self->content_uri_escape_params(
    'filetypes[]' => "$basetype-$basename",
    'basenames[]' => $basename,
    'commit'      => 'Register files',
  );

  my $res = $ua->request($req);

  return $res->content if $res->is_success;
  die "Cannot register: " . $res->status_line . "\n";
}

sub DESTROY {
  my $self = shift || {};
  unlink $self->{'cookie_store_file'};
}

#########################################
# Internal methods
#########################################

sub prep_req {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $action = shift || die "Need HTTP method (POST, GET, etc).\n";
  my $path   = shift || die "Need CBRAIN route\n";

  my $url = $self->{'cbrain_server_url'}; # contains trailing /

  $path =~ s#^/*##;
  $path = "$url$path"; # slash is inside $url
  
  my $req = $self->{'_cur_req'} = HTTP::Request->new($action => $path);
  $req->header('Accept' => 'text/xml');
  $req;
}

sub content_uri_escape_params {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  my $hash  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $req = $self->{'_cur_req'} || die "No request prepared?!?";
  $req->content_type('application/x-www-form-urlencoded') unless $req->content_type();

  my $auth_token = $self->{'auth_token'} || die "Not logged in.";

  my $res  = $req->content() || "";
  $res    .= "authenticity_token=" . uri_escape($auth_token) if $res eq "";
  foreach my $key (sort keys %$hash) {
    my $u_key = uri_escape($key);
    my $u_val = uri_escape($hash->{$key});
    $res .= "&" if $res ne "";
    $res .= "$u_key=$u_val";
  }
  $req->content($res);
  $res;
}

1;

