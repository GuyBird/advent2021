use strict;
use warnings;

my $input_days = 256;
my @fishes = (0) x 9;

my $filename = 'day6_input';
open(FH, '<', $filename) or die $!;
my @inputs = split ',',<FH>;
close(FH);

for my $input (@inputs) {
    $fishes[$input]++;
}

for my $day (1 .. $input_days) {
    my $new_fish = $fishes[0];
    for my $age (0 .. scalar @fishes - 2){
        $fishes[$age] =  ($fishes[$age +  1]);
    }
    $fishes[8] = $new_fish;
    $fishes[6] += $new_fish;
}

my $answer;
foreach(@fishes) { $answer += $_ }
print $answer;

sub showState {
    my ($fishes, $day) = @_;
    print "After $day day: ";
    for my $fish (@$fishes) {
        print "$fish, ";
    }
    print "\n";
}