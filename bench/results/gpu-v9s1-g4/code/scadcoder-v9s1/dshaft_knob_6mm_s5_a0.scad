// Replacement knob for hotplate stirrer (D-shaft)
// Print orientation: flat bottom face on bed (z = 0)

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // D-bore depth from bottom face
bore_w        = 4.7;   // D-bore width (flat to opposite side)
bore_d        = 6.2;   // D-bore circle diameter
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + 2 * eps);
    translate([-(bore_w - bore_d) / 2, 0, -eps])
        cube([bore_w, knob_d, bore_depth + 2 * eps]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove from centre to outer edge, on flat side
    translate([-pointer_w / 2, 0, knob_h - pointer_d])
        cube([pointer_w, knob_d / 2, pointer_d]);
}