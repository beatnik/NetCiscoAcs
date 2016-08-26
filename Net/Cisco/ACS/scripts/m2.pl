#!/usr/bin/perl

use lib qw(Net/Cisco/ACS/lib);
use Net::Cisco::ACS;
use Data::Dumper;

my $acs = Net::Cisco::ACS->new(hostname => 'x.x.x.x', username => 'user', password => 'password');
$acs->parse_xml('Device',$acs->query("Device")->content);
my %devices = $acs->devices;
print Dumper $devices{"main-device"};
