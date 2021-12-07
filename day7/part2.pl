use strict;
use warnings;
use Data::Dumper;


my $filename = 'input';
open(FH, '<', $filename) or die $!;
my @points = split ',',<FH>;
close(FH);

my $min = 0;
my $max = 2000;

while ($min != $max) {
    ($min, $max) = iterate($min,$max,\@points);
    #print "$min -> $max\n";
}

print total_Fuel(\@points,$min);

sub iterate {
    my ($min, $max, $points) = @_;
    my $mid = $min + int(($max - $min)/2);

    my $min_t = total_Fuel($points, $min);
    my $max_t = total_Fuel($points, $max);
    my $mid_t = total_Fuel($points, $mid);

    if ($min_t < $max_t) {
        $max = $mid;
    } else {
        if ($min == $mid) {
            $min = $max
        } else {
            $min = $mid;
        }
    }
    return $min,$max;
}

sub total_Fuel {
    my ($points, $position) = @_;
    my $running_total = 0;
    foreach (@$points) {
        my $n = abs($_ - $position);
        my $fuel = (($n**2)+ $n)/2;
        $running_total += $fuel;
    }
    return $running_total;
}

sub total_Fuel2 {
    my ($points, $position) = @_;
    my $running_total = 0;
    foreach (@$points) { $running_total+= abs($_ - $position) }
    return $running_total;
}

sub iterate2 {
    my ($min, $max, $points) = @_;
    my $mid = $min + int(($max - $min)/2);

    my $min_t = total_Fuel($points, $min);
    my $max_t = total_Fuel($points, $max);
    my $mid_t = total_Fuel($points, $mid);

    if ($min_t < $max_t) {
        $max = $mid;
    } else {
        $min = $mid;
    }
    return $min,$max;
}