#!/usr/bin/perl

use strict;
use warnings;

my $filename = 'day2_input';
open(FH, '<', $filename) or die $!;

my $depth = 0;
my $hor_dis = 0;
my $aim = 0;
while(<FH>){
    if ($_ =~ /(\w+)\W(\d+)/) {
        if ($1 eq "forward") {
            $hor_dis = $hor_dis + $2;
            $depth = $depth + ($2 * $aim);
        }
        $aim = $aim + $2 if ($1 eq "down");
        $aim = $aim - $2 if ($1 eq "up");
    } else {
        print "[ERROR] password REGEX did not match\n";
    }
}
print $depth * $hor_dis;

close(FH);