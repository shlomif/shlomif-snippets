use strict;

use Number::Phone::IL::NewCell;

sub international_to_local
{
    my $num_to_input = shift;
    my $international = 0;
    if ($num_to_input =~ /^\+972/)
    {
        $international = 1;
        $num_to_input =~ s!^\+972-?!!;
        $num_to_input = "0" . $num_to_input;
    }

    return ($international, $num_to_input);
}

sub local_to_international
{
    my $result = shift;
    if ($result =~ /^\+972/)
    {
    }
    else
    {
        $result =~ s!^0!!;
        $result = "+972-".$result;
    }
    return $result;
}

sub my_conv
{
    my $number = shift;

    my ($international, $num_to_input);

    ($international, $num_to_input) = international_to_local($number);

    my $conv = Number::Phone::IL::NewCell->new();

    $conv->Old2New($num_to_input);

    my $result = $conv->{result};

    if ($international)
    {
        $result = local_to_international($result);
    }

    return $result;
}

1;
