#!/usr/bin/perl

use strict;
use warnings;

use MIME::EncWords qw(:all);
use Email::Simple;

use IO::All;

my $email = Email::Simple->new(scalar(io()->file("mail1.msg")->slurp()));

my $subj = $email->header("Subject");

print scalar(decode_mimewords($subj)), "\n";
