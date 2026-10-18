// Hotplate stirrer knob - D-shaft 6 mm
// Print orientation: bottom face (with D-bore) on the bed, z = 0

$fn = 96;

// ---- Dimensions (mm) ----
knob_d       = 30;    // knob diameter
knob_h       = 15;    // knob height
bore_depth   = 12;    // D-bore depth from bottom face
bore_d       = 6.2;   // D-bore circle diameter
bore_flat    = 4.7;   // D-bore flat side length
groove_count = 18;    // vertical grip grooves
groove_d     = 2;     // groove diameter
pointer_w    = 1.5;   // pointer groove width
pointer_d    = 1;     // pointer groove depth
eps          = 0.5;   // overcut for clean bores

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore: circle with one side cut flat
    translate([0, 0, -eps])
        hull() {
            cylinder(d = bore_d, h = bore_depth + eps);
            translate([bore_flat / 2, 0, -eps])
                cube([bore_flat, bore_depth + eps, eps * 2]);
        }

    // Vertical grip grooves
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on top face, along +X
    translate([-pointer_w / 2, -pointer_d / 2, knob_h])
        cube([pointer_w + eps, pointer_d + eps, eps * 2]);
}