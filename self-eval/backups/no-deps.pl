#!/usr/bin/perl

use strict;

sub old_addbackslashes
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

sub addbackslashes
{
    my $s = shift;
    $s =~ s/([\$\\\"])/\\$1/g;
    $s;
}

my $p_expr = & {
    sub {
        my $x = shift;
        return
        "eval {
            my \$local_self;
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
            my \\\$local_self;
            \\\$local_self = sub {
                &{\$x}(\\\"\" . addbackslashes(\$x) . \"\\\");
            };
            &{\\\$local_self}();
        }\";
    }"
);

my $p_sub_expr = <<"EOF";
sub {
    my \$x = shift;
    return
    \"eval {
        my \\\$local_self;
        \\\$local_self = sub {
            &{\$x}(\\\"\" . addbackslashes(\$x) . \"\\\");
        };
        &{\\\$local_self}();
    }\";
}
EOF

$p_sub_expr = <<"EOF";
sub {
    my \$x = shift;
    my \$x_escaped = \$x;
    \$x_escaped =~ s/([\\\$\\\\\\"])/\\\\\$1/g;
    return
    \"eval {
        my \\\$local_self;c
        \\\$local_self = sub {
            &{\$x}(\\\"\$x_escaped\\\");
        };
        &{\\\$local_self}();
    }\";
}
EOF

$p_expr = "&{$p_sub_expr}(\"" . addbackslashes($p_sub_expr) . "\")";

my ($a, $b, @array);

my $evaled = eval($p_expr);
my $evaled_twice = eval($evaled);
if ($evaled eq $evaled_twice)
{
    print "They are the same.\n";
    print "The expression is:\n<<<\n$evaled\n>>>\n";
}
else
{
    print "They are not the same.\n";
}

