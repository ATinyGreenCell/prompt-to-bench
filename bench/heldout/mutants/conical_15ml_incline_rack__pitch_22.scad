// KNOWN-WRONG PART (must fail): the holes are 22 mm apart instead of 24
// Rack that holds five 15 mL conical tubes at a 30-degree lean (reading volumes, pipetting off
// supernatant). Category: benchware. A solid block with five blind holes tilted 30 degrees from
// vertical; the hole roofs overhang at 60 degrees from horizontal, so it prints without supports.
// Print: PLA or PETG, standing on the bed, 0.2 mm layers, 15 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
block = [130, 60, 45];    // X, Y, Z [mm], centred in X and Y
n = 5;
pitch = 22;               // along X
hole_d = 17.5;            // square to the axis
tilt = 30;                // degrees from vertical; going down, the hole moves toward +Y
entry_y = -10;            // the axis meets the top face at y = -10
depth = 40;               // along the axis, flat end square to the axis

/* [Hidden] */
eps = 0.01;

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : n - 1])
        translate([(i - (n - 1) / 2) * pitch, entry_y, block.z])
            rotate([tilt, 0, 0])            // local +Z (up the hole) -> (0, -sin, cos)
                translate([0, 0, -depth]) cylinder(d = hole_d, h = depth + 15, $fn = 96);
}
