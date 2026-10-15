// Knurled control knob - a cylindrical knob with a ring of grip flutes, a chamfered top edge, and a
// shaft bore with an optional flat (D-bore). Teaches a coarse surface texture, an edge chamfer, and
// a D-bore via intersection(). NOVEL general part.
//
// @desc fluted (knurled) knob with a chamfered top and a D-bore
// @prompt Design a control knob in OpenSCAD: {d} mm across and {h} mm tall with {flutes} grip flutes around the rim, a chamfered top edge, and a {bore} mm shaft bore with a flat {flat} mm deep. Reply with a single complete OpenSCAD file.
// @param d      knob diameter, mm      [18:50]
// @param h      knob height, mm        [12:30]
// @param flutes number of flutes       [8:18:1]
// @param bore   shaft bore, mm         [4:10]
// @param flat   shaft flat depth, mm   [0:3]

d      = 30;
h      = 18;
flutes = 12;
bore   = 6;
flat   = 1.5;

$fn = 64;

chamf = min(2.5, h / 4);
fd    = d * 0.14;                 // flute-cutter diameter
fl    = min(flat, bore / 2 - 0.8); // keep the D-flat shallower than the bore radius

difference() {
    union() {
        cylinder(h = h - chamf + 0.01, d = d);                                          // body
        translate([0, 0, h - chamf]) cylinder(h = chamf, d1 = d, d2 = d - 2 * chamf);   // chamfered top
    }
    for (i = [0 : flutes - 1])                                                           // grip flutes
        rotate([0, 0, i * 360 / flutes])
            translate([d / 2, 0, -1]) cylinder(h = h + 2, d = fd, $fn = 16);
    translate([0, 0, -1]) intersection() {                                              // shaft bore, D-flat on +x
        cylinder(h = h + 2, d = bore);
        translate([-d, -d, 0]) cube([d + bore / 2 - fl, 2 * d, h + 2]);
    }
}
