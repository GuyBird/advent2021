#!/usr/bin/perl
use strict;
use warnings;

my $input_days = 80;

my $filename = 'input';
open(FH, '<', $filename) or die $!;
my @fishes = split ',',<FH>;
close(FH);


for my $day (1 .. $input_days) {
    my $new_fish = 0;
    for my $fish (@fishes) {
        $fish--;
        if ($fish == -1) {
            $fish = 6;
            $new_fish++;
        }
    }
    foreach(1 .. $new_fish) {
        push @fishes, 8;
    }
    #showState(\@fishes, $day);
}

print scalar @fishes;

sub showState {
    my ($fishes, $day) = @_;
    print "After $day day: ";
    for my $fish (@$fishes) {
        print "$fish, ";
    }
    print "\n";
}