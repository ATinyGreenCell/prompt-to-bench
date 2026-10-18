// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom on bed (z = 0), top face at z = 15

$fn = 96;

// ---- Dimensions (mm) ----
shaft_d      = 6;     // D-shaft diameter
knob_d       = 30;    // knob outer diameter
knob_h       = 15;    // knob height
bore_depth   = 12;    // D-bore depth from bottom face
bore_w       = 4.7;   // D-bore width (flat to opposite side)
groove_count = 18;    // vertical grip grooves
groove_d     = 2;     // groove diameter
ptr_w        = 1.5;   // pointer groove width
ptr_d        = 1;     // pointer groove depth
eps          = 0.5;   // cut overshoot

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore: circle with one side flattened
    translate([0, 0, -eps])
        hull()
            for (s = [-1, 1])
                translate([s * (knob_d / 2 - bore_w / 2), 0, 0])
                    cylinder(d = bore_w, h = bore_depth + eps, $fn = 64);

    // Vertical grip grooves
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on top face
    translate([0, 0, knob_h - eps])
        rotate([0, 90, 0])
            cylinder(d = ptr_w, h = ptr_d + eps);
}