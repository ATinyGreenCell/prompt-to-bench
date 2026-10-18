// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom on bed (z = 0), curved top facing up

$fn = 96;

// ---- Dimensions (mm) ----
shaft_d      = 6.0;    // D-shaft diameter
knob_d       = 30.0;   // knob outer diameter
knob_h       = 15.0;   // knob height
bore_depth   = 12.0;   // D-bore depth from bottom face
bore_flat    = 4.7;    // D-bore flat side to opposite arc distance
groove_count = 18;     // vertical grip groove count
groove_d     = 2.0;    // groove diameter (half-cylinder)
pointer_w    = 1.5;    // pointer groove width
pointer_d    = 1.0;    // pointer groove depth
eps          = 0.5;    // cut overshoot past faces

// ---- Model ----
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            circle(d = bore_flat, $fn = 64);

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h);

    // Pointer groove from centre to outer edge (top face)
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(d = pointer_w, $fn = 64);
}