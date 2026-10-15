// Shelf bracket - two perpendicular arms with a diagonal brace and a mounting hole in each
// arm. NOVEL general structural part.
//
// @desc right-angle shelf bracket with a diagonal brace
// @prompt Design a shelf bracket in OpenSCAD: two arms at a right angle, each {arm} mm long and {wide} mm wide and {t} mm thick, with a triangular brace between them and a {screw} mm hole near each arm end. Reply with a single complete OpenSCAD file.
// @param arm   arm length, mm       [30:100]
// @param wide  width, mm            [15:40]
// @param t     thickness, mm        [3:8]
// @param screw hole diameter, mm    [3:8]

arm   = 60;
wide  = 25;
t     = 5;
screw = 5;

$fn = 48;

g  = arm * 0.7;         // brace leg length
ov = min(t * 0.6, 2);   // dig the brace into both arms so the union is manifold (no coplanar faces)

difference() {
    union() {
        cube([arm, wide, t]);          // horizontal arm
        cube([t, wide, arm]);          // vertical arm
        translate([0, wide, 0]) rotate([90, 0, 0])
            linear_extrude(wide) polygon([[t - ov, t - ov], [g, t - ov], [t - ov, g]]);   // diagonal brace
    }
    translate([arm * 0.72, wide / 2, -1]) cylinder(h = t + 2, d = screw);
    translate([-1, wide / 2, arm * 0.72]) rotate([0, 90, 0]) cylinder(h = t + 2, d = screw);
}
