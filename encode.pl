#!/usr/bin/env perl

# Brad Forschinger, 2010

use strict;
use warnings;

my ($in, $pos, $width) = (undef, 2, 72);
print "<~";
while (read(STDIN, $in, 4) > 0) {
    my @buf;

    if ($in eq "\0\0\0\0") {
        $buf[0] = "z";                                      # '!!!!' -> 'z'
    } else {
        my (@a, $x, $i);

        @a = unpack("C*", $in);
        @a = map { $a[$_] || 0 } 0..3;
        $x = $a[0] << 24 | $a[1] << 16 | $a[2] << 8 | $a[3];

        for $i (1 .. 5) {
            unshift @buf, chr(($x % 85) + 33);
            $x /= 85;
        }
        splice @buf, length($in) + 1;                       # trim @buf
    }

    if (scalar(@buf) + $pos > $width) {                     # should we wrap?
        $pos = ($pos + scalar(@buf)) % ($width + 1);
        splice @buf, scalar(@buf) - $pos, 0, "\n";          # put a newline in
    } else {
        $pos = $pos + scalar(@buf);
    }
    print @buf;
}
print $pos <= $width - 2 ? "~>\n" : "\n~>\n";

