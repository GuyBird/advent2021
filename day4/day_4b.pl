use strict;
use warnings;

my @bingo_list;
my @bingo_boards;
my @bingo_bools;
my $row_size = 4;
my $col_size = 4;
my @finished_boards;

my $filename = 'day4_input';
open(FH, '<', $filename) or die $!;

my $board_number = -1; # -1 to account for initial new line
my $row_number = 0;
while(<FH>){
    @bingo_list = split(',', $_) if ($_ =~ /,/);
    if ($_ eq "\n") {
        $board_number++;
        $row_number = 0;
    } elsif ($_ =~ / /) {
        $bingo_boards[$board_number][$row_number] = [ split ' ', $_ ];
        $row_number++;
    }
}
close(FH);

for my $board_index (0 .. scalar @bingo_boards - 1) {
    for my $row_index (0 .. $row_size ) {
        $bingo_bools[$board_index][$row_index] = [(0) x ($row_size + 1)];
    }
}

for my $bingo_number (@bingo_list) {
   for my $board_index (0 .. scalar @bingo_boards - 1) {
       next if(grep(/$board_index/, @finished_boards));
        for my $row_index (0 .. $row_size ) {
            for my $col_index (0 .. $col_size ) {
                if ($bingo_boards[$board_index][$row_index][$col_index] == $bingo_number) {
                    $bingo_bools[$board_index][$row_index][$col_index] = 1;
                    if (bingo($bingo_boards[$board_index],$bingo_bools[$board_index],$row_index,$col_index,$row_size,$col_size,$bingo_number)) {
                        push @finished_boards, $board_index;
                    }
                }
            }
        }
   }
}

sub bingo {
    my ($board, $bools, $row, $col, $row_size, $col_size,$bingo_number) = @_;
    my $bingo = 1;
    for my $current_row (0 .. $row_size) {
        $bingo = 0 if (!$bools->[$current_row][$col]);
    }
    if ($bingo) {
        printBoard($board, $bools, $row_size, $col_size, $bingo_number);
        return 1;
    }

    $bingo = 1;
    for my $current_col (0 .. $col_size) {
        $bingo = 0 if (!$bools->[$row][$current_col]);
    }
    if ($bingo) {
        printBoard($board, $bools, $row_size, $col_size, $bingo_number);
        return 1;
    }
    return 0;
}

sub printBoard {
    my ($board, $bools, $row_size, $col_size, $bingo_number) = @_;
    print "\n";
    my $running_total = 0;
    for my $row_index (0 .. $row_size ) {
        for my $col_index (0 .. $col_size ) {
            my $number = $board->[$row_index][$col_index];
            if ($bools->[$row_index][$col_index]){
                print "*";
            } else {
                print " ";
                $running_total += $number;
            }
            if ($number < 10) {
                print "$number  ";
            } else {
                print "$number ";
            }
        }
        print "\n";
    }
    print "Current Answer = " . ($running_total * $bingo_number);
}