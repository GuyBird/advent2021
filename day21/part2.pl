use strict;
use warnings;

my ($states, $a_start, $b_start);
while (<>) {
    if ($_ =~ /Player 1 starting position: (\d+)/) {
        $a_start = $1;
    } elsif ($_ =~ /Player 2 starting position: (\d+)/) {
        $b_start = $1;
    } else {
        print "[ERROR] input REGEX did not match\n";
    }
}

$states->{'a'}->[$a_start]->[$b_start]->[0]->[0] = 1;


# maximum turns = (winning score / 3) * 2
for (1 .. 14) {
    $states = getNewStates($states, "a");
    $states = getNewStates($states, "b");
}

print countUniverses($states, "a");
print ", ";
print countUniverses($states, "b");
print "\n";


sub countUniverses {
    my ($states, $player) = @_;
    my $win_universes = 0;
    for my $a_pos (1 .. 10) {
        if (defined  $states->{$player}->[$a_pos]) {
            for my $b_pos (1 .. 10) {
                if (defined  $states->{$player}->[$a_pos]->[$b_pos]) {
                    for my $a_score (0 .. 30) {
                        if (defined  $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]) {
                            for my $b_score (0 .. 30) {
                                if (defined  $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]->[$b_score]) {
                                    $win_universes += $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]->[$b_score];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return $win_universes;
}


sub getNewStates {
    my ($states, $player) = @_;
    for my $a_pos (1 .. 10) {
        if (defined  $states->{$player}->[$a_pos]) {
            for my $b_pos (1 .. 10) {
                if (defined  $states->{$player}->[$a_pos]->[$b_pos]) {
                    for my $a_score (0 .. 20) {
                        if (defined  $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]) {
                            for my $b_score (0 .. 20) {
                                if (defined  $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]->[$b_score]) {
                                    $states = createUniverses($states, $player, $a_pos, $b_pos , $a_score, $b_score)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return $states;
}

sub createUniverses {
    my ($states, $player, $a_pos, $b_pos , $a_score, $b_score) = @_;

    my $old_universes = $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]->[$b_score];
    return $states if ($old_universes == 0);
    $states->{$player}->[$a_pos]->[$b_pos]->[$a_score]->[$b_score] = 0;

    if ($player eq "a") {

        my $new_position = getPosition($a_pos, 3);
        $states->{"b"}->[$new_position]->[$b_pos]->[($a_score + $new_position)]->[$b_score] += $old_universes * 1;

        $new_position = getPosition($a_pos, 4);
        $states->{"b"}->[$new_position]->[$b_pos]->[($a_score + $new_position)]->[$b_score] += $old_universes * 3;

        $new_position = getPosition($a_pos, 5);
        $states->{"b"}->[$new_position]->[$b_pos]->[($a_score + $new_position)]->[$b_score] += $old_universes * 6;

        $new_position = getPosition($a_pos, 6);
        $states->{"b"}->[$new_position]->[$b_pos]->[($a_score + $new_position)]->[$b_score] += $old_universes * 7;

        $new_position = getPosition($a_pos, 7);
        $states->{"b"}->[$new_position]->[$b_pos]->[($a_score + $new_position)]->[$b_score] += $old_universes * 6;

        $new_position = getPosition($a_pos, 8);
        $states->{"b"}->[$new_position]->[$b_pos]->[($a_score + $new_position)]->[$b_score] += $old_universes * 3;

        $new_position = getPosition($a_pos, 9);
        $states->{"b"}->[$new_position]->[$b_pos]->[$a_score + $new_position]->[$b_score] += $old_universes * 1;

    }

    if ($player eq "b") {
        my $new_position = getPosition($b_pos, 3);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 1;

        $new_position = getPosition($b_pos, 4);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 3;

        $new_position = getPosition($b_pos, 5);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 6;

        $new_position = getPosition($b_pos, 6);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 7;

        $new_position = getPosition($b_pos, 7);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 6;

        $new_position = getPosition($b_pos, 8);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 3;

        $new_position = getPosition($b_pos, 9);
        $states->{"a"}->[$a_pos]->[$new_position]->[$a_score]->[($b_score + $new_position)] += $old_universes * 1;
    }


    return $states;
}

sub getPosition {
    my ($position, $movement) = @_;
    my $new_position = ($position + $movement) % 10;
    return 10 if (!$new_position);
    return $new_position;
}