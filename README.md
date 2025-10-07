# Files

## `ground.tsv`

A list of all supported ground icons in  [MIL-STD-2525](https://en.wikipedia.org/wiki/NATO_Joint_Military_Symbology).  Used to generate a set of icons.

## `mil2525icon.js`

A Node script that uses `milsymbol.js` to render MIL-STD-2525 icons given an SIDC (symbol identification code).  Outputs an SVG file to `STDOUT`.

Usage: `./mil2525icon.js "SFG-UCI----D" > infantry_platoon.svg`

## `applyeffect.pl`

Takes an SVG icon generated from `mil2525icon.js` and applies an SVG filter / path effect.  Supports effects `paper`, `rough`, and `sketch`.  Takes the original SVG on `STDIN` and outputs to `STDOUT`.

Usage: `cat infantry_platoon.svg | ./applyeffect.pl paper > infantry_platoon_paper.svg`

## `generate_icons.pl`

The primary script.  Generates all the basic ground icons at platoon size from `ground.tsv`.

Outputs icons in the following folders:

- `basic_svg/` contains the original SVG for each icon
- `munged/` contains the SVGs after having effects applied
- `png/` contains all the resulting PNG files

## Output

The [`png/`](png) folder contains some output examples of icons in different, munged forms.  For example, [this icon](png/WAR.GRDTRK.UNT.CBT.ARM_paper.png) is the symbol for an armor platoon drawn on rumpled paper.

# Sources

The excellent [milsymbol](https://spatialillusions.com/milsymbol/) project from Spatial Illusions provides the rendering code.

The companion project [mil-std-2525](https://github.com/spatialillusions/mil-std-2525) contains all the SIDC code information extracted from the actual MIL-STD-2525 documentation.