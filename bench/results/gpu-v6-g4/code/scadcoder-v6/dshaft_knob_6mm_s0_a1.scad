// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on bed, z = 0

$fn = 96;

// --- Dimensions (mm) ---
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height
bore_d      = 6.2;   // D-bore circle diameter
bore_flat   = 4.7;   // distance from D-bore flat to opposite side
groove_n    = 18;    // number of grip grooves
groove_d    = 2;     // grip groove diameter (half-cylinder)
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth
eps         = 0.5;   // overcut for clean differences

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, eps])
        linear_extrude(height = knob_h - 2 * eps)
            circle(d = bore_d);
    translate([0, 0, eps])
        translate([bore_flat / 2, 0, 0])
            cube([bore_flat, bore_d, knob_h - 2 * eps]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove from centre to outer edge on top face
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_w)
            translate([0, -pointer_w / 2, 0])
                cube([knob_d / 2 + eps, pointer_w, pointer_d]);
}