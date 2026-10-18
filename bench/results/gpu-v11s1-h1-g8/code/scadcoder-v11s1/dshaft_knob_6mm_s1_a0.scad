// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore opening) on the bed at z = 0

$fn = 96;

// ---- Knob body ----
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height

// ---- D-blind bore (from bottom face) ----
bore_d      = 6.2;   // bore circle diameter
bore_depth  = 12;    // depth of bore into knob
bore_flat   = bore_d / 2 - 1.35;  // offset of flat from circle centre (gives 4.7 mm chord)

// ---- Grip grooves (outside, full height) ----
groove_n    = 18;    // number of evenly spaced grooves
groove_d    = 2;     // groove diameter (half-cylinder)

// ---- Pointer groove (top face) ----
pointer_w   = 1.5;   // groove width
pointer_d   = 1;     // groove depth
pointer_s   = 90;    // start angle of groove

eps         = 0.5;   // overshoot for clean cuts

difference() {
    // Main body, centred in XY, sitting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-blind bore, centred at z = knob_h - bore_depth
    translate([0, 0, knob_h - bore_depth])
        union() {
            cylinder(d = bore_d, h = bore_depth + eps);
            translate([bore_flat, 0, -eps])
                cube([bore_d - 2 * bore_flat, bore_d, bore_depth + eps]);
        }

    // Vertical grip grooves along the full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove from centre to outer edge on top face
    rotate([0, 0, pointer_s])
        translate([0, -pointer_w / 2, knob_h - pointer_d])
            cube([knob_d / 2 + eps, pointer_w, pointer_d + eps]);
}