// Hotplate stirrer knob - D-shaft adapter with grip grooves
// Print orientation: flat bottom on bed (z = 0), D-flat facing hotplate

$fn = 96;

// ---- Dimensions (mm) ----
shaft_d      = 6;     // D-shaft diameter
knob_d       = 30;    // knob outer diameter
knob_h       = 15;    // knob height
bore_depth   = 12;    // D-bore depth from bottom face
bore_w       = 4.7;   // D-bore width (flat to opposite side)
groove_count = 18;    // vertical grip grooves
groove_d     = 2;     // groove diameter
pointer_w    = 1.5;   // pointer groove width
pointer_d    = 1;     // pointer groove depth
eps          = 0.5;   // cutter overshoot

// ---- Derived ----
bore_r = bore_w / 2;

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-blind bore from bottom face
    translate([0, -bore_r, -eps])
        cylinder(r = bore_r, h = bore_depth + eps, $fn = 96);

    // Vertical grip grooves
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on top face, aligned with D-flat (negative Y)
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([knob_d / 2 + eps, pointer_w, pointer_d + eps]);
}