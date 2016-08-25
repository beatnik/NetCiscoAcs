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

has 'expirationdate' => ( 
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

has attributeInfo => ( 
	is => 'ro',
	isa => 'ArrayRef',
	auto_deref => '1',
	);		

has dateExceedsEnabled => (
	is => 'rw',
	isa => 'Str',
	);

has enablePassword => (
	is => 'rw',
	isa => 'Str',
	);

has enabled => (
	is => 'rw', 
	isa => 'Str',
	);

has lastLogin => (
	is => 'ro',
	isa => 'Any',
	);

has lastModified => (
	is => 'ro',
	isa => 'Str',
	);

has lastPasswordChange => ( 
	is => 'ro',
	isa => 'Str',
	);

has loginFailuresCounter => (
	is => 'ro',
	isa => 'Int',
	);

has password => (
	is => 'rw',
	isa => 'Str',
	);

has passwordNeverExpires => (
	is => 'rw',
	isa => 'Str',
	);

has PasswordType => (
	is => 'rw',
	isa => 'Str',
	);

=head1 NAME

Net::Cisco::ACS::User - Access Cisco ACS functionality through REST API - User fields

=head1 SYNOPSIS

  use Net::Cisco::ACS::User;


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

