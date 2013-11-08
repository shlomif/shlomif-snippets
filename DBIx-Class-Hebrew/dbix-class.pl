#!/usr/bin/perl

use strict;
use warnings;

package DB::Main::Artist;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('artist');
__PACKAGE__->add_columns(qw/ artistid name /);
__PACKAGE__->set_primary_key('artistid');

1;

package DB::Main;

use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_classes("Artist");

1;

package main;

use utf8;

my $schema = DB::Main->connect("DBI:mysql:database=test_shmuel_hebrew");

my $artist = $schema->resultset("Artist")->create({name => "שמואל"});

my @all_results = $schema->resultset('Artist')->all();

# binmode STDOUT, ":utf8";
foreach my $artist (@all_results)
{
    print $artist->name(), "\n";
}
