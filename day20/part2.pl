use strict;
use warnings;

my @lookup;
my $image;
my $steps = 50;
my $row = $steps;
my $reading_image = 0;

while (<>) {
    $_ =~  s/[\r\n]+$//;
    if ($_ eq "") {
        $reading_image = 1;
        next;
    }
    if (!$reading_image) {
        map {$_ eq "#" ? push @lookup, 1 : push @lookup, 0} (split (//, $_));
    }
    else {
        push @{$image->[$row]}, (0) x $steps;
        map {$_ eq "#" ?  push @{$image->[$row]}, 1 : push @{$image->[$row]}, 0} (split (//, $_));
        push @{$image->[$row]}, (0) x $steps;
        $row++;
    }
}

my $max_col = scalar @{$image->[$steps]};

map {push @{$image->[$_]}, (0) x $max_col} (0 .. $steps - 1);
for (($row) .. ($row + $steps - 1)) {
    push @{$image->[$_]}, (0) x $max_col;
    $row++;
}

my $outside_elements = 0;
map {($image, $outside_elements) = step($image, $row, $max_col, \@lookup, $outside_elements)} (1 .. $steps);
showImage($image, $row, $max_col, 1);

sub step {
    my ($image, $max_row, $max_col, $lookup, $outside_elements) = @_;
    my $newimage;
    for my $row (0 .. $max_row - 1) {
        for my $col (0 .. $max_col - 1) {

            my @kernel = ();
            $kernel[0] = ($row == 0 or $col == 0)              ? $outside_elements : $image->[($row - 1)]->[($col - 1)];
            $kernel[1] = $row == 0                             ? $outside_elements : $image->[($row - 1)]->[$col];
            $kernel[2] = ($row == 0 or $col == $max_col - 1)   ? $outside_elements :  $image->[($row - 1)]->[($col + 1)];
            $kernel[3] = $col == 0                             ? $outside_elements :  $image->[$row]->[($col - 1)];
            $kernel[4] = $image->[$row]->[$col];
            $kernel[5] = ($col == $max_col - 1)                ? $outside_elements : $image->[$row]->[($col + 1)];
            $kernel[6] = ($row == ($max_row - 1) or $col == 0) ? $outside_elements : $image->[($row + 1)]->[($col - 1)];
            $kernel[7] = ($row == ($max_row - 1))              ? $outside_elements : $image->[($row + 1)]->[$col];
            $kernel[8] = ($row == ($max_row - 1) or $col == $max_col - 1) 
                                                               ? $outside_elements : $image->[($row + 1)]->[($col + 1)];
            $newimage->[$row]->[$col] = $lookup->[(eval("0b" . join "", @kernel))];
        }
    }

    return $newimage, $lookup->[(eval("0b" . ($outside_elements) x 9))];
}


sub showImage {
    my ($image, $max_row, $max_col, $just_count) = @_;
    my $count = 0;
    for my $row (0 .. $max_row - 1) {
        for my $col (0 .. $max_col - 1) {
            if ($image->[$row]->[$col]) {
                print "#" if (!$just_count);
                $count++;
            } else {
                print "." if (!$just_count);
            }
        }
        print "\n" if (!$just_count);
    }
    print "Lit Pixels: $count\n";
}