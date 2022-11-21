use strict;
use warnings;
use List::Util qw( min max );

my @input_hex = split //, <>;
my $packet;

map {$packet .= sprintf("%04b", hex($_))} (@input_hex);
my @packet = split //, $packet;

my $value = parse_packet(\@packet);
print $value;

sub parse_packet {
    my ($packet) = @_;

    my $v = read_bits($packet, 3);
    my $t = read_bits($packet, 3);
    
    return parse_literal_value_packet($packet) if ($t == 4);
    return parse_opetations_packet($packet, $t);
}

sub parse_opetations_packet {
    my ($packet, $t) = @_;
    my @subpackets;

    if (read_bits($packet, 1)) {
        my $sub_packets = read_bits($packet, 11);
        map {push(@subpackets, parse_packet($packet))} (1 .. $sub_packets);
    } else {
        my $sub_packet_bits = read_bits($packet, 15);
        my $end_packet_length = scalar @{$packet} - $sub_packet_bits;
        while (scalar @{$packet} >  $end_packet_length) {
            push(@subpackets, parse_packet($packet));
        }
    }

    return operator_packet_value(\@subpackets, $t);
}

sub operator_packet_value {
    my ($sub_packets, $t) = @_;
    my $value;

    if ($t == 0) {map {$value += $_} @{$sub_packets};}
    if ($t == 1) {
        $value = 1;
        map {$value *= $_} @{$sub_packets};
    }
    if ($t == 2) {$value = min @{$sub_packets};}
    if ($t == 3) {$value = max @{$sub_packets};}
    if ($t == 5) {$value = $sub_packets->[0] > $sub_packets->[1] ? 1 : 0;}
    if ($t == 6) {$value = $sub_packets->[0] < $sub_packets->[1] ? 1 : 0;}
    if ($t == 7) {$value = $sub_packets->[0] == $sub_packets->[1] ? 1 : 0;}

    return $value;
}

sub parse_literal_value_packet {
    my ($packet) = @_;
    my $reading = 1;
    my $literal_number = "";

    while ($reading) {
        $reading = read_bits($packet, 1); 
        # read one at a time so we don't convert to decimal too early
        map {$literal_number .= read_bits($packet, 1)} (1 .. 4);
    }
    return eval("0b" . $literal_number);
}


sub read_bits {
    my ($packet ,$bits) = @_;
    my $read_bits = "";

    map {$read_bits .= shift @{$packet}} (1 .. $bits);
    return eval("0b" . $read_bits);
}

sub printPacket {
    my ($packet) = @_;

    map {print $_} @{$packet};
    print "\n";
}