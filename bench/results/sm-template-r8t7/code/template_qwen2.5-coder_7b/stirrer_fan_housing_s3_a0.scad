// Rounded mounting plate - a flat plate with rounded corners and a countersunk screw hole near each
// corner. Teaches 2D corner rounding with offset() and a countersink (chamfered hole). NOVEL part.
//
// @desc flat plate, rounded corners, countersunk holes
// @prompt Design a mounting plate in OpenSCAD: {L} by {W} mm and {t} mm thick, with {r} mm rounded corners and a countersunk hole for an {screw} mm screw near each corner. Reply with a single complete OpenSCAD file.
// @param L     length, mm           [40:120]
// @param W     width, mm            [30:90]
// @param t     thickness, mm        [3:8]
// @param r     corner radius, mm    [3:12]
// @param screw screw diameter, mm   [3:6]

L     = 90;
W     = 90;
t     = 3;
r     = 5;
screw = 4.5;

$fn = 48;

inset = r + 2;                     // hole-centre inset from the edges
head  = screw * 2;                 // countersink top diameter
csk   = min(screw, t - 1);         // countersink depth

module rounded_rect(l, w, rad) {
    offset(r = rad) square([l - 2 * rad, w - 2 * rad], center = true);
}

difference() {
    linear_extrude(t) rounded_rect(L, W, r);
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * (L / 2 - inset), sy * (W / 2 - inset), 0]) {
            translate([0, 0, -1]) cylinder(h = t + 2, d = screw);                       // shank
            translate([0, 0, t - csk]) cylinder(h = csk + 0.01, d1 = screw, d2 = head); // countersink
        }
}