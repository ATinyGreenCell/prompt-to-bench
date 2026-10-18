// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on the bed at z = 0

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob diameter
knob_h        = 15;    // knob height
bore_d        = 6.2;   // D-bore diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = 4.7;   // distance from D-bore flat to opposite side
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_depth = 1;     // pointer groove depth
eps           = 0.5;   // overshoot for clean cuts

// Derived
outer_r = knob_d / 2;

module d_bore() {
    // D shape in X-Y, extruded up from z = 0
    difference() {
        translate([-bore_flat - eps, bore_d / 2 + eps, 0])
            cube([bore_d + 2 * eps, bore_d + 2 * eps, bore_depth]);
    }
}

module grip_grooves() {
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([outer_r, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 64);
    }
}

module pointer_groove() {
    // Spiral groove from centre to outer edge, on +Y side
    translate([0, -pointer_depth, 0])
        rotate_extrude($fn = 64)
            translate([outer_r, pointer_w / 2, 0])
                circle(d = pointer_w, $fn = 64);
}

difference() {
    cylinder(d = knob_d, h = knob_h);
    d_bore();
    grip_grooves();
    pointer_groove();
}