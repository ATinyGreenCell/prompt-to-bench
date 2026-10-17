// Replacement knob for hotplate stirrer with D-shaft (6 mm)
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
bore_depth      = 12;    // blind bore depth from bottom face
shaft_d         = 6.2;   // D-shaft diameter
bore_flat       = 4.7;   // distance from flat to opposite side of bore
groove_count    = 18;    // number of vertical grip grooves
groove_d        = 2;     // groove diameter (half-cylinder)
pointer_w       = 1.5;   // pointer groove width
pointer_d       = 1;     // pointer groove depth
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Derived ----------------
bore_r = shaft_d / 2;
// chord length of bore circle on the flat side
bore_chord = sqrt(bore_r * bore_r - (bore_flat / 2) * (bore_flat / 2));
bore_x0 = -bore_chord;  // flat side at x = bore_x0 - bore_r
bore_y0 = -bore_flat / 2;

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([bore_x0, bore_y0, -eps])
        cylinder(r = bore_r, h = bore_depth + 2 * eps, $fn = 64);

    // Vertical grip grooves around full height
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d / 2, 0, -eps])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 32);
    }

    // Pointer groove on top face, same side as bore flat
    translate([-knob_d / 2 - eps, bore_y0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + 2 * eps)
            polygon([[-knob_d / 2 - eps, bore_y0],
                     [knob_d / 2 + eps, bore_y0],
                     [knob_d / 2 + eps, bore_y0 + pointer_w],
                     [-knob_d / 2 - eps, bore_y0 + pointer_w]]);
}