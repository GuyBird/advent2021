use strict;
use warnings;

my $running_total = 0;
my $filename = 'test_input';

my @heightmap;
my $row_length = 9;
my $row = 1;

$heightmap[0] = [(9) x ($row_length + 1)];
open(FH, '<', $filename) or die $!;
while(<FH>){
    $heightmap[$row] = [split (//, $_)];
    $row++;
}
close(FH);
$heightmap[$row] = [(9) x ($row_length + 1)];

for my $row_index (1 .. scalar @heightmap - 2) {
    for my $col_index (0 .. $row_length ) {
        my $low_point = 1;
        $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[($row_index - 1)]->[$col_index]);
        $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[($row_index + 1)]->[$col_index]);

        if ($col_index != 0) {
            $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[$row_index]->[($col_index - 1)]);
        } 
        if ($col_index != $row_length) {
            $low_point = 0 if ($heightmap[$row_index]->[$col_index] >= $heightmap[$row_index]->[($col_index + 1)]);
        } 
        $running_total += ($heightmap[$row_index]->[$col_index] + 1) if ($low_point);
    }
}
print $running_total;
