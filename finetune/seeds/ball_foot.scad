// Dome foot - a rounded rubber-style foot with a mounting screw hole, for the bottom of an
// instrument or enclosure. NOVEL general part.
//
// @desc dome foot with a countersunk mounting screw hole
// @prompt Design a dome foot in OpenSCAD: a rounded foot {foot_d} mm in diameter and {foot_h} mm tall with a countersunk mounting hole {screw} mm for a screw up through the base. Reply with a single complete OpenSCAD file.
// @param foot_d foot diameter, mm        [15:50]
// @param foot_h foot height, mm          [8:30]
// @param screw  screw hole diameter, mm  [3:8]

foot_d = 25;
foot_h = 15;
screw  = 4;

$fn = 72;

difference() {
    resize([foot_d, foot_d, foot_h * 2]) sphere(d = foot_d);                 // dome (ellipsoid)
    translate([0, 0, -foot_h]) cube([foot_d * 2, foot_d * 2, 2 * foot_h], center = true);  // flatten bottom at z=0
    translate([0, 0, -1]) cylinder(h = foot_h, d = screw);                   // screw hole
    translate([0, 0, -0.01]) cylinder(h = screw, d1 = screw * 2, d2 = screw);  // countersink
}
