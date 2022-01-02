use strict;
use warnings;

my $map;
my $row = 0;
while (<>) {
    $_ =~  s/[\r\n]+$//;
    $map->[$row] = [split (//, $_)];
    $row++;
}

my $max_row = $row;
my $max_column = scalar @{$map->[0]};

my $step_count = 0;
my $moved = 1;
while ($moved) {
    ($map, $moved) = step($map, $max_row, $max_column);
    $step_count++;
}

print $step_count; 

sub update {
    my ($map, $update_stack, $new_value) = @_;

    map {$map->[$1]->[$2] = $new_value if ($_ =~ /(\d+),(\d+)/)} (@{$update_stack});
    return $map;
}

sub step {
    my ($map, $max_row, $max_column) = @_;
    my $moved = 0;
    my @update_cucumbers;
    my @update_free;

    for my $row (0 .. ($max_row - 1)) {
        for my $col (0 .. ($max_column - 1)) {
            if ($map->[$row]->[$col] eq ">") {
                if ($col ==  ($max_column - 1)) {
                    if ($map->[$row]->[0] eq ".") {
                        push @update_cucumbers, ($row . ",0");
                        push @update_free, ($row . "," . $col);
                        $moved = 1;
                    }
                } else {
                    if ($map->[$row]->[($col + 1)] eq ".") {
                        push @update_cucumbers, ($row . "," . ($col + 1));
                        push @update_free, ($row . "," . $col);
                        $moved = 1;
                    }
                }
            }
        }
    }

    $map = update($map, \@update_free, ".");
    $map = update($map, \@update_cucumbers, ">");

    @update_free = ();
    @update_cucumbers = ();

    for my $col (0 .. $max_column - 1) {
        for my $row (0 .. $max_row - 1) {
            if ($map->[$row]->[$col] eq "v") {
                if ($row ==  $max_row - 1) {
                    if ($map->[0]->[$col] eq ".") {
                        push @update_cucumbers, ("0," . $col);
                        push @update_free, ($row . "," . $col);
                        $moved = 1;
                    }
                } else {
                    if ($map->[($row + 1)]->[$col] eq ".") {
                        push @update_cucumbers, (($row + 1) . "," . $col);
                        push @update_free, ($row . "," . $col);
                        $moved = 1;
                    }
                }
            }
        }
    }

    $map = update($map, \@update_free, ".");
    $map = update($map, \@update_cucumbers, "v");

    return $map, $moved;
}

sub showMap {
    my ($map, $max_row, $max_column) = @_;
    for my $row (0 .. $max_row - 1) {
        for my $col (0 .. $max_column - 1) {
            print $map->[$row]->[$col];
        }
        print "\n";
    }
    print "\n";
}