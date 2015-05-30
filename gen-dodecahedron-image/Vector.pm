#!/usr/bin/perl

package Vector;

use strict;

use overload
    '+' => sub {
        my @coords;
        my $a;
        for($a=0;$a<3;$a++)
        {
            $coords[$a] = $_[0]->{coords}->[$a] + $_[1]->{coords}->[$a];
        }
        return new Vector(@coords);
    },
    '*' => sub {
        if ((ref($_[1]) eq 'Vector') && (ref($_[0]) ne 'Vector'))
        {
            return $_[1]*$_[0];
        }
        elsif (ref($_[1]) eq 'Vector')
        {
            my @a = @{$_[0]->{coords}};
            my @b = @{$_[1]->{coords}};
            return new Vector(
                              $a[1]*$b[2]-$a[2]*$b[1],
                              $a[2]*$b[0]-$a[0]*$b[2],
                              $a[0]*$b[1]-$a[1]*$b[0]
                              );                              
        }
        else
        {
            return new Vector(map { $_*$_[1]; } @{$_[0]->{coords}});
        }
    },
    '/' => sub {
        return new Vector(map { $_/$_[1]; } @{$_[0]->{coords}});
    },
    '-' => sub {
        return $_[0] + (-1)*$_[1];
    },
    ;

sub initialize
{
    my $self = shift;
    $self->{coords} = [0,0,0];
}

sub new {
    my $class = shift;
    my $self = { };
    bless $self, $class;
    $self->initialize();

    if (ref($_[0]) eq 'Vector')
    {
        $self->{coords} = [ @{$_[0]->{coords}}];
    }
    else
    {
        my @a = (@_,0,0,0);
        $self->{coords} = [ @a[0..2] ] ;
    }
    
    return $self;
}

sub len
{
    my $sum=0, $a;
    my $self = shift;
    foreach $a (@{$self->{coords}})
    {
        $sum += $a*$a;
    }
    return sqrt($sum);
}

sub to_2d
{
    my $a_len = 800;
    my $b_len = 100;
    my $self = shift();
    my @a = @{$self->{coords}};
    return (int ($a[0]*$a_len/($a[2]+$b_len)) + 100,
            int ($a[1]*$a_len/($a[2]+$b_len)) + 100);
}

sub rotate
{
    my $self = shift(@_);
    my $other = shift(@_);
    my $angle = shift(@_);

    my $perpend = ($other*$self);
    $perpend *= $self->len() / $perpend->len();

    return (cos($angle)*$self + sin($angle)*$perpend);
}

sub p
{
    my $self = shift(@_);
    print join(" ", @{$self->{coords}}), " ", $self->len(), "\n";
}

1;