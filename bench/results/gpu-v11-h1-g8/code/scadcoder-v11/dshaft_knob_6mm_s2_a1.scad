// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom on bed (z = 0), builds upward

$fn = 96;

// ---- Dimensions (mm) ----
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height
shaft_d     = 6;     // D-shaft diameter
bore_depth  = 12;    // D-bore depth from bottom face
groove_n    = 18;    // grip groove count
groove_d    = 2;     // grip groove diameter
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth
eps         = 0.5;   // cutter overshoot

// ---- Derived ----
bore_r = shaft_d / 2 + 0.1;   // D-bore radius (oval)
flat   = bore_r - 4.7 / 2;    // flat offset from centre

// ---- Model ----
difference() {
    // Knob body
    cylinder(d = knob_d, h = knob_h);

    // D-bore (blind, from bottom)
    translate([0, 0, -eps])
        rotate([90, 0, 0])
            cylinder(r = bore_r, h = bore_depth + eps);
    translate([0, -flat - eps, -eps])
        cube([bore_depth + eps, flat + eps, eps + 0.5]);

    // Grip grooves
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove (top face, centre to outer edge)
    translate([0, 0, knob_h - pointer_d])
        rotate([0, 90, 0])
            cylinder(r = pointer_w / 2, h = knob_d / 2 + eps);
}