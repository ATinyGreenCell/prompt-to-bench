// Seed-sowing / colony-picking guide for a 90 mm Petri dish (7 x 7 grid)
// Category: tools. Recommended use: put the disc UNDER the dish and sow onto the agar
// through the clear base, following the holes. Nothing printed touches the medium.
// If it must lie on the agar: soak >= 10 min in 70 % ethanol, dry in the flow hood,
// and treat it as single use - ethanol disinfects but does not kill spores, and
// plant plates incubate for weeks. Lift it out with tweezers by the slot near the -Y edge.
// Fit: "90 mm" dishes are ~85-86 mm inside (glass ~85 mm) and narrow towards the
// floor; 82 mm fits most. Measure your dish if it sits inside.
// Print: PLA or PETG, 0.2 mm layers.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Template] */
disc_d = 82;
thickness = 2;
// n x n grid
n = 7;
// 10 mm would push the corner holes too close to the rim
pitch = 9;
hole_d = 3;
// orientation notch, width x depth [mm], on the +Y edge
notch = [10, 4];
// tweezer slot near the -Y edge, width x depth [mm]
slot = [10, 3];

/* [Hidden] */
eps = 0.01;

// parameter checks: stop with a message instead of building a broken part
assert(sqrt(2) * (n - 1) / 2 * pitch + hole_d / 2 <= disc_d / 2 - 1, "the corner holes reach the rim: reduce n or pitch, or enlarge disc_d");

difference() {
    cylinder(d = disc_d, h = thickness, $fn = 180);
    for (i = [0 : n - 1], j = [0 : n - 1])
        translate([(i - (n - 1) / 2) * pitch, (j - (n - 1) / 2) * pitch, -eps])
            cylinder(d = hole_d, h = thickness + 2 * eps, $fn = 32);
    translate([-notch.x / 2, disc_d / 2 - notch.y, -eps])
        cube([notch.x, notch.y + 1, thickness + 2 * eps]);
    translate([-slot.x / 2, -disc_d / 2 + 2, -eps])
        cube([slot.x, slot.y, thickness + 2 * eps]);
}
