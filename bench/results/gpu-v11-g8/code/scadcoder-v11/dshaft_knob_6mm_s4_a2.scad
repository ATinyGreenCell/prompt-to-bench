// Hotplate stirrer knob for a 6 mm D-shaft
// Print orientation: flat bottom face on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height
shaft_d     = 6;     // D-shaft diameter
bore_depth  = 12;    // depth of D-bore from bottom face
bore_w      = 4.7;   // width of D-bore (flat to opposite side)
groove_n    = 18;    // number of grip grooves
groove_d    = 2;     // grip groove diameter
ptr_w       = 1.5;   // pointer groove width
ptr_d       = 1;     // pointer groove depth
eps         = 0.5;   // overshoot for clean cuts

// ---- Derived ----
bore_r = (bore_w + shaft_d) / 2;   // radius of D-bore circle

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore (circle with one side cut flat)
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = bore_depth + eps);
    // flatten the -Y side of the bore
    translate([-(bore_r + eps), 0, -eps])
        cube([2 * (bore_r + eps), bore_r + eps, bore_depth + eps]);

    // Grip grooves around the outside
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on top face, same side as the D-flat (-Y)
    translate([0, -ptr_w / 2, knob_h - ptr_d])
        cube([knob_d, ptr_w, ptr_d + eps]);
}