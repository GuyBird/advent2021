use strict;
use warnings;

my ($y_vel, $min_y, $max_y);
while (<>) {
    $min_y = $3 if ($_ =~ /target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/);
}

$y_vel = abs($min_y) - 1;

while ($y_vel > 0) {
    $max_y += $y_vel;
    $y_vel--;
}
print $max_y;