use strict;
use warnings;

sub addbackslashes
{
    my $string = shift;
    my $out    = "";
    my $char;

    foreach $char ( split( //, $string ) )
    {
        if ( $char =~ /[\$\\\"]/ )
        {
            $out .= "\\";
        }
        $out .= $char;
    }
    return $out;
}

my $p_expr = &{
    sub {
        my $x = shift;
        return "eval {
			my \$local_self ;
			\$local_self = sub {
				&{$x}(\"" . addbackslashes($x) . "\");
			};
			&{\$local_self}();
		}";
    }
    }(
    "sub {
		my \$x = shift;
		return
		\"eval {
			my \\\$local_self ;
			\\\$local_self = sub {
				&{\$x}(\\\"\" . addbackslashes(\$x) . \"\\\");
			};
			&{\\\$local_self}();
		}\";
	}"
    );

my (@array);

for my $i ( 0 .. 50 )
{
    $#array = -1;
    my $evaled = $p_expr;

    for my $j ( 0 .. $i - 1 )
    {
        $evaled = eval($evaled);
        push @array, $evaled;
    }

    print "------------------------------\n";
    print( ( "eval " x $i ) . "\$p_expr \n" );
    print "------------------------------\n";
    print $evaled;

    print "==============================\n\n\n\n";
}

print(
    ( $array[5] eq $array[15] )
    ? "They are the same."
    : "They are not the same"
    ),
    "\n";
