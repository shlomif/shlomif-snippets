#!/usr/bin/perl

use Vector;
use POSIX;

use strict;

local (*F);

my $pi = atan2(1,1)*4;

sub p_line
{
    my ($v1, $v2, $rgb) = @_;
    my $v3 = $v1+$v2;
    print {*F} join(" ", $v1->to_2d(), $v3->to_2d(), $rgb?@{$rgb}:(0,0,0)), "\n";
}

open *F, ">corner.txt";

my (@horiz, $vert, $source);

$horiz[0] = new Vector(10,-2,5);

#$vert = ((new Vector(0, -1, 0)) * $horiz[0])*$horiz[0];
$vert = ((new Vector(0, -1, 1)) * $horiz[0])*$horiz[0];
my $r = cos($pi/6)/sin($pi*3/5/2);
$vert *= $horiz[0]->len()*sqrt($r*$r-1)/$vert->len();
$horiz[1] = $horiz[0]->rotate($vert, $pi*2/3);
$horiz[2] = $horiz[0]->rotate($vert, -$pi*2/3);
$source = new Vector(0,0,0);

p_line($source, $horiz[0], [0,255,0]);
p_line($source, $horiz[1]);
p_line($source, $horiz[2]);
p_line($source, $vert, [255,0,0]);

$vert->p();
$horiz[0]->p();

close (*F);
