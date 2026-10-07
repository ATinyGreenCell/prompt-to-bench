// Straight hose-barb reducer: 8 mm ID tubing <-> 5 mm ID tubing
// Category: quick fixes. A revolved sawtooth profile (rotate_extrude) with a 2.5 mm bore.
// Print: PETG, upright, 0.12 mm layers, 100 % infill, brim. Layer lines run across the
// axis, so it is weakest in bending: not for lines under tension or bending, and not
// for pressurised or biohazard lines. Low-pressure use only (aquarium pumps, water and
// buffer lines, vacuum aspiration of non-biological liquids); FDM parts can weep - leak-test before trusting it. The 2.5 mm bore limits flow.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Reducer] */
// keeps the 5 mm tip wall at 1.25 mm (3+ perimeters)
bore_d = 2.5; // 0.1
// 8 mm tubing barbs: start d, end d, height
big = [7.5, 9.5, 10];
// 5 mm tubing barbs: start d, end d, height
small = [6.5, 5.0, 8];
// barbs per side
n_barbs = 2;
// collar d, height
collar = [12, 5];

/* [Hidden] */
$fn = 96;
h_big = n_barbs * big[2];
z_small = h_big + collar[1];
H = z_small + n_barbs * small[2];

// (r, z) outline of the wall, revolved around Z
profile = concat(
    [[bore_d / 2, 0]],
    [for (i = [0 : n_barbs - 1]) each [[big[0] / 2, i * big[2]], [big[1] / 2, (i + 1) * big[2]]]],
    [[collar[0] / 2, h_big + (collar[0] - big[1]) / 2], [collar[0] / 2, z_small]],  // 45 deg cone under the collar
    [for (i = [0 : n_barbs - 1]) each [[small[0] / 2, z_small + i * small[2]], [small[1] / 2, z_small + (i + 1) * small[2]]]],
    [[bore_d / 2, H]]
);

// parameter checks: stop with a message instead of building a broken part
assert(n_barbs >= 1, "n_barbs must be at least 1");
assert(small[1] - bore_d >= 2 * 1.2, "the small barb tip wall is under 1.2 mm: reduce bore_d");
assert(collar[0] >= big[1], "the collar must be at least as wide as the big barbs");

rotate_extrude() polygon(profile);
