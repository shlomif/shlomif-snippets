use warnings;
use strict;

use Net::Telnet;

my $t = Net::Telnet->new(Timeout => 20, Prompt => '/\n250/');
$t->open(Host =>'dict.org',Port => '2628');
my @lines = $t->cmd("help");
print @lines;
