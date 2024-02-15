#! /usr/bin/env perl

use strict;
use warnings;
use v5.20;

use File::Slurp;

my $DEBUG = undef;

my %colors = (
    'pink' => '#F08080',
    'blue' => '#00CED1',
    'yellow' => '#FFFF99', # '#FFFFE0'
    'green' => '#90EE90'
);

my @output;
my @outside_paths;

my $effect = shift @ARGV;
open my $ein, '<', "effects/$effect.xml" or die;
my $g_line = <$ein>;
chomp $g_line;
my $effect_xml = do { local $/; <$ein> };
close $ein;

my $color = shift @ARGV;
$color //= 'white';
if( $color eq 'random' ) {
    my $which = int( rand( scalar( keys %colors ) ) );
    $color = ( keys %colors )[$which];
    say STDERR "random color: $color" if $DEBUG;
}
$color = $colors{$color} if exists $colors{$color};

my $rot = shift @ARGV;

my $src = do { local $/; <STDIN> };
my @lines = map { s/^\s+//r } split( /\n/, `echo '$src' | tidy -xml -i -q -w 200` );

my @clean;
my $before_group = 1;
my ( $x, $y, $w, $h );

while( my $l = shift @lines ) {
    # remove any 25% opacity lines
    $l =~ s/fill-opacity="0.25"/fill-opacity="0"/;

    # grab the viewbox dimensions and insert the effect code
    if( $l =~ /^<svg/ ) {
        ( $x, $y, $w, $h ) = $l =~ /viewBox="(.*?) (.*?) (.*?) (.*?)"/;
        say STDERR "viewbox $x $y $w $h" if $DEBUG;
        push @output, $l;
        push @output, $effect_xml;
        next;
    }

    # extract any <path> elements that are outside the group
    if( $l =~ /^<path/ && $before_group ) {
        say STDERR "caching " . substr( $l, 0, 10 ) if $DEBUG;
        push @outside_paths, $l;
        next;
    }

    # when we see the <g>
    # - add the code for the requested effect to the existing group
    # - add a background rectangle of requested color inside the group
    # - insert a new sub-group
    # - add the cached paths
    # - keep going with the rest of the original objects from the icon
    if( $l =~ /^<g/ ) {
        say STDERR "found the <g>" if $DEBUG;
        $before_group = undef;
        my( $first ) = $l =~ /(.*?)>/;
        push @output, "$first $g_line>";
        push @output, qq{<rect style="opacity:0.46;fill:$color;stroke-width:0" id="rect5" width="$w" height="$h" x="$x" y="$y" />};
        push @output, qq{<g id="g99" transform="matrix(0.7,0,0,0.7,29.999997,29.999997)">};
        push @output, @outside_paths;
        next;
    }

    # add the extra </g> to account for the inserted one
    if( $l =~ /^<\/g/ ) {
        push @output, $l;
        push @output, $l;
        next;
    }

    push @output, $l;
}

my $line = join( '', @output );
my $tidy = `echo '$line' | tidy -xml -i -q -w 200`;
say $tidy;