package Net::Cisco::ACS::User;
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

    %actions = (	"query" => "/Rest/Identity/User",
					"create" => "/Rest/Identity/User",
               		"update" => "/Rest/Identity/User",
                	"getByName" => "/Rest/Identity/User/name/",
                	"getById" => "/Rest/Identity/User/id/",
           ); 

# MOOSE!
		   
has 'description' => (
      is  => 'rw',
      isa => 'Any',
  );

has 'id' => (
      is  => 'rw',
      isa => 'Str',
  );

has 'identityGroupName' => ( 
	is => 'rw',
	isa => 'Str',
	);

has 'name' => (
	is => 'rw',
	isa => 'Str',
	);

has 'dateExceeds' => ( 
	is => 'rw',
	isa => 'Str',
	);

has 'changePassword' => ( 
	is => 'ro',
	isa => 'Str',
	);

has 'created' => ( 
	is => 'ro',
	isa => 'Str',
	);

has 'attributeInfo' => ( 
	is => 'ro',
	isa => 'ArrayRef',
	auto_deref => '1',
	);		

has 'dateExceedsEnabled' => (
	is => 'rw',
	isa => 'Str',
	);

has 'enablePassword' => (
	is => 'rw',
	isa => 'Str',
	);

has 'enabled' => (
	is => 'rw', 
	isa => 'Str',
	);

has 'lastLogin' => (
	is => 'ro',
	isa => 'Any',
	);

has 'lastModified' => (
	is => 'ro',
	isa => 'Str',
	);

has 'lastPasswordChange' => ( 
	is => 'ro',
	isa => 'Str',
	);

has 'loginFailuresCounter' => (
	is => 'ro',
	isa => 'Int',
	);

has 'password' => (
	is => 'rw',
	isa => 'Str',
	);

has 'passwordNeverExpires' => (
	is => 'rw',
	isa => 'Str',
	);

has 'passwordType' => (
	is => 'rw',
	isa => 'Str',
	);

# No Moose	
	
sub toXML
{ my $self = shift;
  my $id = $self->id;
  my $description = $self->description || ""; 
  my $identitygroupname = $self->identityGroupName || "All Groups";
  my $name = $self->name || "";
  my $changepassword = $self->changePassword || "false";
  my $enabled = $self->enabled || "true";
  my $password = $self->password || "";
  my $passwordneverexpires = $self->passwordNeverExpires || "false";
  my $passwordtype = $self->passwordType || "Internal Users";
  my $enablepassword = $self->enablePassword || "";
  my $dateexceeds = $self->dateExceeds || "";
  my $dateexceedsenabled = $self->dateExceedsEnabled || "false";
  my $result = "";
  
  if ($id) { $result = "   <id>$id</id>\n"; }
  $result .= <<XML;
   <description>$description</description>
   <identityGroupName>$identitygroupname</identityGroupName>
   <name>$name</name>
   <changePassword>$changepassword</changePassword>
   <enablePassword>$enablepassword</enablePassword>
   <enabled>$enabled</enabled>
   <password>$password</password>
   <passwordNeverExpires>$passwordneverexpires</passwordNeverExpires>
   <passwordType>$passwordtype</passwordType>
   <dateExceeds>$dateexceeds</dateExceeds>
   <dateExceedsEnabled>$dateexceedsenabled</dateExceedsEnabled>
XML

return $result;
}

sub header
{ my $self = shift;
  my $users = shift;
  return qq{<?xml version="1.0" encoding="UTF-8" standalone="yes"?><ns2:user xmlns:ns2="identity.rest.mgmt.acs.nm.cisco.com">$users</ns2:user>};
}
	
=head1 NAME

Net::Cisco::ACS::User - Access Cisco ACS functionality through REST API - User fields

=head1 SYNOPSIS

  use Net::Cisco::ACS::User;
  my $user = Net::Cisco::ACS::User->new("name"=>"soloh","description"=>"Han Solo","identityGroupName"=>"All Groups:MilleniumCrew","password"=>"Leia");

  Fields
  - description
  - name
  - changePassword
  - enablePassword
  - enabled
  - password
  - passwordNeverExpires
  - passwordType
  - dateExceeds
  - dateExceedsEnabled
  
=head1 DESCRIPTION

The Net::Cisco::ACS::User class holds all the user relevant information from Cisco ACS 5.x

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

