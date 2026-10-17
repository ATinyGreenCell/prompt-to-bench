// Replacement knob for hotplate stirrer with D-shaft (6 mm)
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
bore_depth      = 12;    // D-shaped blind bore depth from bottom
shaft_d         = 6.2;   // D-shaft diameter
bore_flat       = 4.7;   // distance from D-bore flat to opposite side
groove_count    = 18;    // number of vertical grip grooves
groove_d        = 2;     // grip groove diameter (half-cylinder)
pointer_w       = 1.5;   // pointer groove width
pointer_d       = 1;     // pointer groove depth
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = bore_depth + 2 * eps, $fn = 64);

    // Outer grip grooves, full height, centred on surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 32);

    // Pointer groove on top face, same side as D-bore flat
    // (placed on -X so it shares the flat side with the bore)
    translate([-knob_d / 2, 0, knob_h - pointer_d])
        cube([knob_d / 2 + eps, pointer_w, pointer_d + eps]);
}