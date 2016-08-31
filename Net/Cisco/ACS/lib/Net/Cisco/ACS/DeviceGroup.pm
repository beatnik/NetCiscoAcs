package Net::Cisco::ACS::DeviceGroup;
use strict;
use Moose;
use Data::Dumper;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS %actions);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
};

    %actions = (	"query" => "/Rest/NetworkDevice/DeviceGroup",
					"create" => "/Rest/NetworkDevice/DeviceGroup",
               		"update" => "/Rest/NetworkDevice/DeviceGroup",
                	"getByName" => "/Rest/NetworkDevice/DeviceGroup/name/",
                	"getById" => "/Rest/NetworkDevice/DeviceGroup/id/",
           ); 

# MOOSE!		   

sub BUILD # after Method Modifier for constructor!
{ my $self = shift;
  # Some magic here
}
	   
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

has 'groupType' => (
	is => 'rw',
	isa => 'Str',
	);

# No Moose	

sub toXML
{ my $self = shift;
  my $result = "";
  my $id = $self->id;
  my $description = $self->description || "";
  my $name = $self->name || "";
  my $grouptype = $self->groupType || "Location";
  if ($id) { $result = "   <id>$id</id>\n"; }
  
  $result = <<XML;
<description>$description</description>
<name>$name</name>
<groupType>$grouptype</groupType>
XML

  return $result;
}

sub header
{ my $self = shift;
  my $devices = shift;
  return qq(<?xml version="1.0" encoding="UTF-8" standalone="yes"?><ns1:deviceGroup xmlns:ns1="networkdevice.rest.mgmt.acs.nm.cisco.com">$devices</ns1:deviceGroup>);
}
	
=head1 NAME

Net::Cisco::ACS::DeviceGroup - Access Cisco ACS functionality through REST API - DeviceGroup fields

=head1 SYNOPSIS

  use Net::Cisco::ACS::DeviceGroup;


=head1 DESCRIPTION

The Net::Cisco::ACS::DeviceGroup class holds all the device group relevant information from Cisco ACS 5.x

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

