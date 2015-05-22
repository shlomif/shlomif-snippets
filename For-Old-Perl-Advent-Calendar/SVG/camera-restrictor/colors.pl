#!/usr/bin/perl

use strict;
use warnings;

use SVG;
use Math::Trig;

my $max_depth = 50;
my $proportion = 0.1;

my $width = 300;
my $height = $width;

my $half_width = $width*0.5;
my $half_height = $height*0.5;

my $svg = SVG->new(width=>$width, height=>$height,);

sub get_new_coords
{
    my ($coords_ref, $p) = @_;

    # To eliminate some pesky arrows
    my @coords = @$coords_ref;

    return [
        map 
        { 
            [ 
                (1-$p)*$coords[$_][0]+$p*$coords[($_+1)%@coords][0],
                (1-$p)*$coords[$_][1]+$p*$coords[($_+1)%@coords][1],
            ]
        }
        (0 .. $#coords)
        ];
}

sub mygen
{
    my ($id_base, $init_coords, $max_depth, $p, $style_cb) = @_;
    
    my $coords = $init_coords;

    foreach my $depth (0 .. ($max_depth-1))
    {
        my @path_coords = (@$coords, $coords->[0]);

        # Draw the path
        my $path_points =
            $svg->get_path(
                x => [map { $_->[0]} @path_coords],
                y => [map { $_->[1]} @path_coords],
                -type=>'polyline',
                -closed=>'true',
            );
        
        $svg->polyline(
            %$path_points,
            id => "${id_base}_$depth",
            style => $style_cb->($depth),
        );
    }
    continue
    {
        $coords = get_new_coords($coords, $p);
    }
}

my @fills = (qw(red green yellow blue orange));

sub color_style
{
    my $depth = shift;
    
    return
    {
        'fill-opacity' => 0.5,
        'fill' => $fills[$depth%@fills],
        'stroke' => 'black',
        'stroke-width' => "1pt",
        'stroke-opacity' => 1,
    };
}

my @points;
foreach my $i (0 .. 5)
{
    my $x = $half_width + cos(deg2rad(60*$i))*($half_width*0.66);
    my $y = $half_height + sin(deg2rad(60*$i))*($half_width*0.66);
    push @points, [$x, $y];
}
mygen ("hex", \@points, 20, 0.1, \&color_style);

my $text = $svg->xmlify(-namespace => "svg");
# Workaround for Mozilla.
$text =~ s{xmlns=}{xmlns:svg=};
open O, ">", "colors.svg";
print O $text;
close(O);
