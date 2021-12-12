#!/usr/bin/perl
use strict;
use warnings;

my $filename = 'input';
open(FH, '<', $filename) or die $!;

my $depth = 0;
my $hor_dis = 0;
while(<FH>){
    if ($_ =~ /(\w+)\W(\d+)/) {
        $hor_dis = $hor_dis + $2 if ($1 eq "forward");
        $depth = $depth + $2 if ($1 eq "down");
        $depth = $depth - $2 if ($1 eq "up");
    } else {
        print "[ERROR] input REGEX did not match\n";
    }
}

print $depth * $hor_dis;

close(FH);
