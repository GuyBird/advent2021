use strict;
use warnings;

my $filename = 'input';
my @paper;
my $max_x = 0;
my $max_y = 0;

open(FH, '<', $filename) or die $!;
my @input = <FH>;
close(FH);

for(@input){
    if ($_ =~/fold along (\w)=(\d+)/) {
        $max_x = $2 * 2 if (!$max_x and $1 eq "x");
        $max_y = $2 * 2 if (!$max_y and $1 eq "y");
    }
}

map { $paper[$_] = [(0) x ($max_x + 1)] } (0 .. $max_y + 1);

for(@input){
    $paper[$2]->[$1] = 1 if ($_ =~/(\d+),(\d+)/);
    fold(\@paper,$1,$2) if ($_ =~/fold along (\w)=(\d+)/);
}

showState(\@paper, 1, 0);

sub fold {
    my ($paper, $dir, $line) = @_;

    if ($dir eq "y") {
        for my $row (0 .. $line) {
            for ( 0 .. $max_x) {
                $paper->[$row]->[$_] = $paper->[($max_y - $row)]->[$_] if (!$paper->[$row]->[$_]);
            }
        }
        $max_y = $line - 1;
    }
    if ($dir eq "x") {
        for my $row (0 .. $max_y) {
            for (0 .. $line) {
                $paper->[$row]->[$_] = $paper->[($row)]->[($max_x - $_)] if (!$paper->[$row]->[$_]);
            }
        }
        $max_x = $line - 1;
    }
}

sub showState {
    my ($paper, $show_map, $show_dots) = @_;
    my $count;
    for my $row (0 .. $max_y) {
        for (0 .. $max_x) {
            $paper->[$row]->[$_] ? print "#" : print "." if ($show_map);
            $count++ if ($paper->[$row]->[$_]);
        }
        print "\n" if ($show_map);
    }
    print "Dots: " . $count . "\n" if ($show_dots);
}

sub showFullpaper {
    my ($paper) = @_;
    for (@{$paper}) {
        map { $_ ? print "#" : print "." } @{$_};
        print "\n";
    }
}