// Rack for 24 x 1.5 mL microcentrifuge tubes (4 x 6)
// Category: benchware. Solid block with blind holes; prints as-is without supports.
// Print: PLA or PETG, 0.2 mm layers, 15 % infill, 3 perimeters.
// Fit: tube bodies are 10.8 mm (Eppendorf Safe-Lock); 11.6 mm holes give 0.4 mm per side
// nominal, ~0.3 mm as printed (vertical holes print ~0.1-0.2 mm small). If tubes wobble,
// try 11.4. The block grows with cols, rows and pitch.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
// holes along X
cols = 6;
// holes along Y
rows = 4;
// centre-to-centre spacing [mm]
pitch = 16;
// tube body 10.8 mm + clearance (see header)
hole_d = 11.6; // 0.1
// blind holes, leaves a 5 mm floor
hole_depth = 25;
// block height [mm]
height = 30;

/* [Hidden] */
$fn = 64;
eps = 0.01;            // cutters overshoot by eps so no faces are coplanar
block = [cols * pitch + 10, rows * pitch + 8, height];  // 106 x 72 x 30 by default

// parameter checks: stop with a message instead of building a broken part
assert(cols >= 1 && rows >= 1, "cols and rows must be at least 1");
assert(pitch - hole_d >= 0.8, "holes overlap: pitch must exceed hole_d by at least 0.8 mm");
assert(height - hole_depth >= 0.8, "no floor left: hole_depth must be at least 0.8 mm less than height");

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([(i - (cols - 1) / 2) * pitch, (j - (rows - 1) / 2) * pitch, block.z - hole_depth])
            cylinder(d = hole_d, h = hole_depth + eps);
}
