// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom face on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_depth    = 12;    // depth of D-bore from bottom face
bore_w        = 4.7;   // width of D-bore (flat to opposite side)
groove_d      = 2;     // grip groove diameter
groove_count  = 18;    // number of grip grooves
pointer_w     = 1.5;   // pointer groove width
pointer_depth = 1;     // pointer groove depth
eps           = 0.5;   // overshoot for clean cuts

// Derived
bore_r = bore_d(bore_w) / 2;   // D-bore radius (approx, keeps aspect ratio)
gd     = groove_d / 2;

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore: circle with one side flattened
    translate([0, 0, -eps])
        intersection() {
            cylinder(r = bore_r, h = bore_depth + eps);
            translate([-bore_w / 2, 0, 0])
                cube([bore_w / 2 + eps, knob_d + 2 * eps, bore_depth + eps]);
        }

    // Grip grooves around the outside
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(r = gd, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge
    translate([0, 0, knob_h - pointer_depth])
        rotate([90, 0, 0])
            cylinder(r = pointer_w / 2, h = knob_d / 2 + eps);
}