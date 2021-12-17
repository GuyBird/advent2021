use strict;
use warnings;

my (@distances, @distance, $max_size, @frontier);

while (<>) {
    push @distances, [split //, $1] if ($_ =~/(\d+)/);
}

$max_size = scalar @distances - 1;
map { $distance[$_]= [(99999999999999999999999999) x ($max_size + 1)] } ( 0 .. scalar @distances - 1);

$distance[0][0] = 0;
push @frontier, ("0,0");

my $finished = 0;
while (!$finished) {
    $finished = updateDistances(findLowestUnvisited(\@distance, \@frontier), \@distances, \@distance, \@frontier);
}

print $distance[$max_size][$max_size];

sub showMap {
    my ($map) = @_;
    for my $row ( 0 .. scalar @{$map} - 1) {
        for ( 0 .. scalar @{$map->[$row]} - 1) {
            print  $map->[$row][$_] . ",";
        }
        print "\n";
    }
}

sub findLowestUnvisited {
    my ($distance, $frontier) = @_;
    my $lowest = 99999999999999999999999999;
    my $lowest_node;

    for  ( @{$frontier}) {
        my ($y, $x);
        if ($_ =~/(\d+),(\d+)/) {
            $y = $1;
            $x = $2;
        }
        if ($distance->[$y][$x] < $lowest) {
            $lowest = $distance->[$y][$x];
            $lowest_node = "$y,$x";
        }
    }

    return $lowest_node;
}

sub updateDistances {
    my ($node, $distances, $distance, $frontier) = @_;
    my ($y, $x);
    if ($node =~/(\d+),(\d+)/) {
        $y = $1;
        $x = $2;
    }

    unless($y == 0) {
        if ($distance->[$y - 1][$x] > ($distance->[$y][$x] + $distances->[$y - 1][$x])) {
            $distance->[$y - 1][$x] = $distance->[$y][$x] + $distances->[$y - 1][$x];
            push @{$frontier}, (($y - 1) . "," . $x);
        }
    }

    unless($x == 0) {
        if ($distance->[$y][$x - 1] > ($distance->[$y][$x] + $distances->[$y][$x - 1])) {
            $distance->[$y][$x - 1] = $distance->[$y][$x] + $distances->[$y][$x - 1];
            push @{$frontier}, ($y . "," . ($x - 1));
        }
    }

    unless($y == $max_size) {
        if ($distance->[$y + 1][$x] > ($distance->[$y][$x] + $distances->[$y + 1][$x])) {
            $distance->[$y + 1][$x] = $distance->[$y][$x] + $distances->[$y + 1][$x];
            push @{$frontier}, (($y + 1) . "," . $x);
        }
    }

    unless($x == $max_size) {
        if ($distance->[$y][$x + 1] > ($distance->[$y][$x] + $distances->[$y][$x + 1])) {
            $distance->[$y][$x + 1] = $distance->[$y][$x] + $distances->[$y][$x + 1];
            push @{$frontier}, ($y . "," . ($x + 1));
        }
    }    

    my $index = 0;
    $index++ until ($frontier->[$index] eq $node);
    splice(@{$frontier}, $index, 1);

    return ($y == $max_size and $x == $max_size);
}