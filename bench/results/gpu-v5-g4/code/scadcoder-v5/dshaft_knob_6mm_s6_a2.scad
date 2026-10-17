// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
shaft_d         = 6;     // D-shaft diameter
bore_depth      = 12;    // blind bore depth from bottom face
bore_d          = 6.2;   // bore circle diameter
bore_flat       = 4.7;   // distance from flat to opposite side of bore
groove_count    = 18;    // number of grip grooves
groove_d        = 2;     // groove diameter (half-cylinder)
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
        cylinder(d = bore_d, h = bore_depth + 2 * eps, $fn = 64);

    // Flat on one side of the bore (D-shape)
    translate([-(bore_d / 2 + eps), 0, -eps])
        cube([bore_d / 2 + eps, bore_flat, bore_depth + 2 * eps]);

    // Vertical grip grooves around full height
    for (i = [0 : groove_count - 1]) {
        a = (i / groove_count) * 360;
        translate([knob_d / 2, 0, -eps])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 32);
    }

    // Pointer groove on top face, centre to outer edge
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(d = pointer_w, $fn = 64);
}