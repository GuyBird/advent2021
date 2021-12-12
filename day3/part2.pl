#!/usr/bin/perl
use strict;
use warnings;

my $filename = 'input';

open(FH, '<', $filename) or die $!;
my @numbers = <FH>;
close(FH);

my $size = length($numbers[0]);
my @zero_count = (0) x $size;
my @one_count = (0) x $size;
my @swap;

for my $index (0 .. $size - 2) {
    for my $number (@numbers) {
        my $digit = substr $number, $index, 1;
        $zero_count[$index]++ if ($digit eq 0);
        $one_count[$index]++ if ($digit eq 1);
    }
    
    my ($most_common, $least_common);
    if ($zero_count[$index] > $one_count[$index]) {
        $most_common = 0;
        $least_common = 1;
    } else {
        $most_common = 1;
        $least_common = 0;
    }

    for my $number (0 .. scalar @numbers - 1) {
        my $digit = substr $numbers[$number], $index, 1;
        if ($digit eq $least_common) {
            push @swap, $numbers[$number];
        }
    }

    @numbers = ();
    splice @numbers, 0, 0, @swap;
    @swap = ();
    if (scalar @numbers == 1) {
        last;
    }
}

my $answer = $numbers[0];
print eval("0b$answer");