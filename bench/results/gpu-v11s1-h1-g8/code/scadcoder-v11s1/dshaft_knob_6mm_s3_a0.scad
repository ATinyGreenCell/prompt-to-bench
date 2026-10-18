// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Print orientation: bottom face (with D-bore opening) on the bed at z = 0

$fn = 96;

// ---- Knob dimensions ----
knob_d       = 30;    // knob diameter
knob_h       = 15;    // knob height

// ---- D-bore dimensions ----
bore_d       = 6.2;   // bore circle diameter
bore_depth   = 12;    // blind bore depth from bottom face
bore_flat    = bore_d - 4.7;  // flat length (diameter - distance across circle)

// ---- Grip grooves ----
groove_count = 18;    // number of evenly spaced vertical grooves
groove_d     = 2;     // groove diameter (half-cylinder)

// ---- Pointer groove ----
pointer_w    = 1.5;   // pointer groove width
pointer_d    = 1;     // pointer groove depth
pointer_a    = 135;   // angle of pointer groove (side with D-flat)

eps          = 0.5;   // overcut for clean differences

difference() {
    // Main cylinder body
    translate([-knob_d/2, -knob_d/2, 0])
        cube([knob_d, knob_d, knob_h]);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            polygon([[-bore_d/2, bore_flat/2], [bore_d/2, bore_flat/2], [bore_d/2, -bore_flat/2]]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d/2 - groove_d/2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2*eps);
    }

    // Pointer groove from centre to outer edge on top face
    rotate([0, pointer_a, 0])
        translate([0, -pointer_w/2, knob_h - pointer_d])
            cube([knob_d/2 + eps, pointer_w, pointer_d + eps]);
}