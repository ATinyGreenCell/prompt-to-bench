// Channel / T-slot nut - a rectangular block with a bolt bore, for aluminium extrusion or a
// slotted channel. NOVEL general part.
//
// @desc rectangular channel nut with a bolt bore
// @prompt Design a channel nut in OpenSCAD: a block {w} mm wide, {l} mm long and {h} mm thick with a {bore} mm bore through it for a bolt. Reply with a single complete OpenSCAD file.
// @param w    width, mm          [8:16]
// @param l    length, mm         [10:25]
// @param h    thickness, mm      [3:8]
// @param bore bore diameter, mm  [3:8]

w    = 10;
l    = 18;
h    = 5;
bore = 5;

$fn = 48;

difference() {
    translate([-w / 2, -l / 2, 0]) cube([w, l, h]);
    translate([0, 0, -1]) cylinder(h = h + 2, d = bore);
}
