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
// ANSI/SLAS 1-2004 footprint, X x Y; height Z
plate = [127.76, 85.48, 20];
// ANSI/SLAS 1-2004 corner radius
corner_r = 3.18; // 0.01
cols = 12;
rows = 8;
// ANSI/SLAS 4-2004 well spacing
pitch = 9.0; // 0.1
// A1 centre from left edge / from top edge
a1 = [14.38, 11.24];
// 0.2 mL tube OD ~6.0 mm + clearance
hole_d = 6.4; // 0.1
// orientation mark at the A1 corner
chamfer = 5;
// chamfer starts this far above the bed
chamfer_z = 6;

/* [Hidden] */
$fn = 48;
eps = 0.01;

// parameter checks: stop with a message instead of building a broken part
assert(cols >= 1 && rows >= 1, "cols and rows must be at least 1");
assert(pitch - hole_d >= 0.8, "holes overlap: pitch must exceed hole_d by at least 0.8 mm");
assert(a1.x - hole_d / 2 >= 0.8 && a1.x + (cols - 1) * pitch + hole_d / 2 <= plate.x - 0.8, "the hole grid does not fit the footprint in X");
assert(a1.y - hole_d / 2 >= 0.8 && a1.y + (rows - 1) * pitch + hole_d / 2 <= plate.y - 0.8, "the hole grid does not fit the footprint in Y");

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
