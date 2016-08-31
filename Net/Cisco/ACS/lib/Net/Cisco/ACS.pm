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
use Net::Cisco::ACS::DeviceGroup;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $ERROR);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
	
	$ERROR = ""; # TODO: Document error properly!
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

sub users # No Moose here :(
{	my $self = shift;
    $ERROR = "";
	if (@_)
	{ my %args = @_; 
	  $self->{"Users"} = $args{"users"}; 
	  if ($args{"name"})
	  { $self->{"Users"} = $self->query("User","name",$args{"name"}); }
	  if ($args{"id"})
	  { $self->{"Users"} = $self->query("User","id",$args{"id"}); }
	} else
	{ $self->{"Users"} = $self->query("User"); 
	}
	return $self->{"Users"};
}	

sub devices # No Moose here :(
{	my $self = shift;
	$ERROR = "";
	if (@_)
	{ my %args = @_; 
	  $self->{"Devices"} = $args{"devices"}; 
	  if ($args{"name"})
	  { $self->{"Devices"} = $self->query("Device","name",$args{"name"}); }
	  if ($args{"id"})
	  { $self->{"Devices"} = $self->query("Device","id",$args{"id"}); }
	} else
	{ $self->{"Devices"} = $self->query("Device"); 
	}
	return $self->{"Devices"};
}	

sub devicegroups # No Moose here :(
{	my $self = shift;
	$ERROR = "";
	if (@_)
	{ my %args = @_; 
	  $self->{"DeviceGroups"} = $args{"devicegroups"}; 
	  if ($args{"name"})
	  { $self->{"DeviceGroups"} = $self->query("DeviceGroup","name",$args{"name"}); }
	  if ($args{"id"})
	  { $self->{"DeviceGroups"} = $self->query("DeviceGroup","id",$args{"id"}); }
	} else
	{ $self->{"DeviceGroups"} = $self->query("DeviceGroup"); 
	}
	return $self->{"DeviceGroups"};
}	
	
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
{ my ($self, $type, $key, $value) = @_;
  my $hostname = $self->hostname;
  my $credentials = encode_base64($self->username.":".$self->password);
  if ($self->ssl)
  { $hostname = "https://$hostname"; } else
  { $hostname = "http://$hostname"; }
  my $action = "";
  my $mode = "";
  $key ||= "";
  if ($type eq "User")
  { $action = $Net::Cisco::ACS::User::actions{"query"}; 
    $mode = "Users";
    if ($key eq "name")
	{ $action = $Net::Cisco::ACS::User::actions{"getByName"}.$value; 
	  $mode = "User";
	}
	if ($key eq "id")
	{ $action = $action = $Net::Cisco::ACS::User::actions{"getById"}.$value; 
	  $mode = "User";
	}
  }
  if ($type eq "Device")
  { $action = $Net::Cisco::ACS::Device::actions{"query"}; 
    $mode = "Devices";
    if ($key eq "name")
	{ $action = $Net::Cisco::ACS::Device::actions{"getByName"}.$value; 
	  $mode = "Device";
	}
	if ($key eq "id")
	{ $action = $action = $Net::Cisco::ACS::Device::actions{"getById"}.$value; 
	  $mode = "Device";
	}
  }
  if ($type eq "DeviceGroup")
  { $action = $Net::Cisco::ACS::DeviceGroup::actions{"query"}; 
    $mode = "DeviceGroups";
    if ($key eq "name")
	{ $action = $Net::Cisco::ACS::DeviceGroup::actions{"getByName"}.$value; 
	  $mode = "DeviceGroup";
	}
	if ($key eq "id")
	{ $action = $action = $Net::Cisco::ACS::DeviceGroup::actions{"getById"}.$value; 
	  $mode = "DeviceGroup";
	}
  }
  $hostname = $hostname . $action;
  my $useragent = LWP::UserAgent->new (ssl_opts => $self->ssl_options);
  my $request = HTTP::Request->new(GET => $hostname );
  $request->header('Authorization' => "Basic $credentials");
  my $result = $useragent->request($request);
  if ($result->code eq "400") { $ERROR = "Bad Request - HTTP Status: 400"; }
  if ($result->code eq "410") { $ERROR = "Unknown $type queried by name or ID - HTTP Status: 410"; }  
  $self->parse_xml($mode, $result->content);
}

