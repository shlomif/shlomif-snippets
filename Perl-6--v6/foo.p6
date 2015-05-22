use v6;

class FiboRand {
    has $.k is rw = 1;
    has @.last_nums is rw;

    method fetch() {
        my $k = $.k;
        my $s_k;

        if ($k <= 55)
        {
            $s_k = (((100003 - 200003*$k + 300007*($k**3)) % 1000000) - 500000);
        }
        else
        {
            $s_k = (((@.last_nums[*-24] + @.last_nums[*-55] + 1000000) % 1000000) - 500000);
            shift(@.last_nums);
        }
        push @.last_nums, $s_k;
        $.k++;

        return $s_k;
    }
}

# Unit test to the randomizer.
{
    my $rand = FiboRand.new;

    for 1 .. 9 -> $k
    {
        $rand.fetch();
    }

    if ($rand.fetch() != -393027)
    {
        die "Wrong s10!";
    }

    for 11 .. 99 -> $k
    {
        $rand.fetch();
    }

    if ($rand.fetch() != 86613)
    {
        die "Wrong s100!";
    }
}
