use strict;
use warnings;

my @input_hex = split //, <>;
my $packet;
my $global_version_count = 0;

map {$packet .= sprintf("%04b", hex($_))} (@input_hex);
my @packet = split //, $packet;

my $value = parse_packet(\@packet);
print $value;
print $global_version_count;

sub parse_packet {
    my ($packet) = @_;

    my $v = read_bits($packet, 3);
    $global_version_count += $v;
    my $t = read_bits($packet, 3);
    
    if ($t == 4) {
        return parse_literal_value_packet($packet);
    }
    return parse_opetations_packet($packet, $t);
}

sub parse_opetations_packet {
    my ($packet, $t) = @_;

    my $l = read_bits($packet, 1);
    my @subpackets;

    if ($l) {
        my $sub_packets = read_bits($packet, 11);
        for (1 .. $sub_packets) {
            push(@subpackets, parse_packet($packet));
        }
    } else {
        my $sub_packet_bits = read_bits($packet, 15);
        my $end_packet_length = scalar @{$packet} - $sub_packet_bits;
        while (scalar @{$packet} >  $end_packet_length) {
            push(@subpackets, parse_packet($packet));
        }
    }
}

sub parse_literal_value_packet {
    my ($packet) = @_;
    my $reading = 1;
    my $literal_number = "";

    while ($reading) {
        $reading = read_bits($packet, 1); 
        for (1 .. 4) {
            # read one at a time so we don't convert to decimal too early
            $literal_number .= read_bits($packet, 1); 
        }
    }
    return eval("0b" . $literal_number);
}

sub read_bits {
    my ($packet ,$bits) = @_;

    my $read_bits = "";
    for (1 .. $bits) {
        $read_bits .= shift @{$packet};
    }
    return eval("0b" . $read_bits);
}

sub printPacket {
    my ($packet) = @_;
    foreach my $bit (@{$packet}) {
        print $bit;
    }
    print "\n";
}