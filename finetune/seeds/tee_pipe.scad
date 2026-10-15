// T pipe connector - a tee joining three tube ends, hollow through. NOVEL general part.
//
// @desc T pipe connector joining three tube ends
// @prompt Design a T pipe connector in OpenSCAD: a tee for tubes of {bore} mm inner diameter with {wall} mm walls, the straight run {run} mm long and the branch {branch} mm long. Reply with a single complete OpenSCAD file.
// @param bore   tube inner diameter, mm  [6:40]
// @param wall   wall thickness, mm       [1.5:5]
// @param run    run length, mm           [30:100]
// @param branch branch length, mm        [15:60]

bore   = 16;
wall   = 3;
run    = 60;
branch = 30;

$fn = 64;

od = bore + 2 * wall;

difference() {
    union() {
        translate([-run / 2, 0, 0]) rotate([0, 90, 0]) cylinder(h = run, d = od);   // run along X
        rotate([-90, 0, 0]) cylinder(h = branch, d = od);                            // branch along +Y
    }
    translate([-run / 2 - 1, 0, 0]) rotate([0, 90, 0]) cylinder(h = run + 2, d = bore);
    rotate([-90, 0, 0]) translate([0, 0, -1]) cylinder(h = branch + 2, d = bore);
}
