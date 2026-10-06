// Straight hose-barb reducer: 8 mm ID tubing <-> 5 mm ID tubing
// Category: quick fixes. A revolved sawtooth profile (rotate_extrude) with a 3 mm bore.
// Print: PETG, upright, 0.12 mm layers, 100 % infill, brim. Layer lines run across the
// axis, so it is weakest in bending: not for lines under tension or bending, and not
// for pressurised or biohazard lines. Low-pressure use only (aspiration, aquarium
// pumps); FDM parts can weep - leak-test before trusting it. The 2.5 mm bore limits flow.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Reducer] */
bore_d = 2.5;          // keeps the 5 mm tip wall at 1.25 mm (3+ perimeters)
big = [7.5, 9.5, 10];    // 8 mm tubing barbs: start d, end d, height
small = [6.5, 5.0, 8];   // 5 mm tubing barbs: start d, end d, height
n_barbs = 2;             // barbs per side
collar = [12, 5];        // collar d, height

/* [Hidden] */
$fn = 96;
h_big = n_barbs * big[2];
z_small = h_big + collar[1];
H = z_small + n_barbs * small[2];

// (r, z) outline of the wall, revolved around Z
profile = concat(
    [[bore_d / 2, 0]],
    [for (i = [0 : n_barbs - 1]) each [[big[0] / 2, i * big[2]], [big[1] / 2, (i + 1) * big[2]]]],
    [[collar[0] / 2, h_big], [collar[0] / 2, z_small]],
    [for (i = [0 : n_barbs - 1]) each [[small[0] / 2, z_small + i * small[2]], [small[1] / 2, z_small + (i + 1) * small[2]]]],
    [[bore_d / 2, H]]
);

rotate_extrude() polygon(profile);
