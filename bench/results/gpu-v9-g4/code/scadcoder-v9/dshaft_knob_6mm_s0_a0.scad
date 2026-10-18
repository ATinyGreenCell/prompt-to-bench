// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: bottom face (shaft bore) on bed at z = 0

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft diameter
bore_depth    = 12;    // blind bore depth from bottom face
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = bore_depth + eps, $fn = 64);

    // D-flat cutter, centred on the shaft
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            circle(d = shaft_d, $fn = 64);

    // Grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge, top face
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d)
            circle(d = pointer_w, $fn = 64);

    // Flat for pointer groove, centred on shaft side
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d)
            circle(d = pointer_w, $fn = 64);
}