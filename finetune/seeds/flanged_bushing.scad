// Flanged sleeve bushing / plain bearing - a sleeve with a flange at one end that seats in a
// bore. NOVEL general mechanical part.
//
// @desc flanged sleeve bushing / plain bearing
// @prompt Design a flanged sleeve bushing in OpenSCAD: a sleeve {length} mm long with a {od} mm outer diameter and a {bore} mm bore, with a flange {flange} mm wider at one end. Reply with a single complete OpenSCAD file.
// @param od     sleeve outer diameter, mm   [8:40]
// @param bore   bore diameter, mm           [3:30]
// @param length sleeve length, mm           [6:40]
// @param flange flange overhang, mm         [1.5:6]

od     = 16;
bore   = 10;
length = 20;
flange = 3;

$fn = 72;

flange_t = 2;

difference() {
    union() {
        cylinder(h = length, d = od);
        cylinder(h = flange_t, d = od + 2 * flange);
    }
    translate([0, 0, -1]) cylinder(h = length + 2, d = bore);
}
