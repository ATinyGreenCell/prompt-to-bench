// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: bottom face (z = 0) on the bed

// ---- Dimensions (mm) ----
knob_d        = 30;   // knob diameter
knob_h        = 15;   // knob height
bore_d        = 6.2;  // D-bore diameter
bore_depth    = 12;   // D-bore depth from bottom face
bore_flat     = 4.7;  // distance from D-bore flat to opposite side
groove_count  = 18;   // number of grip grooves
groove_d      = 2;    // groove diameter (half-cylinder)
pointer_w     = 1.5;  // pointer groove width
pointer_d     = 1;    // pointer groove depth
eps           = 0.5;  // cutter overshoot past faces

$fn = 96;

// Derived
bore_r = bore_d / 2;
flat_x = (bore_d - bore_flat) / 2;  // offset of flat from bore centre

difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            circle(r = bore_r, $fn = 96);
    translate([flat_x, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            circle(r = bore_r, $fn = 96);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d / 2 * (cos(a) + 1), 0, -eps])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h + 2 * eps);
    }

    // Pointer groove on top face, from centre to outer edge
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(r = knob_d / 2, $fn = 96);
    translate([0, 0, knob_h - pointer_d])
        rotate([0, 90, 0])
            linear_extrude(height = pointer_d + eps)
                circle(r = pointer_w / 2, $fn = 96);
}