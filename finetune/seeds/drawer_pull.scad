// Drawer pull - a round grip bar standing off a surface on two legs with screw holes.
// NOVEL general hardware part.
//
// @desc drawer pull - a grip bar on two legs with screw holes
// @prompt Design a drawer pull handle in OpenSCAD: a round grip bar spanning {length} mm between two legs, {bar_d} mm thick, standing {standoff} mm off the surface, with a {screw} mm screw hole up through each leg. Reply with a single complete OpenSCAD file.
// @param length   span between legs, mm    [40:200]
// @param bar_d    grip bar diameter, mm     [8:20]
// @param standoff standoff height, mm       [15:40]
// @param screw    screw hole diameter, mm   [3:6]

length   = 100;
bar_d    = 12;
standoff = 25;
screw    = 4;

$fn = 48;

leg_d = bar_d + 4;

difference() {
    union() {
        for (x = [-length / 2, length / 2]) {
            translate([x, 0, 0]) cylinder(h = standoff, d = leg_d);      // legs
            translate([x, 0, 0]) cylinder(h = 3, d = leg_d + 4);         // foot pads
        }
        translate([-length / 2, 0, standoff]) rotate([0, 90, 0]) cylinder(h = length, d = bar_d);  // grip bar
    }
    for (x = [-length / 2, length / 2])
        translate([x, 0, -1]) cylinder(h = standoff + 2, d = screw);     // screw holes
}
