// Hotplate stirrer knob for a 6 mm D-shaft
// Print orientation: flat bottom face on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_d        = 6.2;   // D-bore diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = (bore_d - 4.7) / 2;  // offset of bore centre from flat side
groove_d      = 2;     // grip groove diameter
groove_count  = 18;    // number of grip grooves
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + eps);
    translate([0, bore_flat, -eps])
        rotate([90, 0, 0])
            cylinder(d = bore_d, h = bore_depth + eps);

    // Vertical grip grooves along the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge
    translate([knob_d / 2 - pointer_w / 2, 0, -eps])
        rotate([0, 90, 0])
            cylinder(d = pointer_w, h = pointer_d + eps);
}