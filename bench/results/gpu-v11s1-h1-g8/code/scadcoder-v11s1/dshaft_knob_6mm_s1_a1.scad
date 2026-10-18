// Hotplate stirrer knob for D-shaft (6 mm)
// Print orientation: flat bottom on bed (z = 0), top face at z = 15

$fn = 96;

// ---- Dimensions (mm) ----
knob_d       = 30;    // knob diameter
knob_h       = 15;    // knob height
bore_d       = 6.2;   // D-bore circle diameter
bore_depth   = 12;    // D-bore depth from bottom face
bore_flat    = bore_d / 2 - 0.7;  // D-bore flat offset from centre
groove_n     = 18;    // number of grip grooves
groove_d     = 2;     // grip groove diameter
pointer_w    = 1.5;   // pointer groove width
pointer_d    = 1;     // pointer groove depth
eps          = 0.5;   // cutter overshoot

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        hull() {
            cylinder(d = bore_d, h = bore_depth + eps);
            translate([0, -bore_flat - eps, 0])
                cube([bore_d, bore_flat + 2 * eps, bore_depth + eps]);
        }

    // Vertical grip grooves along full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove from centre to edge, top face
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([knob_d / 2 + eps, pointer_w, pointer_d + eps]);
}