// Rack for 24 x 1.5 mL microcentrifuge tubes (4 x 6)
// Category: benchware. Solid block with blind holes; prints as-is without supports.
// Print: PLA or PETG, 0.2 mm layers, 15 % infill, 3 perimeters.
// Fit: tube bodies are 10.8 mm (Eppendorf Safe-Lock); 11.6 mm holes give ~0.4 mm per
// side because vertical FDM holes print ~0.1-0.2 mm small. If tubes wobble, try 11.4.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
cols = 6;              // holes along X
rows = 4;              // holes along Y
pitch = 16;            // centre-to-centre spacing [mm]
hole_d = 11.6;         // tube body 10.8 mm + clearance (see header)
hole_depth = 25;       // blind holes, leaves a 5 mm floor
block = [106, 72, 30]; // X, Y, Z [mm]

/* [Hidden] */
$fn = 64;
eps = 0.01;            // cutters overshoot by eps so no faces are coplanar

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([(i - (cols - 1) / 2) * pitch, (j - (rows - 1) / 2) * pitch, block.z - hole_depth])
            cylinder(d = hole_d, h = hole_depth + eps);
}
