#!/usr/bin/perl

use strict;
use warnings;
use JSON::XS;

open my $in, "-|", "mysql", "-u", "root", "information_schema", "-e", "SELECT TABLE_SCHEMA,TABLE_NAME FROM TABLES WHERE ENGINE = 'InnoDB';"
    or die "Could not open mysql client!";

my $cnt = 0;
my $headers = <$in>;

my %dbs;
while (<$in>)
{
    chomp;
    my ($db, $table) = split(/\s+/, $_);
    push @{$dbs{$db}}, $table;
}
close($in);

{
    open my $out, ">", "mysql-innodb-tables.json"
        or die "Cannot open dump file for writing.";
    print {$out} encode_json(\%dbs);
    close($out);
}

while (my ($db , $tables) = each(%dbs))
{
    system("mysql", "-u", "root", $db, "-e", join(" ", map { "ALTER TABLE $_ ENGINE=MyISAM;" } @$tables));
}
