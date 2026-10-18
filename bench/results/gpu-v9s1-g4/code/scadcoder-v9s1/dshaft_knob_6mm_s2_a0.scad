// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: bottom face (with D-bore) on bed at z = 0

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_d        = 6.2;   // D-bore circle diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = 4.7;   // distance from D-bore flat to opposite side
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overshoot for clean boolean cuts

$fn = 96;

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, eps])
        cylinder(d = bore_d, h = bore_depth + eps, $fn = 64);
    // cut the flat side of the D
    translate([-(bore_d - bore_flat) / 2, 0, eps])
        cube([(bore_d - bore_flat) / 2 + eps, bore_d + 2 * eps, bore_depth + eps]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge, on the D flat side
    translate([-pointer_w / 2, 0, knob_h - pointer_d])
        cube([pointer_w, knob_d / 2 + eps, pointer_d]);
}