// Spool for cord, wire or filament - a core between two flanges with an axial bore.
// NOVEL general part.
//
// @desc spool for cord, wire or filament
// @prompt Design a spool in OpenSCAD: a {core_d} mm core {width} mm wide between two {flange_d} mm flanges, with a {bore} mm axial bore. Reply with a single complete OpenSCAD file.
// @param core_d   core diameter, mm          [12:60]
// @param flange_d flange diameter, mm        [25:120]
// @param width    width between flanges, mm  [10:60]
// @param bore     axial bore, mm             [4:30]

core_d   = 25;
flange_d = 60;
width    = 30;
bore     = 8;

$fn = 96;

flange_t = 3;

difference() {
    union() {
        cylinder(h = width, d = core_d);
        cylinder(h = flange_t, d = flange_d);
        translate([0, 0, width - flange_t]) cylinder(h = flange_t, d = flange_d);
    }
    translate([0, 0, -1]) cylinder(h = width + 2, d = bore);
}
