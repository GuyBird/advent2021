use strict;
use warnings;

my ($polymer, %polymer_map, $last_digit);
my $iterations = 10;

while (<>) {
    if ($_ =~/(\w{3,})/) {
        my @input_polymer = split //, $1;
        map { $polymer->{$input_polymer[$_]}{$input_polymer[$_ + 1]} += 1 } (0 .. scalar @input_polymer - 2);
        $last_digit = $input_polymer[-1];
    }
    $polymer_map{$1}{$2} = $3 if ($_ =~/(\w)(\w) -> (\w)/);
}


map {$polymer = iterate($polymer, \%polymer_map)} (1 .. $iterations);
getAnswer(%{$polymer});

sub iterate {
    my ($polymer, $polymer_map) = @_;
    my %new_polymer;
    for my $digit (keys %{$polymer}) {
        for (keys %{$polymer->{$digit}}) {
            $new_polymer{$digit}{$polymer_map{$digit}{$_}} += $polymer->{$digit}{$_};
            $new_polymer{$polymer_map{$digit}{$_}}{$_} += $polymer->{$digit}{$_};
        }
    }
    return \%new_polymer;
}

sub getAnswer {
    my (%polymer) = @_;
    my $min_count = 999999999999999999;
    my $max_count = 0;

    for my $digit (keys %polymer) {
        my $count = 0;
        map { $count+= $polymer{$digit}{$_} } (keys %{$polymer{$digit}});
        $count++ if ($digit eq $last_digit);

        $min_count = $count if ($count < $min_count);
        $max_count = $count if ($count > $max_count);
    }
    print "answer: " . ($max_count - $min_count);
}
