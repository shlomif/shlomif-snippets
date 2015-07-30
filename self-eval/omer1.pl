use strict;

sub addbackslashes
{
	my $string = shift;
	my $out = "";
	my $char;

	foreach $char (split(//, $string))
	{
		if ($char =~ /[\$\\\"]/)
		{
			$out .= "\\";
		}
		$out .= $char;
	}
	return $out;
}

my $p_expr = & {
	sub {
		my $x = shift;
		return
		"eval {
			my \$local_self ;
			\$local_self = sub {
				&{$x}(\"" . addbackslashes($x) . "\");
			};
			&{\$local_self}();
		}";
	}
	}
(
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

my ($a, $b, @array);

for($a=0;$a<50;$a++)
{
	my $evaled;

	$evaled = $p_expr;

	for($b=0;$b<$a;$b++)
	{
		$evaled = eval($evaled);
		push @array, $evaled;
	}

	print "------------------------------\n";
	print (("eval " x $a) . "\$p_expr \n");
	print "------------------------------\n";
	print $evaled;

	print "==============================\n\n\n\n";
}


print (($array[5] eq $array[15]) ?
	"They are the same." :
	"They are not the same"), "\n";
