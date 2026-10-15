// Right-angle corner bracket - two perpendicular arms with a mounting hole in each, to
// join two surfaces at 90 degrees. NOVEL general structural part.
//
// @desc right-angle corner bracket joining two surfaces at 90 degrees
// @prompt Design a right-angle corner bracket in OpenSCAD: two perpendicular arms, each {arm} mm long, {width} mm wide and {t} mm thick, meeting at a right angle, with a {hole} mm mounting hole near the end of each arm. Reply with a single complete OpenSCAD file.
// @param arm   arm length, mm       [20:80]
// @param width width, mm            [15:50]
// @param t     plate thickness, mm  [3:8]
// @param hole  hole diameter, mm    [3:8]

arm   = 40;
width = 25;
t     = 4;
hole  = 5;

$fn = 48;

difference() {
    union() {
        cube([arm, width, t]);      // horizontal arm (along X)
        cube([t, width, arm]);      // vertical arm (along Z)
    }
    translate([arm * 0.72, width / 2, -1]) cylinder(h = t + 2, d = hole);                 // horizontal arm hole
    translate([-1, width / 2, arm * 0.72]) rotate([0, 90, 0]) cylinder(h = t + 2, d = hole);  // vertical arm hole
}
