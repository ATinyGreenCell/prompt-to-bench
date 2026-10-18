// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom face on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_depth    = 12;    // depth of D-bore from bottom face
bore_w        = 4.7;   // width of D-bore (flat to opposite side)
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove cylinder diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

// ---- Derived ----
bore_r = (bore_w / 2) + (shaft_d / 2);  // radius so flat-to-opposite side = bore_w

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore: circle with one side cut flat, axis at z = bore_depth
    translate([0, 0, bore_depth - eps])
        intersection() {
            cylinder(r = bore_r, h = knob_h + 2 * eps);
            translate([-bore_w / 2 - eps, -bore_r - eps, -eps])
                cube([bore_w / 2 + eps, 2 * bore_r + 2 * eps, knob_h + 2 * eps]);
        }

    // Vertical grip grooves along the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge, top face
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([knob_d / 2, pointer_w, pointer_d + eps]);
}