// 96 x 0.2 mL PCR tube rack in the standard microplate (ANSI/SLAS) footprint
// Category: benchware. 8 x 12 through-holes at 9 mm pitch. The base keeps the full
// ANSI/SLAS footprint with 3.18 mm corner radii; the A1 orientation chamfer starts
// 6 mm above the bed so the rack still seats in plate carriers and nests.
// Fits SBS plate carriers and holders. NOT for 96-well magnet stands (the solid block
// hides the tubes) and plate lids will not fit over capped tubes. Tubes rest on the
// bench through the holes unless their rim is wider than the hole.
// Print: PLA or PETG, 0.2 mm layers, 15 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
plate = [127.76, 85.48, 20]; // ANSI/SLAS 1-2004 footprint, X x Y; height Z
corner_r = 3.18;             // ANSI/SLAS 1-2004 corner radius
cols = 12;
rows = 8;
pitch = 9.0;                 // ANSI/SLAS 4-2004 well spacing
a1 = [14.38, 11.24];         // A1 centre from left edge / from top edge
hole_d = 6.4;                // 0.2 mL tube OD ~6.0 mm + clearance
chamfer = 5;                 // orientation mark at the A1 corner
chamfer_z = 6;               // chamfer starts this far above the bed

/* [Hidden] */
$fn = 48;
eps = 0.01;

module footprint(h) {
    linear_extrude(h)
        offset(r = corner_r) offset(delta = -corner_r) square([plate.x, plate.y]);
}

translate([-plate.x / 2, -plate.y / 2, 0])
difference() {
    footprint(plate.z);
    // A1 chamfer on the upper part only
    translate([0, plate.y, chamfer_z])
        linear_extrude(plate.z) polygon([[-eps, eps], [chamfer + eps, eps], [-eps, -chamfer - eps]]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([a1.x + i * pitch, plate.y - a1.y - j * pitch, -eps])
            cylinder(d = hole_d, h = plate.z + 2 * eps);
}
