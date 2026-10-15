// Filleted angle bracket - a right-angle bracket with a rounded (filleted) inner corner for strength
// and a mounting hole in each leg. Teaches a fillet built as a block minus a cylinder. NOVEL part.
//
// @desc right-angle bracket with a filleted inner corner
// @prompt Design an angle bracket in OpenSCAD: two legs at a right angle, each {leg} mm long, {w} mm wide and {t} mm thick, with a {fillet} mm rounded inner corner and a {hole} mm hole in each leg. Reply with a single complete OpenSCAD file.
// @param leg    leg length, mm       [25:70]
// @param w      width, mm            [15:40]
// @param t      thickness, mm        [3:8]
// @param fillet inner fillet, mm     [3:12]
// @param hole   hole diameter, mm    [3:8]

leg    = 45;
w      = 25;
t      = 4;
fillet = 8;
hole   = 5;

$fn = 48;

difference() {
    union() {
        cube([leg, w, t]);                                     // horizontal leg
        cube([t, w, leg]);                                     // vertical leg
        translate([t, 0, t]) difference() {                    // concave fillet at the inner corner
            cube([fillet, w, fillet]);
            translate([fillet, 0, fillet]) rotate([-90, 0, 0]) cylinder(h = w, r = fillet);
        }
    }
    translate([leg * 0.7, w / 2, -1]) cylinder(h = t + 2, d = hole);                      // horizontal hole
    translate([-1, w / 2, leg * 0.7]) rotate([0, 90, 0]) cylinder(h = t + 2, d = hole);   // vertical hole
}
