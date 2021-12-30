use strict;
use warnings;

my ($player1_pos, $player2_pos, $player1_score, $player2_score, $die_val, $dice_rolls);

while (<>) {
    if ($_ =~ /Player 1 starting position: (\d+)/) {
        $player1_pos = $1;
    } elsif ($_ =~ /Player 2 starting position: (\d+)/) {
        $player2_pos = $1;
    } else {
        print "[ERROR] input REGEX did not match\n";
    }
}


while (1) {
    ($die_val, $player1_pos)= take_turn($die_val, $player1_pos);
    $player1_score += $player1_pos;
    if ($player1_score >= 1000) {
        print $player2_score * $dice_rolls . "\n";
        last;
    }
    ($die_val, $player2_pos)= take_turn($die_val, $player2_pos);
    $player2_score += $player2_pos;
    if ($player2_score >= 1000) {
        print $player1_score * $dice_rolls . "\n";
        last;
    }
}

sub take_turn {
    my ($die_val, $position) = @_;
    my $value = 0;
    for (1 .. 3) {
        $die_val = roll_determ_die($die_val);
        $value += $die_val;
    }
    my $new_pos = ($position + $value) % 10;
    $new_pos = 10 if (!$new_pos);

    return $die_val, $new_pos;
}

sub roll_determ_die {
    my ($die_val) = @_;
    $die_val += 1;
    $die_val = 1 if ($die_val == 101);
    $dice_rolls++;
    return $die_val;
}