use strict;
use warnings;

my ($min_y, $max_y, $min_x, $max_x);
while (<>) {
    ($min_x, $max_x, $min_y, $max_y) = ($1, $2, $3, $4) if ($_ =~ /target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/) ;
}

my $vel_count = 0;
# very ugly bruteforce - fast though
for my $y_vel ($min_y ..  (abs($min_y) - 1)) {
    for (0 .. $max_x) {
        $vel_count++ if (checkVel($_, $y_vel));
    }
}

print $vel_count;

sub checkVel {
    my ($x_vel, $y_vel) = @_;
    my ($x, $y) = (0, 0);

    while ($x < $max_x and $y > $min_y) {
        $x += $x_vel;
        $y += $y_vel;
        $y_vel -= 1;
        $x_vel -= 1 if ($x_vel > 0);
        return 1 if ($x >= $min_x and $x <= $max_x and $y >= $min_y and $y <= $max_y);
    }
    return 0;
}