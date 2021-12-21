use strict;
use warnings;

# In major need of a refator - thinking of packets as trees might be a superior approach here

my @input_hex = split //, <>;
my $packet;
my $version_number;

map {$packet .= sprintf("%04b", hex($_))} (@input_hex);

my @packets = split //, $packet;
handlePacket(\@packets, 0, 12);

print $version_number;

sub handleSubPacket {
    my ($packet, $head, $packet_end_length) = @_;

    my ($packet_ver, $packet_type);
    ($packet_ver, $head) = getThreeBit($packet, $head);
    ($packet_type, $head) = getThreeBit($packet, $head);
    $version_number += $packet_ver;

    if ($packet_type != 4) {
        $head = handle_operation_packet($packet,$head);
    } else {
        $head = handle_literal_value_packet($packet, $head);
        $head = handleSubPacket($packet, $head, $packet_end_length) if ($head < $packet_end_length);
    }
    return $head;
}

sub handlePacket {
    my ($packet, $head, $remaining_packets) = @_;
    while ($remaining_packets) {

        my ($packet_ver, $packet_type);
        ($packet_ver, $head) = getThreeBit($packet, $head);
        ($packet_type, $head) = getThreeBit($packet, $head);
        $version_number += $packet_ver;

        if ($packet_type != 4) {
            $head = handle_operation_packet($packet,$head);
        } else {
            $head = handle_literal_value_packet($packet, $head);
        }
        $remaining_packets--;
    }
    return $head;
}

sub printPacket {
    my ($head, $packet, $packet_end_length) = @_;
    print "$head, $packet_end_length:  ";
    for ($head .. $packet_end_length) {
        print $packet->[$_];
    }
    print "\n";
}

sub handle_operation_packet {
    my ($packet, $head) = @_;

    my $length_type = $packet->[$head];
    $head += 1;

    my $sub_length;
    ($sub_length, $head) = get_subpacket_length($packet, $head, $length_type);

    if (!$length_type) {
        $head = handleSubPacket($packet, $head, $head + $sub_length);
    } else {
        $head = handlePacket($packet, $head, $sub_length);
    }
    return $head;
}

sub handle_literal_value_packet {
    my ($packet, $head) = @_;
    my $literal_number = "";
    my $reading = 1;
    while ($reading) {
        $reading = $packet->[$head];
        $literal_number .= $packet->[$head+1] . $packet->[$head+2] . $packet->[$head+3] . $packet->[$head+4];
        $head += 5;
    }
    return $head;
}

sub get_subpacket_length {
    my ($packet, $head, $length_type) = @_;
    my $length_bin;
    if ($length_type) {
        for ($head .. $head + 10) {
            $length_bin .= $packet->[$_];
        }
        $head += 11;
    } else {
        for ($head .. $head + 14) {
            $length_bin .= $packet->[$_];
        }
        $head += 15;
    }
    return eval("0b$length_bin"), $head;
}

sub getThreeBit {
    my ($packet, $head) = @_;
    return eval("0b" . $packet->[$head] . $packet->[$head + 1] . $packet->[$head + 2]), ($head + 3); 
}
