package App::MyApp;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT=(qw(run));

use Getopt::Long;

sub run
{
    my $name = "World";

    GetOptions("name=s" => \$name);

    print "Hello, $name!\n";
}

1;
