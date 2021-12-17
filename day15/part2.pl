use strict;
use warnings;

my (@distances, @distance, $max_size, @frontier);

while (<>) {       
    my @input_row = split //, $1 if ($_ =~/(\d+)/);
    my @row = ();
    for (1 .. 5) {
        push @row,  @input_row;
        for ( 0 .. @input_row - 1) {
            $input_row[$_]++;
            $input_row[$_] = 1 if ($input_row[$_] == 10);
        }
    }

    push @distances, [@row];
}

my $initial_size = scalar @distances - 1;

for (1 .. 4) {
    my $increase = $_;
    for my $i (0 .. $initial_size) {
        my @row = ();
        for ( 0 .. (($initial_size + 1) * 5) -1 ) {
            $row[$_] = $distances[$i][$_] + $increase;
            $row[$_] = 1 if ($row[$_] == 10);
            $row[$_] = 2 if ($row[$_] == 11);
            $row[$_] = 3 if ($row[$_] == 12);
            $row[$_] = 4 if ($row[$_] == 13);
        }
        push @distances, [@row];
    }
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

    for (@{$frontier}) {
        my ($y, $x) = split ",", $_;
        if ($distance->[$y][$x] < $lowest) {
            $lowest = $distance->[$y][$x];
            $lowest_node = "$y,$x";
        }
    }

    return $lowest_node;
}

sub updateDistances {
    my ($node, $distances, $distance, $frontier) = @_;
    my ($y, $x) = split ",", $node;

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