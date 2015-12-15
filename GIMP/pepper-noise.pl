#!/usr/bin/perl -w

use strict;

use Gimp ":auto";
use Gimp::Fu;
use PDL;
use PDL::Core;
use Carp;

sub sub2ind ($$;@) {
  my $dims = shift;
  $dims = [$dims->dims] if UNIVERSAL::isa($dims,'PDL');
  croak "need dims array ref" unless ref $dims eq 'ARRAY';
  my @args = @_;
  croak "number of dims must not be less than number of arguments"
    unless @args <= @$dims;
  my $coord = $args[0]->copy;
  for my $n (1..$#$dims)
  {
      $coord += $dims->[$n-1]*$args[$n];
  }
  return $coord;
}

#sub pepper_noise
#{
#    my $image = shift;
#    my $drawable = shift;
#    my $num_pixels = shift;

Gimp::init();

    my $filename = "/home/shlomi/Docs/lecture/Gimp/images/lena.png";
    my $image = gimp_file_load($filename, $filename);
    my $num_pixels = 100;

    my $drawable = $image->active_drawable();

    my $gdrawable = $drawable->get();

    my $height = $drawable->height();
    my $width = $drawable->width();

    my @bounds = $drawable->bounds();

    my $src = new PixelRgn ($drawable,@bounds,0,0);
    my $dst = new PixelRgn ($drawable,@bounds,1,1);

    print "1\n";

    my $piddle = $src->data();

        print "2\n";
    my $noise_x = floor(random(1,$num_pixels) * $width);
    my $noise_y = floor(random(1,$num_pixels) * $height);

    print join(",", dims($piddle)), "\n";

    my $noise_indexes = sub2ind($piddle, zeroes(1,$num_pixels), $noise_x, $noise_y);

    if (0)
    {
    for(my $i=0;$i<$num_pixels;$i++)
    {
        if ($piddle->at(0, $noise_x->at(0, $i), $noise_y->at(0, $i)) == 0)
        {
        }
        else
        {
            print "Not zero!";
        }
    }
}

    print "3\n";
    $piddle->flat->index($noise_indexes) .= zeroes(1, $num_pixels);

    print "3.5\n";

    if (0)
    {
    for(my $i=0;$i<$num_pixels;$i++)
    {
        if ($piddle->at(0, $noise_x->at(0, $i), $noise_y->at(0, $i)) == 0)
        {
        }
        else
        {
            print "Not good!";
        }
    }
    }

    $dst->data($piddle);

    print "4\n";
# }

=begin
register("pepper_noise",
         "put pepper noise in an image",
         "Place pepper noise in an Image",
         "Shlomi Fish",
         "Shlomi Fish <shlomif\@vipe.technion.ac.il>",
         "20031003",
         N_"<Image>/Filters/Noise/Pepper Noise",
         "RGB*, GRAY",
         [
            [PF_INT32(), "pixels_num", "Number of Pixels",80]
         ],
         \&pepper_noise);

exit main;
=end
