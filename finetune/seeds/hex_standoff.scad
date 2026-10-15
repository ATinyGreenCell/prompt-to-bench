// Hex standoff / spacer - a hexagonal prism with an axial through bore, for stacking
// boards or spacing panels. A NOVEL general part (not one of the 16 benchmark tasks).
//
// @desc hex standoff / spacer with an axial through bore
// @prompt Design a hex standoff in OpenSCAD: a hexagonal prism {af} mm across the flats and {length} mm long, with a {bore} mm diameter hole bored through its axis. Reply with a single complete OpenSCAD file.
// @param af      across-flats size, mm       [6:20]
// @param length  length, mm                  [6:40]
// @param bore    through-bore diameter, mm    [2:10]

af     = 10;
length = 15;
bore   = 3.2;

$fn = 64;

difference() {
    cylinder(h = length, d = af / cos(30), $fn = 6);     // hexagon: across-flats = d * cos(30)
    translate([0, 0, -1]) cylinder(h = length + 2, d = bore);
}
