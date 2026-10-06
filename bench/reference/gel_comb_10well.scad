// 10-well comb for casting agarose gels
// Category: tools. Flat part, prints lying down; the bottom (bed) side is smoothest.
// Print: PETG (survives hot agarose better than PLA), 0.15 mm layers, 100 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Comb] */
spine = [70, 12];      // back bar, X x Y [mm]
n_teeth = 10;
tooth_w = 5.0;         // well width
tooth_len = 12;        // well depth into the gel
gap = 1.5;             // gel between wells
thickness = 1.5;       // well thickness (comb printed flat)

/* [Hidden] */
eps = 0.01;
span = n_teeth * tooth_w + (n_teeth - 1) * gap;

linear_extrude(thickness) {
    translate([-spine.x / 2, 0]) square(spine);
    for (i = [0 : n_teeth - 1])
        translate([-span / 2 + i * (tooth_w + gap), -tooth_len])
            square([tooth_w, tooth_len + eps]);
}
