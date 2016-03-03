#!/usr/bin/perl

use strict;
use warnings;
use JSON::XS;

my $json;
{
    open my $in, "<", "mysql-innodb-tables.json"
        or die "Cannot open dump file for reading.";
    local $/;
    $json = <$in>;
    close($in);
}

my $dbs = decode_json($json);
while (my ($db , $tables) = each(%$dbs))
{
    system("mysql", "-u", "root", $db, "-e", join(" ", map { "ALTER TABLE $_ ENGINE=InnoDB;" } @$tables));
}
