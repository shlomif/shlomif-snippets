#!/usr/bin/perl

use strict;
use warnings;

use String::ShellQuote;

# my $host_unquoted = shift(@ARGV);
my @hosts_unquoted = @ARGV;

my @accounts =
(
    {
        user => "perl_il",
    },
    {
        user => "wiki_osdc",
    },
    {
        user => "python_il",
    },
    {
        user => "hackers_il",
        path_to_wiki => "htdocs/mediawiki/",
    },
);

foreach my $acct (@accounts)
{
    my $user = $acct->{user};
    my $path = $acct->{path_to_wiki} || "htdocs";
    print "$user\n";
    system(
        "ssh",
        ($user . '@' . "hexten.net"),
        (
            "cd ${path}/maintenance && (for I in "
                . shell_quote(@hosts_unquoted) . " ; do "
                . qq{ php cleanupSpam.php "\$I" ; }
                . " done )"
        ),
    );
}