sub create 
{ my $self = shift;
  my $record = shift;
  my $hostname = $self->hostname;
  my $credentials = encode_base64($self->username.":".$self->password);
  if ($self->ssl)
  { $hostname = "https://$hostname"; } else
  { $hostname = "http://$hostname"; }
  my $action = "";
  my $type = "";
  
  if (ref($record) eq "ARRAY") { $record = $record->[0]; }
  if (ref($record) eq "Net::Cisco::ACS::User")
  { $action = $Net::Cisco::ACS::User::actions{"create"}; 
    $type = "User";
  }
 
  if (ref($record) eq "Net::Cisco::ACS::Device")
  { $action = $Net::Cisco::ACS::Device::actions{"create"}; 
    $type = "DeviceGroup";
  }
  
  if (ref($record) eq "Net::Cisco::ACS::DeviceGroup")
  { $action = $Net::Cisco::ACS::DeviceGroup::actions{"create"}; 
    $type = "DeviceGroup";
  }

  my $data = $record->header($record->toXML);
  $hostname = $hostname . $action;
  my $useragent = LWP::UserAgent->new (ssl_opts => $self->ssl_options);
  my $request = HTTP::Request->new(POST => $hostname );
  $request->content_type("application/xml");  
  $request->header("Authorization" => "Basic $credentials");
  $request->content($data);
  my $result = $useragent->request($request);
  my $result_ref = $self->parse_xml("result", $result->content);
  my $id = "";
  if ($result->code ne "200") 
  { $ERROR = $result_ref->{"errorCode"}." ".$result_ref->{"moreErrInfo"}." - HTTP Status: ".$result_ref->{"httpCode"};
  } else 
  { $id = $result_ref->{"newBornId"}; }
  return $id;
}

sub update 
{ my $self = shift;
  my $record = shift;
  my $hostname = $self->hostname;
  my $credentials = encode_base64($self->username.":".$self->password);
  if ($self->ssl)
  { $hostname = "https://$hostname"; } else
  { $hostname = "http://$hostname"; }
  my $action = "";
  my $type = "";
  
  if (ref($record) eq "ARRAY") { $record = $record->[0]; }
  if (ref($record) eq "Net::Cisco::ACS::User")
  { $action = $Net::Cisco::ACS::User::actions{"update"}; 
    $type = "User";
  }
 
  if (ref($record) eq "Net::Cisco::ACS::Device")
  { $action = $Net::Cisco::ACS::Device::actions{"update"}; 
    $type = "Device";
  }
  if (ref($record) eq "Net::Cisco::ACS::DeviceGroup")
  { $action = $Net::Cisco::ACS::DeviceGroup::actions{"update"}; 
    $type = "DeviceGroup";
  }

  my $data = $record->header($record->toXML);
  $hostname = $hostname . $action;
  my $useragent = LWP::UserAgent->new (ssl_opts => $self->ssl_options);
  my $request = HTTP::Request->new(PUT => $hostname );
  $request->content_type("application/xml");  
  $request->header("Authorization" => "Basic $credentials");
  $request->content($data);
  my $result = $useragent->request($request);
  my $result_ref = undef;
  $result_ref = $self->parse_xml("result", $result->content) if $result_ref;
  $result_ref = {} unless $result_ref;
  my $id = "";
  if ($result->code ne "200" && $result_ref->{"errorCode"}) 
  { $ERROR = $result_ref->{"errorCode"}." ".$result_ref->{"moreErrInfo"}." - HTTP Status: ".$result_ref->{"httpCode"};
  } else 
  { $id = $result_ref->{"newBornId"}; }
  return $id;
}

