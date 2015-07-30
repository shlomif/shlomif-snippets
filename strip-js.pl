#!/usr/bin/perl -w

use strict;

use HTML::StripScripts::Parser;

{
    package My::StripScripts;
    use base qw(HTML::StripScripts::Parser);

    sub validate_href_attribute {
        my ($self, $text) = @_;

        my $ret = $self->SUPER::validate_href_attribute($text);
        if ($ret)
        {
            return $ret;
        }
        if ($text =~ m#^[\.\/\w\-]{1,100}$#)
        {
            return $text;
        }
    }
}

sub strip_file
{
        my $filename = shift;
        my $hss = My::StripScripts->new(
               { Context => 'Document',
                AllowSrc => 1,
                AllowHref => 1,
                },
               );

        $hss->parse_file($filename);
        local (*O);
        open O, ">$filename.js-less";
        print O $hss->filtered_document();
        close(O);
}

my $filename = shift;
strip_file($filename);

