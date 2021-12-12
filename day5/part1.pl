#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw( minmax );

my $max_x = 990;
my $max_y = 990;
my @map;

for my $x (0 .. $max_x) {
    $map[$x] = [(0) x ($max_y + 1)];
}

my $filename = 'input';
open(FH, '<', $filename) or die $!;

while(<FH>){
    if ($_ =~ /(\d+),(\d+)\W\-\>\W(\d+),(\d+)/) {
        my $x1 = $1;
        my $y1 = $2;
        my $x2 = $3;
        my $y2 = $4;

        if ($x1 == $x2) {
            my ($min, $max) = minmax($y1, $y2);
            for my $y ($min .. $max) {
                $map[$y][$x1] += 1;
            }
        }
        if ($y1 == $y2) {
            my ($min, $max) = minmax($x1, $x2);
            for my $x ($min .. $max) {
                $map[$y1][$x] += 1;
            }        
        }    
    } else {
        print "[ERROR] input REGEX did not match\n";
    }
}
close(FH);

#printMap(\@map,$max_x,$max_y);
findAnswer(\@map,$max_x,$max_y);

sub printMap {
    my ($map,$max_x,$max_y) = @_;
    print "\n";

    for my $x (0 .. $max_x ) {
        for my $y (0 .. $max_y ) {
            print $map->[$x][$y];
        }
        print "\n";
    }
}

sub findAnswer {
    my ($map,$max_x,$max_y) = @_;
    my $running_total = 0;
    for my $x (0 .. $max_x ) {
        for my $y (0 .. $max_y ) {
            $running_total++ if ($map->[$x][$y] > 1) ;
        }
    }
    print "\nAnswer = $running_total";
}