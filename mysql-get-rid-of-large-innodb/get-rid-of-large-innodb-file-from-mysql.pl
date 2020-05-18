#!/usr/bin/perl

use strict;
use warnings;
use JSON::MaybeXS qw/ encode_json /;

use Path::Tiny qw/ path tempdir tempfile cwd /;

open my $in, "-|", "mysql", "-u", "root", "information_schema", "-e",
    "SELECT TABLE_SCHEMA,TABLE_NAME FROM TABLES WHERE ENGINE = 'InnoDB';"
    or die "Could not open mysql client!";

my $cnt     = 0;
my $headers = <$in>;

my %dbs;
while (<$in>)
{
    chomp;
    my ( $db, $table ) = split( /\s+/, $_ );
    push @{ $dbs{$db} }, $table;
}
close($in);

path("mysql-innodb-tables.json")->spew_utf8( encode_json( \%dbs ) );

while ( my ( $db, $tables ) = each(%dbs) )
{
    system( "mysql", "-u", "root", $db, "-e",
        join( " ", map { "ALTER TABLE $_ ENGINE=MyISAM;" } @$tables ) );
}

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2020 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
