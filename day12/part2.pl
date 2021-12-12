use strict;
use warnings;

my $filename = 'input';
my %paths;
my @full_paths;

open(FH, '<', $filename) or die $!;
while(<FH>){
    if ($_ =~ /(\w+)\-(\w+)/) {
        push @{ $paths{$1} }, $2;
        push @{ $paths{$2} }, $1;
    } else {
        print "[ERROR] input REGEX did not match\n";
    }
}
close(FH);

for (@{$paths{"start"}}) {
    @{$paths{$_}} = grep {$_ ne "start"}  @{$paths{$_}};
}

travel(\%paths, \@full_paths, "start", "", "");
print scalar @full_paths;


sub travel {
    my ($paths, $full_paths, $node, $visited_small_nodes, $path) = @_;

    my @small_nodes = split ",", $visited_small_nodes;
    my $small_count = 0;
    map {$small_count++ if ($_ eq $node) } @small_nodes;
    return if ($small_count == 2);
    if ($small_count == 1) {
        my %small;
        foreach (@small_nodes) {
            return if (defined $small{$_} and $small{$_} == 1);
            $small{$_}++;
        }
    }

    $path .= "$node,";
    $visited_small_nodes .= "$node," if ($node =~ /[a-z]+/);
    
    if ($node eq "end") {
        push @{$full_paths}, $path; 
        return;
    }

    map {travel($paths, $full_paths, $_, $visited_small_nodes, $path)} @{$paths{$node}};
}
