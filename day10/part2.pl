use strict;
use warnings;

my @running_total;
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
    if (!$illegal_op) {
        my $score = 0;
        my $len = scalar @stack - 1;
        for (0 .. $len) {
            $score = ($score * 5 ) + 1 if ($stack[$len - $_] eq "(");
            $score = ($score * 5 ) + 2 if ($stack[$len - $_]  eq "[");
            $score = ($score * 5 ) + 3 if ($stack[$len - $_]  eq "{");
            $score = ($score * 5 ) + 4 if ($stack[$len - $_]  eq "<");
        }
        push @running_total, $score;
    }
}
close(FH);

my @sorted = sort {$a <=> $b} @running_total;
print @sorted[(int scalar @sorted/2)] 