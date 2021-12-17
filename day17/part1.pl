use strict;
use warnings;

#x position can be ignored, horizontal and vertical velocities are decoupled
my ($y_vel, $min_y);

while (<>) {
    if ($_ =~ /target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/) {
        $min_y = $3;
    } else {
        print "[ERROR] input REGEX did not match\n";
    }

}

#velocity decreases by 1 each time, ans starts at zero, 
# therefore it will always pass theough 0 on the way down.
#Thus the higest y velocity possible will pass through zero
# on the step before hitting the target area, at the lower 
# bound of the area.
# The y velocity of the object at the final step will therefore
# be equal to -(starting velocity + 1)

$y_vel = abs($min_y) - 1;

my $max_y = 0;

while ($y_vel > 0) {
    $max_y += $y_vel;
    $y_vel--;
}
print $max_y;