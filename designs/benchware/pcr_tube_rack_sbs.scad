// 96 x 0.2 mL PCR tube rack in the standard microplate (ANSI/SLAS) footprint
// Category: benchware. 8 x 12 through-holes at 9 mm pitch; one chamfered corner
// marks the A1 position. Fits plate holders, plate magnets and plate lids.
// Print: PLA or PETG, 0.2 mm layers, 15 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
plate = [127.76, 85.48, 20]; // ANSI/SLAS 1-2004 footprint, X x Y; height Z
cols = 12;
rows = 8;
pitch = 9.0;                 // ANSI/SLAS 4-2004 well spacing
a1 = [14.38, 11.24];         // A1 centre from left edge / from top edge
hole_d = 6.2;                // 0.2 mL PCR tube ~6 mm below the lid
chamfer = 5;                 // orientation mark at the A1 corner

/* [Hidden] */
$fn = 48;
eps = 0.01;

translate([-plate.x / 2, -plate.y / 2, 0])
difference() {
    linear_extrude(plate.z)
        polygon([[0, 0], [plate.x, 0], [plate.x, plate.y], [chamfer, plate.y], [0, plate.y - chamfer]]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([a1.x + i * pitch, plate.y - a1.y - j * pitch, -eps])
            cylinder(d = hole_d, h = plate.z + 2 * eps);
}
