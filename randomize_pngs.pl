#! /usr/bin/env perl

use strict;
use warnings;
use v5.30;

use constant REPS => 5;
use constant B_FACTOR => 10;
use constant B_RANGE => 6;
use constant R_RANGE => 30;

mkdir 'png';
mkdir 'randomized';

while( my $fname = <png/*.png> ) {
    next unless $fname =~ /_([a-z]+)\.png/;
    say "Processing $fname";

    my $base = $fname =~ s/\.png$//r;
    my $out_base = $base =~ s{^png/}{randomized/}r;

    foreach my $rep ( 1..REPS ) {
        my $brightness = ( int( rand( B_RANGE * 2 ) ) - B_RANGE ) * B_FACTOR;
        my $contrast = ( int( rand( B_RANGE * 2 ) ) - B_RANGE ) * B_FACTOR;
        my $rot = int( rand( R_RANGE * 2 ) ) - R_RANGE;

        `convert -background 'rgba(0,0,0,0)' -brightness-contrast "${brightness}x${contrast}" -rotate $rot $fname ${out_base}_${brightness}_${contrast}_${rot}.png`;
    }
}
