#!/usr/bin/perl -w

use strict;

use CGI;
use CGI::Upload;

my $q = CGI->new();
my $upload = CGI::Upload->new({ query => $q});

use constant FILE_PARAM => 'file';

print $q->header();

if ($q->param('sent'))
{
    my $file_name = $upload->file_name(FILE_PARAM);
    my $file_type = $upload->file_type(FILE_PARAM);
    my $file_handle = $upload->file_handle(FILE_PARAM);

    print "<html><body>\n";
    print "<p>Filename = " . CGI::escapeHTML($file_name) . "</p>\n";
    print "<p>Filetype = " . CGI::escapeHTML($file_type) . "</p>\n";
    my $content;
    {
        local $/;
        $content = <$file_handle>;
    }

    print "<p>content = " . CGI::escapeHTML($content) . "</p>\n";
    print "</body></html>\n";
}
else
{
    print <<"EOF";
<html>
<body>
<h1>Submit the form:</h1>
<form enctype="multipart/form-data" method="post">
<input type="hidden" name="sent" value="1" />
<p>
<input type="file" name="file" />
</p>
<p>
<input type="submit" value="Send" />
</p>
</form>
</body>
</html>
EOF

}

