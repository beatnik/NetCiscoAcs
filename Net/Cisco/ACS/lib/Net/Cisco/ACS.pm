package Net::Cisco::ACS;
use strict;
use Moose;

# REST IO stuff here
use IO::Socket::SSL qw( SSL_VERIFY_NONE );
use LWP::UserAgent;
use XML::Simple;

# Generics
use MIME::Base64;
use URI::Escape;
use Data::Dumper;

# Net::Cisco::ACS::*
use Net::Cisco::ACS::User;
use Net::Cisco::ACS::Device;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
}

# Moose!

has 'ssl_options' => (
	is => 'rw',
	isa => 'HashRef',
	default => sub { { 'SSL_verify_mode' => SSL_VERIFY_NONE, 'verify_hostname' => '0' } }
	);

has 'ssl' => (
	is => 'rw',
	isa => 'Str',
	default => '1',
	);

has 'hostname' => (
	is => 'rw',
	isa => 'Str',
	required => '1',
	); 

has 'users' => (
      	is  => 'rw',
      	isa => 'HashRef',
	auto_deref => '1',	
  	);

has 'devices' => (
	is => 'rw',
	isa => 'HashRef',
	auto_deref => '1',
	);

has 'username' => (
	is => 'rw',
	isa => 'Str',
	required => '1',
	);

has 'password' => (
	is => 'rw',
	isa => 'Str',
	required => '1',
	);


# Non-Moose

sub query 
{ my ($self, $type) = @_;
  my $hostname = $self->hostname;
  my $credentials = encode_base64($self->username.":".$self->password);
  if ($self->ssl)
  { $hostname = "https://$hostname"; } else
  { $hostname = "http://$hostname"; }
  my $action = '';
  if ($type eq 'User')
  { $action = $Net::Cisco::ACS::User::actions{"query"}; }
  if ($type eq 'Device')
  { $action = $Net::Cisco::ACS::Device::actions{"query"}; }
  $hostname = $hostname . $action;
  my $useragent = LWP::UserAgent->new (ssl_opts => $self->ssl_options);
  my $request = HTTP::Request->new(GET => $hostname );
  $request->header('Authorization' => "Basic $credentials");
  my $result = $useragent->request($request);
  die 'http status: ' . $result->code . '  ' . $result->message unless ($result->is_success);
  return $result;
  # Parse $result->content!!
}

sub parse_xml
{ my $self = shift;
  my $type = shift;
  my $xml_ref = shift;
  my $xmlsimple = XML::Simple->new();
  my $xmlout = $xmlsimple->XMLin($xml_ref);
  if ($type eq 'User')
  { my $users_ref = $xmlout->{"User"};
    my %users = ();
    for my $key (keys % {$users_ref})
    { my $user = Net::Cisco::ACS::User->new( username => $key, %{ $users_ref->{$key} } );
      $users{$key} = $user;
    }
    $self->users(\%users);
  }
  if ($type eq 'Device')
  { my $device_ref = $xmlout->{"Device"};
    print Dumper $device_ref;
    my %devices = ();
    for my $key (keys % {$device_ref})
    { my $device = Net::Cisco::ACS::Device->new( name => $key, %{ $device_ref->{$key} } );
      $devices{$key} = $device;
    }
    $self->devices(\%devices);
  }
}

#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!


=head1 NAME

Net::Cisco::ACS - Access Cisco ACS functionality through REST API

=head1 SYNOPSIS

  use Net::Cisco::ACS;


=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.


=head1 USAGE



=head1 BUGS



=head1 SUPPORT



=head1 AUTHOR

    Hendrik Van Belleghem
    CPAN ID: BEATNIK
    hendrik.vanbelleghem@gmail.com

=head1 COPYRIGHT

This program is free software licensed under the...

	The General Public License (GPL)
	Version 2, June 1991

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################

__PACKAGE__->meta->make_immutable();

1;
# The preceding line will help the module return a true value

