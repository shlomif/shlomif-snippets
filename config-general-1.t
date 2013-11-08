#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Config::General;
use YAML::XS qw(DumpFile);

my $conf = Config::General->new(-String => <<'EOF');
<Controller::Distribution>
    graph_path   __HOME__/root/dist/graph/
</Controller::Distribution>
name   CPANHQ
<Model::DB>
    connect_info   dbi:SQLite:dbname=__HOME__/cpanhq.db
    connect_info   undef
</Model::DB>
<Production>
    Test hello
    <Test>
        One Two
        Three Four
    </Test>
</Production>
EOF

my %values = $conf->getall();

# TEST
is_deeply (
    $values{'Production'}{'Test'},
    [
        "hello",
        {
            One => "Two",
            Three => "Four",
        },
    ],
    "Production is OK."
);
