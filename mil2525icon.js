#! /usr/bin/env node

const ms = require('./milsymbol.js');

const sidc = process.argv[2];
if( sidc === null ) {
    console.warn("Must specify an SIDC");
    process.exit();
}

const svg = new ms.Symbol(sidc, { fill: 'white', fillOpacity: 0.25, square: true }).asSVG();

console.log(svg);