sub delete 
{ my $self = shift;
  my $record = shift;
  my $hostname = $self->hostname;
  my $credentials = encode_base64($self->username.":".$self->password);
  if ($self->ssl)
  { $hostname = "https://$hostname"; } else
  { $hostname = "http://$hostname"; }
  my $action = "";
  my $type = "";
  
  if (ref($record) eq "ARRAY") { $record = $record->[0]; }
  if (ref($record) eq "Net::Cisco::ACS::User")
  { $action = $Net::Cisco::ACS::User::actions{"getById"}; 
    $type = "User";
  }
 
  if (ref($record) eq "Net::Cisco::ACS::Device")
  { $action = $Net::Cisco::ACS::Device::actions{"getById"}; 
    $type = "Device";
  }
  
  if (ref($record) eq "Net::Cisco::ACS::DeviceGroup")
  { $action = $Net::Cisco::ACS::DeviceGroup::actions{"getById"}; 
    $type = "DeviceGroup";
  }

  my $data = $record->header($record->toXML);
  $hostname = $hostname . $action.$record->id;
  my $useragent = LWP::UserAgent->new (ssl_opts => $self->ssl_options);
  my $request = HTTP::Request->new(DELETE => $hostname );
  $request->content_type("application/xml");  
  $request->header("Authorization" => "Basic $credentials");
  $request->content($data);
  my $result = $useragent->request($request);
  my $result_ref = undef;
  $result_ref = $self->parse_xml("result", $result->content) if $result_ref;
  $result_ref = {} unless $result_ref;  
  my $id = "";
  if ($result->code ne "200" && $result_ref->{"errorCode"}) 
  { $ERROR = $result_ref->{"errorCode"}." ".$result_ref->{"moreErrInfo"}." - HTTP Status: ".$result_ref->{"httpCode"};
  }
}

sub parse_xml
{ my $self = shift;
  my $type = shift;
  my $xml_ref = shift;
  my $xmlsimple = XML::Simple->new();
  my $xmlout = $xmlsimple->XMLin($xml_ref);
  if ($type eq "Users")
  { my $users_ref = $xmlout->{"User"};
    my %users = ();
    for my $key (keys % {$users_ref})
    { my $user = Net::Cisco::ACS::User->new( name => $key, %{ $users_ref->{$key} } );
      $users{$key} = $user;
    }
    $self->{"Users"} = \%users;
	return $self->{"Users"};
  }
  if ($type eq "User") # userByName and userById DO NOT return hash but a single instance of Net::Cisco::ACS::User
  { my %user_hash = %{ $xmlout };
    my $user = Net::Cisco::ACS::User->new( %user_hash );
	$self->{"Users"} = $user ;
	return $self->{"Users"};
  }
  if ($type eq "Devices")
  { my $device_ref = $xmlout->{"Device"};
    my %devices = ();
	for my $key (keys % {$device_ref})
    { my $device = Net::Cisco::ACS::Device->new( name => $key, %{ $device_ref->{$key} } );
      $devices{$key} = $device;
    }
	$self->{"Devices"} = \%devices;
	return $self->{"Devices"};
  }
  if ($type eq "Device") # deviceByName and deviceById DO NOT return hash but a single instance of Net::Cisco::ACS::Device
  { my %device_hash = %{ $xmlout };
    my $device = Net::Cisco::ACS::Device->new( %device_hash );
	$self->{"Devices"} = $device;
	return $self->{"Devices"};
  }

  if ($type eq "DeviceGroups")
  { my $devicegroup_ref = $xmlout->{"DeviceGroup"};
    my %devicegroups = ();
	for my $key (keys % {$devicegroup_ref})
    { my $devicegroup = Net::Cisco::ACS::DeviceGroup->new( name => $key, %{ $devicegroup_ref->{$key} } );
      $devicegroups{$key} = $devicegroup;
    }
	$self->{"DeviceGroups"} = \%devicegroups;
	return $self->{"DeviceGroups"};
  }
  if ($type eq "DeviceGroup") # deviceGroupByName and deviceGroupById DO NOT return hash but a single instance of Net::Cisco::ACS::DeviceGroup
  { my %devicegroup_hash = %{ $xmlout };
    my $devicegroup = Net::Cisco::ACS::DeviceGroup->new( %devicegroup_hash );
	$self->{"DeviceGroups"} = $devicegroup;
	return $self->{"DeviceGroups"};
  }
  
  if ($type eq "result")
  { my %result_hash = %{ $xmlout };
    return \%result_hash;
  }
}

