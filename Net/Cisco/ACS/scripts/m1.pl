#!/usr/bin/perl

use lib qw(Net/Cisco/ACS/lib);
use Net::Cisco::ACS;
use Data::Dumper;

my $acs = Net::Cisco::ACS->new(hostname => 'x.x.x.x', username => 'user', password => 'password');
$acs->parse_xml('User',$acs->query("User")->content);
print Dumper $acs->users->{"acsadmin"};
