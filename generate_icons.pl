#! /usr/bin/env perl

use strict;
use warnings;
use v5.30;

open my $in, '<', 'ground.tsv' or die;
my $header = <$in>;

my %include = (
    'WAR.GRDTRK.UNT.CBT.RECON.CVY.ARMD' => 1,
    'WAR.GRDTRK.UNT.CBT.RECON.CVY.MOT' => 1,
);

my %exclude = (
    'WAR.GRDTRK.UNT.CBT.RECON.HRE' => 1,
    'WAR.GRDTRK.UNT.CBT.RECON.CVY' => 1,
);

mkdir 'basic_svg';
mkdir 'munged';
mkdir 'png';

while( <$in> ) {
    chomp;
    next unless /\.CBT\./;
    my @data = split( /\t/ );

    my $okay = ! exists $exclude{$data[0]};
    $okay &&= exists $include{$data[0]} || $data[0] =~ /^WAR\.GRDTRK\.UNT\.CBT\.[A-Z]+$/;
    next unless $okay;

    say STDERR "Processing $data[0]";

    my $sidc = 'SFG-' . $data[5] . '-D';

    my $base = $data[0];
    `./mil2525icon.js "$sidc" | tidy -xml -i -q -w 200 > basic_svg/$base.svg`;

    foreach my $effect ( qw( rough paper sketch ) ) {
        `cat basic_svg/$base.svg | ./applyeffect2.pl $effect random > munged/${base}_$effect.svg`;
    }
}

# convert SVG to PNG
say STDERR "Rendering basic icons";
`mogrify  -background 'rgba(0,0,0,0)' -format png -path png/ basic_svg/*.svg`;
say STDERR "Rendering munged icons";
`mogrify  -background 'rgba(0,0,0,0)' -format png -path png/ munged/*.svg`;