#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!


=head1 NAME

Net::Cisco::ACS - Access Cisco ACS functionality through REST API

=head1 SYNOPSIS

	use Net::Cisco::ACS;
	my $acs = Net::Cisco::ACS->new(hostname => '10.0.0.1', username => 'acsadmin', password => 'testPassword');
	# Options:
	# hostname - IP or hostname of Cisco ACS 5.x server
	# username - Username of Administrator user
	# password - Password of user
	# ssl - SSL enabled (1 - default) or disabled (0)
		
	my %users = $acs->users;
	# Retrieve all users from ACS
	# Returns hash with username / Net::Cisco::ACS::User pairs
	
	print $acs->users->{"acsadmin"}->toXML;
	# Dump in XML format (used by ACS for API calls)
	
	my $user = $acs->users("name","acsadmin");
	# Faster call to request specific user information by name

	my $user = $acs->users("id","150");
	# Faster call to request specific user information by ID (assigned by ACS, present in Net::Cisco::ACS::User)
	
	my %devices = $acs->devices;
	# Retrieve all devices from ACS
	# Returns hash with device name / Net::Cisco::ACS::Device pairs

	print $acs->devices->{"MAIN_Router"}->toXML;
	# Dump in XML format (used by ACS for API calls)
	
	my $device = $acs->devices("name","MAIN_Router");
	# Faster call to request specific device information by name

	my $device = $acs->devices("id","250");
	# Faster call to request specific device information by ID (assigned by ACS, present in Net::Cisco::ACS::Device)

	$user->id(0); # Required for new user!
	my $id = $acs->create($user);
	# Create new user based on Net::Cisco::ACS::User instance
	# Return value is ID generated by ACS
	print "Record ID is $id" if $id;
	print $Net::Cisco::ACS::ERROR unless $id;
	# $Net::Cisco::ACS::ERROR contains details about failure

	$device->id(0); # Required for new device!
	my $id = $acs->create($device);
	# Create new device based on Net::Cisco::ACS::Device instance
	# Return value is ID generated by ACS
	print "Record ID is $id" if $id;
	print $Net::Cisco::ACS::ERROR unless $id;
	# $Net::Cisco::ACS::ERROR contains details about failure

	my $id = $acs->update($user);
	# Update existing user based on Net::Cisco::ACS::User instance
	# Return value is ID generated by ACS
	print "Record ID is $id" if $id;
	print $Net::Cisco::ACS::ERROR unless $id;
	# $Net::Cisco::ACS::ERROR contains details about failure

	my $id = $acs->update($device);
	# Update existing device based on Net::Cisco::ACS::Device instance
	# Return value is ID generated by ACS
	print "Record ID is $id" if $id;
	print $Net::Cisco::ACS::ERROR unless $id;
	# $Net::Cisco::ACS::ERROR contains details about failure
	
	$acs->delete($user);
	# Delete existing user based on Net::Cisco::ACS::User instance

	$acs->delete($device);
	# Delete existing device based on Net::Cisco::ACS::Device instance

	
=head1 DESCRIPTION

See Net::Cisco::ACS::User for more information on User management.
See Net::Cisco::ACS::Device for more information on Device management.

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

