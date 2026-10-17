// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: flat side of D bore down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
shaft_d         = 6;     // D-shaft diameter
bore_depth      = 12;    // blind bore depth from bottom face
bore_flat       = 4.7;   // flat-to-opposite-side distance of D bore
bore_r          = bore_d = 6.2; // D-bore circle radius (approx)
groove_count    = 18;    // number of grip grooves
groove_d        = 2;     // grip groove diameter
pointer_w       = 1.5;   // pointer groove width
pointer_d       = pointer_w * 2; // pointer groove diameter
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = bore_depth + 2 * eps, $fn = 64);

    // Flat on one side of the D bore
    translate([-(bore_d / 2 + eps), 0, -eps])
        cube([bore_d / 2 + eps, bore_d + 2 * eps, bore_depth + 2 * eps]);

    // Vertical grip grooves around full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on top face, centre to outer edge
    translate([0, 0, knob_h - eps])
        cylinder(d = pointer_d, h = eps + pointer_w / 2, $fn = 64);
}