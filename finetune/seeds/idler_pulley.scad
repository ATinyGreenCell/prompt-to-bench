// Flanged idler pulley - a smooth grooved wheel with side flanges and an axial bore, for a
// round or flat belt. NOVEL general mechanical part.
//
// @desc flanged idler pulley with a concave belt groove
// @prompt Design a flanged idler pulley in OpenSCAD: a wheel {od} mm in diameter and {width} mm wide with a concave belt groove and flanges {flange} mm proud on each side, and a {bore} mm bore. Reply with a single complete OpenSCAD file.
// @param od     wheel outer diameter, mm   [16:60]
// @param width  width, mm                  [6:30]
// @param flange flange extra radius, mm    [2:8]
// @param bore   bore diameter, mm          [3:20]

od     = 30;
width  = 12;
flange = 4;
bore   = 8;

$fn = 96;

flange_t = 2;

difference() {
    union() {
        cylinder(h = width, d = od);
        cylinder(h = flange_t, d = od + 2 * flange);
        translate([0, 0, width - flange_t]) cylinder(h = flange_t, d = od + 2 * flange);
    }
    rotate_extrude() translate([od / 2, width / 2, 0]) circle(d = width * 0.5);   // belt groove
    translate([0, 0, -1]) cylinder(h = width + 2, d = bore);
}
