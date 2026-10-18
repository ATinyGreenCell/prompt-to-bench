// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom on bed (z = 0), bore opens downward

$fn = 96;

// ---- Dimensions (mm) ----
shaft_d      = 6;     // D-shaft diameter
knob_d       = 30;    // knob outer diameter
knob_h       = 15;    // knob height
bore_depth   = 12;    // blind bore depth from bottom face
bore_w       = 4.7;   // bore width (flat side to opposite arc)
groove_count = 18;    // vertical grip grooves
groove_d     = 2;     // groove diameter
ptr_w        = 1.5;   // pointer groove width
ptr_d        = 1;     // pointer groove depth
eps          = 0.5;   // cutter overshoot

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore: circle with one side flattened, centred at z = bore_depth
    translate([0, 0, bore_depth])
        linear_extrude(height = -eps)
            circle(d = bore_w, $fn = 64);

    // Vertical grip grooves
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 180 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove from centre to outer edge, top face
    rotate([0, 90, 0])
        translate([0, knob_d / 2 - 1, 0])
            cylinder(d = ptr_w, h = ptr_d + eps);
}