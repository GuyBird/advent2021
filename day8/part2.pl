use strict;
use warnings;

my $running_total = 0;
my $filename = "input";
open(FH, '<', $filename) or die $!;

while(<FH>){
     if ($_ =~ /(.*)\|(.*)/) {
        my @digits = split " ", $1;
        my @answer_digits = split " ", $2;

        my $mapping = getMapping(\@digits);        
        my $decoded_number = decodeAnswer(\@answer_digits, $mapping);
        $running_total += $decoded_number;
        } else {
        print "[ERROR] input REGEX did not match\n";
    }
}
close(FH);

print $running_total;

sub getMapping {
    my ($digits) = @_;
    my %mapping;

    for my $digit (@$digits) {
        my $digit_len = length($digit);
        $mapping{1} = $digit if ( $digit_len == 2);
        $mapping{4} = $digit if ( $digit_len == 4);
        $mapping{7} = $digit if ( $digit_len == 3);
        $mapping{8} = $digit if ( $digit_len == 7);
    }

    for my $digit (@$digits) {
        if (length($digit) == 6 ) {
            my $contained = 0;
            foreach (split //, $digit) { $contained++ if ($mapping{4} =~ /$_/); }
            $mapping{9} = $digit if ($contained == 4);
        }
    }

    for my $digit (@$digits) {
        if (length($digit) == 6 and $digit ne $mapping{9}) {
            my $contained = 0;
            foreach (split //, $digit) {$contained++ if ($mapping{1} =~ /$_/); }
            $mapping{0} = $digit if ($contained == 2);
            $mapping{6} = $digit if ($contained == 1);
        }
    }

    for my $digit (@$digits) {
        if (length($digit) == 5) {
            my $contained = 0;
            foreach (split //, $digit) { $contained++ if ($mapping{6} =~ /$_/); }
            $mapping{5} = $digit if ($contained == 5);
        }
    }

    for my $digit (@$digits) {
        if (length($digit) == 5 and $digit ne $mapping{5}) {
            my $contained = 0;
            foreach (split //, $digit) { $contained++ if ($mapping{1} =~ /$_/); }
            $mapping{2} = $digit if ($contained == 1);
            $mapping{3} = $digit if ($contained == 2);
        }
    }
    foreach (0 .. 9) { $mapping{$_} = join '', sort( split('', $mapping{$_}) );}
    return \%mapping;
}

sub decodeAnswer {
    my ($digits, $mapping) = @_;

    my $answer = "";
    for my $digit (@$digits) {
        my $sorted_digit = join '', sort( split('', $digit) );
        for my $number (0 .. 9) {
            $answer .= $number if($sorted_digit eq $mapping->{$number});
        }
    }
    return $answer;
}