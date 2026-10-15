// Dowel peg - a peg on a shoulder, for alignment or shelf support. NOVEL general part.
//
// @desc dowel peg with a shoulder
// @prompt Design a dowel peg in OpenSCAD: a {peg_d} mm diameter peg {peg_l} mm long standing on a {base_d} mm shoulder {base_h} mm thick. Reply with a single complete OpenSCAD file.
// @param peg_d  peg diameter, mm        [4:20]
// @param peg_l  peg length, mm          [8:40]
// @param base_d shoulder diameter, mm   [10:40]
// @param base_h shoulder thickness, mm  [2:8]

peg_d  = 8;
peg_l  = 20;
base_d = 16;
base_h = 4;

$fn = 64;

union() {
    cylinder(h = base_h, d = base_d);
    translate([0, 0, base_h]) cylinder(h = peg_l, d = peg_d);
}
