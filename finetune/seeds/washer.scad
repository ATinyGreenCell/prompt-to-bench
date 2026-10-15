// Flat washer / spacer ring. NOVEL general fastener part.
//
// @desc flat washer / spacer ring
// @prompt Design a flat washer in OpenSCAD: a ring {od} mm in outer diameter and {t} mm thick with a {bore} mm hole. Reply with a single complete OpenSCAD file.
// @param od   outer diameter, mm  [16:50]
// @param bore hole diameter, mm   [3:14]
// @param t    thickness, mm       [1:6]

od   = 20;
bore = 10;
t    = 2;

$fn = 72;

difference() {
    cylinder(h = t, d = od);
    translate([0, 0, -1]) cylinder(h = t + 2, d = bore);
}
