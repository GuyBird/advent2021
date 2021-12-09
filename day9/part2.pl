use strict;
use warnings;

my $running_total = 0;
my $filename = 'input';

my @heightmap;
my $row_length = 99;

open(FH, '<', $filename) or die $!;
while(<FH>){
    push @heightmap, [split (//, $_)];
}
close(FH);

my $col_length = (scalar @heightmap) - 1;
my @low_points = getLowPoints(\@heightmap);

my @basin_sizes;
for (@low_points) {
    my @basin = ();
    getBasin(\@heightmap,\@basin, $_);
    push @basin_sizes, scalar @basin;
}
my @sorted_sizes = sort { $b <=> $a } @basin_sizes;
print $sorted_sizes[0] * $sorted_sizes[1] * $sorted_sizes[2];

sub getBasin {
    my ($heightmap, $basin, $low_point) = @_;
    my ($x, $y) = split (/\,/, $low_point);

    map {return if ($_ eq $low_point)} @$basin;
    return if ($heightmap[$x][$y] == 9);

    push @$basin, ($low_point);
    getBasin($heightmap, $basin, (($x - 1) . "," . $y)) if ($x != 0);
    getBasin($heightmap, $basin, (($x + 1) . "," . $y)) if ($x != $col_length);
    getBasin($heightmap, $basin, ($x . "," . ($y - 1))) if ($y != 0);
    getBasin($heightmap, $basin, ($x . "," . ($y + 1))) if ($y != $row_length);
}

sub getLowPoints {
    my ($heightmap) = @_;
    my @low_points;
    for my $row_index (0 .. scalar @$heightmap - 1) {
        for my $col_index (0 .. $row_length ) {
            my $low_point = 1;
            if ($row_index != 0) {
                $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[($row_index - 1)]->[$col_index]);
            }
            if ($row_index != $col_length) {
                $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[($row_index + 1)]->[$col_index]);
            }
            if ($col_index != 0) {
                $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[$row_index]->[($col_index - 1)]);
            } 
            if ($col_index != $row_length) {
                $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[$row_index]->[($col_index + 1)]);
            }
            push @low_points, ($row_index . "," . $col_index) if ($low_point);
        }
    }
    return @low_points;
}
