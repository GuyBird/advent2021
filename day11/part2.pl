use strict;
use warnings;

my $flashes;
my $filename = 'input';
my @octopus_map;
my $row_length = 10;

open(FH, '<', $filename) or die $!;
while(<FH>){
    $_ =~  s/[\r\n]+$//;
    push @octopus_map, [split (//, $_)];
}
close(FH);

my ($lit, $step) = 0;
while (!$lit) {
    $lit = 1 if (iterate(\@octopus_map) == 100); 
    $step++;
}
print $step;

sub iterate {
    my ($octopus_map) = @_;
    for my $row (@$octopus_map) {
        for my $octopus (@$row) {
            $octopus++;
        }
    }

    my $finished = 0;
    while (!$finished) {
        $finished = 1;
        for my $x (0 .. (scalar @octopus_map) - 1) {
            for my $y (0 .. $row_length - 1) {
                if ($octopus_map[$x][$y] > 9 and $octopus_map[$x][$y] < 20) {
                    $finished = 0;
                    $octopus_map[$x][$y] = 20;
                    flash(\@octopus_map, $x, $y);
                }
            }
        }
    }

    my $flash_count = 0;
    for my $row (@$octopus_map) {
        for my $octopus (@$row) {
            if ($octopus > 9) {
                $octopus = 0;
                $flash_count++;
            }
        }
    }
    return $flash_count;
}

sub flash {
    my ($octopus_map, $x, $y) = @_;

    $octopus_map->[$x - 1][$y] += 1 if ($x != 0);
    $octopus_map->[$x][$y - 1] += 1 if ($y != 0);
    $octopus_map->[$x + 1][$y] += 1 if ($x != ($row_length - 1));
    $octopus_map->[$x][$y + 1] += 1 if ($y != ($row_length - 1));

    $octopus_map->[$x - 1][$y - 1] += 1 if ($x != 0 and $y != 0);
    $octopus_map->[$x - 1][$y + 1] += 1 if ($x != 0 and $y != ($row_length - 1));
    $octopus_map->[$x + 1][$y - 1] += 1 if ($x != ($row_length - 1) and $y != 0);
    $octopus_map->[$x + 1][$y + 1] += 1 if ($x != ($row_length - 1) and $y != ($row_length - 1));
}

sub printMap {
    my ($octopus_map) = @_;
    for my $row (@$octopus_map) {
        for my $octopus (@$row) {
            print $octopus;
        }
        print "\n";
    }
    print "\n";
}
