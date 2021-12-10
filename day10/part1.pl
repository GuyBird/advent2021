use strict;
use warnings;

my $running_total = 0;
my $filename = 'input';

open(FH, '<', $filename) or die $!;
while(<FH>){
    my @line = split (//, $_);
    my @stack = ();
    my $illegal_op = 0;
    for my $op (@line) {
        last if ($illegal_op);
        if ($op eq "{" or $op eq "[" or $op eq "<" or $op eq "(") {
            push @stack,$op;
        } elsif ($op eq ")") {
            if ($stack[-1] eq "(") {
                pop @stack;
            } else {
                $illegal_op = 3;
            }
        } elsif ($op eq "]") {
            if ($stack[-1] eq "[") {
                pop @stack;
            } else {
                $illegal_op = 57;
            }
        } elsif ($op eq "}") {
            if ($stack[-1] eq "{") {
                pop @stack;
            } else {
                $illegal_op = 1197;
            }
        } elsif ($op eq ">") {
            if ($stack[-1] eq "<") {
                pop @stack;
            } else {
                $illegal_op = 25137;
            }
        } 
    }
    $running_total += $illegal_op;
}
close(FH);

print $running_total;