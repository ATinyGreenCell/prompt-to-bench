// 10-well comb for casting agarose gels
// Category: tools. Flat part, prints lying down. The spine is longer than the row of
// teeth so its ends rest on the tray walls (or comb slots); set tooth_len so the tooth
// tips sit 1-2 mm above the tray floor, otherwise wells cast through the gel and
// samples leak out underneath.
// Print: PETG (survives warm agarose better than PLA), 0.15 mm layers, 100 % infill.
// The bed side is smoothest on a smooth PEI sheet - use that side for the well faces.
// Use: let agarose cool to 50-60 C (hand-warm flask) before pouring; hotter agarose
// warps PETG and PLA combs and trays.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Comb] */
// back bar, X x Y [mm]; ends rest on the tray walls
spine = [80, 12];
n_teeth = 10;
// well width
tooth_w = 5.0; // 0.1
// = (height of spine support above tray floor) - 1.5 mm
tooth_len = 12;
// gel between wells
gap = 1.5; // 0.1
// well thickness (comb printed flat)
thickness = 1.5; // 0.1

/* [Hidden] */
eps = 0.01;
span = n_teeth * tooth_w + (n_teeth - 1) * gap;

// parameter checks: stop with a message instead of building a broken part
assert(n_teeth >= 1, "n_teeth must be at least 1");
assert(span <= spine[0], "the teeth are wider than the spine: lengthen the spine or narrow the teeth/gaps");

linear_extrude(thickness) {
    translate([-spine.x / 2, 0]) square(spine);
    for (i = [0 : n_teeth - 1])
        translate([-span / 2 + i * (tooth_w + gap), -tooth_len])
            square([tooth_w, tooth_len + eps]);
}
