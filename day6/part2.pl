#!/usr/bin/perl
use strict;
use warnings;

my $input_days = 256;
my @fishes = (0) x 9;

my $filename = 'input';
open(FH, '<', $filename) or die $!;
my @inputs = split ',',<FH>;
close(FH);

map {$fishes[$_]++} @inputs;

for my $day (1 .. $input_days) {
    my $new_fish = $fishes[0];
    map {$fishes[$_] =  ($fishes[$_ +  1]) } (0 .. scalar @fishes - 2);
    $fishes[8] = $new_fish;
    $fishes[6] += $new_fish;
}

my $answer;
foreach(@fishes) { $answer += $_ }
print $answer;

sub showState {
    my ($fishes, $day) = @_;
    print "After $day day: ";
    map { print "$_, " } @$fishes;
    print "\n";
}