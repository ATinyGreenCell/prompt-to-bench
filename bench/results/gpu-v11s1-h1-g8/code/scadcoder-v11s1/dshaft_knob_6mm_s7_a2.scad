// Hotplate stirrer knob for D-shaft
// Print orientation: bottom face (with D-bore opening) on the bed at z = 0

$fn = 96;

// ---- Knob body ----
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height

// ---- D-blind bore ----
bore_d      = 6.2;   // bore circle diameter
bore_depth  = 12;    // bore depth from bottom face
bore_flat   = bore_d - 4.7;  // flat length so the flat-to-opposite side is 4.7 mm

// ---- Grip grooves ----
groove_n    = 18;    // number of evenly spaced grooves
groove_d    = 2;     // groove (half-cylinder) diameter

// ---- Pointer groove ----
pointer_w   = 1.5;   // groove width
pointer_d   = 1;     // groove depth
pointer_s   = 90;    // start angle from X axis (same side as bore flat)

eps         = 0.5;   // overshoot for clean boolean cuts

difference() {
    // Main body, centred in XY, sitting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            polygon([[-bore_d / 2, 0], [bore_d / 2, 0], [0, bore_flat / 2]]);

    // Vertical grip grooves along the full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove from centre to outer edge on top face
    translate([knob_d / 2, 0, -eps])
        rotate([0, 0, pointer_s])
            cube([pointer_w, knob_d / 2, knob_h + pointer_d + eps]);
}