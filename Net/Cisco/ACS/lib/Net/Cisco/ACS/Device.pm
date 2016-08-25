package Net::Cisco::ACS::Device;
use strict;
use Moose;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS %actions);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
};

    %actions = (	"query" => "/Rest/NetworkDevice/Device",
   		     	"create" => "/Rest/NetworkDevice/Device",
               		 "update" => "/Rest/NetworkDevice/Device",
                	"getByName" => "/Rest/NetworkDevice/Device/name/",
                	"getById" => "/Rest/NetworkDevice/Device/id/",
           ); 

has 'description' => (
      is  => 'rw',
      isa => 'Any',
  );

has 'id' => (
      is  => 'rw',
      isa => 'Str',
  );

has 'name' => (
	is => 'rw',
	isa => 'Str',
	);

has 'tacacsConnection' => (
	is => 'ro',
	isa => 'HashRef',
	auto_deref => 1,
	);

has 'groupInfo' => ( 
	is => 'rw',
	isa => 'ArrayRef',
	auto_deref => '1',
	);

has 'legacytacacs' => (
	is => 'rw',
	isa => 'Str',
	);

has 'tacacs_sharedsecret' => (
	is => 'rw',
	isa => 'Str',
	);

has 'singleconnect' => (
	is => 'rw',
	isa => 'Str',
	);

has 'radius_sharedsecret' => (
	is => 'rw',
	isa => 'Str',
	);

has 'subnets' => (
	is => 'rw',
	isa => 'Any',
	);

has 'location' => (
	is => 'rw',
	isa => 'Str',
	);

has 'groupInfo' => (
	is => 'rw',
	isa => 'ArrayRef',
	auto_deref => '1',
	);

has 'devicetype' => (
	is => 'rw',
	isa => 'Str',
	);

has 'displayedinhex' => (
	is => 'rw',
	isa => 'Str',
	);

has 'keywrap' => (
	is => 'rw',
	isa => 'Str',
	);

has 'portcoa' => (
	is => 'rw',
	isa => 'Str',
	);

=head1 NAME

Net::Cisco::ACS::Device - Access Cisco ACS functionality through REST API - Device fields

=head1 SYNOPSIS

  use Net::Cisco::ACS::Device;


=head1 DESCRIPTION

The Net::Cisco::ACS::Device class holds all the device relevant information from Cisco ACS 5.x

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

