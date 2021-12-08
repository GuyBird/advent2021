use strict;
use warnings;

my $running_total = 0;

my $filename = 'input';
open(FH, '<', $filename) or die $!;

while(<FH>){
     if ($_ =~ /\|(.*)/) {
        my @digits = split " ", $1;
        foreach (@digits) {
            my $digit_len = length($_);
            $running_total++ if ($digit_len == 2 or $digit_len == 4 or $digit_len == 3 or $digit_len == 7);
        }
    } else {
        print "[ERROR] password REGEX did not match\n";
    }
}
close(FH);

print $running_total;