// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom face on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_depth    = 12;    // depth of D-bore from bottom face
bore_w        = 4.7;   // width of D-bore (flat to opposite side)
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean booleans

// Derived
bore_r = bore_w / 2 + 0.01;   // D-bore radius (centre offset by 0.01)

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = bore_depth + eps);
    translate([0, -bore_r, -eps])
        rotate([90, 0, 0])
            cylinder(r = bore_r, h = bore_depth + eps);

    // Grip grooves
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove
    translate([knob_d / 2 - pointer_w / 2, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            cylinder(d = pointer_w, h = pointer_d + eps);
}