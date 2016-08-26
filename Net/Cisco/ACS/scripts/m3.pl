#!/usr/bin/perl

use lib qw(Net/Cisco/ACS/lib);
use Net::Cisco::ACS;
use Data::Dumper;

my $acs = Net::Cisco::ACS->new(hostname => '10.0.0.0', username => 'acsadmin', password => 'password');
$acs->parse_xml('User',$acs->query("User")->content);
print $acs->users->{"hendrikvb"}->toXML;
