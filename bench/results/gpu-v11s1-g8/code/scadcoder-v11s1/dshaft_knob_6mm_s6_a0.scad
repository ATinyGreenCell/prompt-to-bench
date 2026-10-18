// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Print orientation: bottom face (with D-bore opening) on the bed at z = 0

$fn = 96;

// ---- Knob body ----
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height

// ---- D-blind bore ----
bore_d      = 6.2;   // bore circle diameter
bore_depth  = 12;    // bore depth from bottom face
bore_flat   = bore_d / 2 - 1.5; // offset of flat side from centre (y)

// ---- Grip grooves ----
groove_n    = 18;    // number of evenly spaced grooves
groove_d    = 2;     // groove diameter (half-cylinder)

// ---- Pointer groove ----
pointer_w   = 1.5;   // groove width
pointer_d   = 1;     // groove depth
pointer_s   = bore_flat; // start y of groove (same side as flat)

eps         = 0.5;   // cutter overshoot

difference() {
    // Main body, centred in XY, resting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore, axis along Z, centred at y = bore_flat
    translate([0, bore_flat, 0])
        cylinder(d = bore_d, h = bore_depth + eps);

    // Vertical grip grooves along the full height
    for (i = [0 : groove_n - 1]) {
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h + eps);
    }

    // Pointer groove from centre to outer edge on top face
    translate([0, pointer_s, knob_h - pointer_d])
        cube([knob_d / 2 + eps, pointer_w, pointer_d + eps]);
}