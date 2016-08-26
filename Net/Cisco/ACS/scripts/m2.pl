#!/usr/bin/perl

use lib qw(Net/Cisco/ACS/lib);
use Net::Cisco::ACS;
use Data::Dumper;

my $acs = Net::Cisco::ACS->new(hostname => '10.0.0.0', username => 'acsadmin', password => 'password');
$acs->parse_xml('Device',$acs->query("Device")->content);
my %devices = $acs->devices;
print Dumper $devices{"ACP1"};
