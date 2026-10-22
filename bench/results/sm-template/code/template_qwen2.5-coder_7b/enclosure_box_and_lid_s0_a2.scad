// Box with a press-fit lid - a hollow rectangular box (open top) and a separate lid whose plug
// drops into the opening. The two parts are laid side by side. NOVEL general part.
//
// @desc hollow box with a separate press-fit lid
// @prompt Design a small box with a lid in OpenSCAD: an inner space {il} by {iw} by {ih} mm with {wall} mm walls, and a separate lid whose plug drops {lip} mm into the opening. Lay the two parts side by side. Reply with a single complete OpenSCAD file.
// @param il   inner length, mm     [20:80]
// @param iw   inner width, mm      [20:60]
// @param ih   inner height, mm     [10:50]
// @param wall wall thickness, mm   [1.6:4]
// @param lip  lid plug depth, mm   [3:10]

il   = 70;
iw   = 50;
ih   = 32;
wall = 2;
lip  = 4;

$fn = 32;

ol = il + 2 * wall;
ow = iw + 2 * wall;

module box() {
    difference() {
        cube([ol, ow, ih + wall]);
        translate([wall, wall, wall]) cube([il, iw, ih + 1]);   // open-top cavity
    }
}

module lid() {
    cl = il - 0.5;                 // plug: 0.25 mm clearance per side
    cw = iw - 0.5;
    union() {
        cube([ol, ow, wall]);                                    // top plate, full footprint
        translate([(ol - cl) / 2, (ow - cw) / 2, 0])
            cube([cl, cw, wall + lip]);                          // plug (overlaps the plate -> one solid)
    }
}

box();
translate([0, ow + 10, 0]) lid();