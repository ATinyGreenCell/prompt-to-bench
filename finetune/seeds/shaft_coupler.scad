// Rigid shaft coupler - a cylinder with an axial bore that joins two shafts end to end,
// held by radial set screws. NOVEL general mechanical part.
//
// @desc rigid shaft coupler joining two shafts end to end with set screws
// @prompt Design a rigid shaft coupler in OpenSCAD: a cylinder {od} mm in outer diameter and {length} mm long with a {bore} mm axial bore to join two shafts, and two radial set-screw holes {set_d} mm. Reply with a single complete OpenSCAD file.
// @param od      outer diameter, mm         [12:40]
// @param length  length, mm                 [16:50]
// @param bore    shaft bore diameter, mm     [3:20]
// @param set_d   set-screw diameter, mm      [2:6]

od     = 20;
length = 25;
bore   = 6;
set_d  = 3;

$fn = 72;

difference() {
    cylinder(h = length, d = od);
    translate([0, 0, -1]) cylinder(h = length + 2, d = bore);
    for (z = [length * 0.25, length * 0.75])
        translate([0, 0, z]) rotate([0, 90, 0]) cylinder(h = od + 2, d = set_d, center = true);
}
