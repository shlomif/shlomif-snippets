#!/usr/bin/perl

use Vector;
use POSIX;

use strict;
use warnings;

local (*F);

my $pi = atan2(1,1)*4;

my @connected =
    (
     [ 1,2,3,4,5],
     [ 0,5,8,7,2],
     [0,1,7,6,3],
     [0,2,6,10,4],
     [0,3,10,9,5],
     [0,4,9,8,1],
     [2,7,11,10,3],
     [1,8,11,6,2],
     [1,5,9,11,7],
     [4,10,11,8,5],
     [3,6,11,9,4],
     [6,7,8,9,10],
     );


sub p_line
{
    my ($v1, $v2, $rgb) = @_;
    my $v3 = $v1+$v2;
    print {*F} join(" ", $v1->to_2d(), $v3->to_2d(), $rgb?@{$rgb}:(0,0,0)), "\n";
}

open *F, ">dodeca.txt";

my (@sides, @edges);

$sides[0] = new Vector(0,-10,-2);

$edges[0][1] = new Vector(10,0,0);
$edges[1][0] = (-1) * $edges[0][1];

my ($a);
for($a=1;$a<5;$a++)
{
    $edges[0][$a+1] = $edges[0][$a]->rotate($sides[0], $pi-$pi*3/5);
    $edges[$a+1][0] = (-1) * $edges[0][$a+1];
}

my $rot_angle = 2*POSIX::asin(0.5/cos($pi*3/5/2));
print "rot_angle is $rot_angle; ", ($rot_angle/2*180/$pi), "*2 degrees \n";

for($a=1;$a<6;$a++)
{
    $sides[$a] = (-1) * $sides[0]->rotate($edges[0][$a], -$rot_angle);
}

my $side;
for($side=1;$side<=5;$side++)
{
    for($a=0;$a<4;$a++)
    {
        $edges[$side][$connected[$side][$a+1]] =
            $edges[$side][$connected[$side][$a]]->rotate($sides[$side], ($pi-$pi*3/5));
        $edges[$connected[$side][$a+1]][$side] = (-1) * $edges[$side][$connected[$side][$a+1]];
    }
}

for($side=6;$side<=10;$side++)
{
    $sides[$side] = (-1) * $sides[11-$side];
    for($a=0;$a<4;$a++)
    {
        $edges[$side][$connected[$side][$a+1]] =
            $edges[$side][$connected[$side][$a]]->rotate($sides[$side], ($pi-$pi*3/5));
        $edges[$connected[$side][$a+1]][$side] = (-1) * $edges[$side][$connected[$side][$a+1]];
    }
}

$sides[11] = (-1) * $sides[0];

my $v = new Vector(0,0,10);

my $b;
my $color = [0,0,0];
for($b=1;$b<6;$b++)
{
    p_line($v, $edges[0][$b]);
    $v += $edges[0][$b];
    for($a=0;$a<5;$a++)
    {
        p_line($v, $edges[$b][$connected[$b][$a]], $color);
        $v += $edges[$b][$connected[$b][$a]];
        if ($connected[$b][$a] == 11-($b+3)%5-($b==2)*5)
        {
            my ($c);
            $side = $connected[$b][$a];
            for($c=($connected[$b][$a] == 8);$c<5+($connected[$b][$a] == 8);$c++)
            {
                p_line($v, $edges[$side][$connected[$side][$c%5]], [0,0,0]);
                $v += $edges[$side][$connected[$side][$c%5]];
            }
        }
    }
}


for($a=0;$a<5;$a++)
{
    $edges[1][$connected[1][$a]]->p();
}

print join(" ", @{$v->{coords}}), " ", $v->len(), "\n";

close (*F);
