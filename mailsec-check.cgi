#! /usr/bin/env perl
#
# Short description for show.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.008;

# use autodie;

use lib "./lib";
use CGI::Minimal        ();
use IPC::System::Simple qw/ capturex /;
my $DOMAIN_RE = qr#[A-Za-z][A-Za-z0-9_\-\.]*#ms;

my $cgi          = CGI::Minimal->new();
my $email_domain = $cgi->param('domain');
my $HEADER       = "Content-Type: application/xhtml+xml; charset=utf-8\r\n\r\n";
print $HEADER;
if ( !defined $email_domain )
{
    print <<"BODY";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>E-mail domain check form</title>
<meta charset="utf-8"/>
</head>
<body>
<h1>Form</h1>
<form action="">
<strong>E-mail domain:</strong>
<input name="domain" />
<input type="submit" />
</form>
</body>
</html>

BODY
    exit(0);
}
if ( $email_domain !~ m#\A${DOMAIN_RE}\z#ms )
{
    die "dangerous email_domain";
}
my $text = "";
eval { $text = capturex( "mailsec-check", $email_domain ); };
if ( my $Err = $@ )
{
    $text .= $Err;
}

sub escape_html
{
    my $string = shift;
    $string =~ s{&}{&amp;}gso;
    $string =~ s{<}{&lt;}gso;
    $string =~ s{>}{&gt;}gso;
    $string =~ s{"}{&quot;}gso;
    return $string;
}
my $escaped_text = escape_html($text);

my $body = <<"BODY";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>E-mail domain check form</title>
<meta charset="utf-8"/>
</head>
<body>
<h1>Result</h1>

<pre>
$escaped_text
</pre>

</body>

</html>

BODY

binmode STDOUT, ':encoding(utf8)';

print $body;

1;
