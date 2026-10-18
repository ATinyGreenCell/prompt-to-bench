// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
shaft_d         = 6;     // D-shaft diameter
bore_depth      = 12;    // blind bore depth from bottom face
bore_flat       = 4.7;   // distance from D-bore flat to opposite side
bore_r          = bore_d / 2;  // bore radius (6.2 mm)
groove_count    = 18;    // number of grip grooves
groove_d        = 2;     // grip groove diameter
pointer_width   = 1.5;   // pointer groove width
pointer_depth   = 1;     // pointer groove depth
eps             = 0.5;   // cutter overshoot past faces
$fn             = 96;    // curve resolution

// Derived
bore_d = 6.2;

// ---------------- Model ----------------
difference() {
    // Main cylinder
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + 2 * eps, $fn = 64);

    // Flat on bottom face, on the same side as the bore flat
    // (keeps the D-features aligned)
    translate([-knob_d / 2, 0, 0])
        linear_extrude(height = eps)
            polygon([[-knob_d / 2, 0], [knob_d / 2, 0]]);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d / 2, 0, 0])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h, $fn = 16);
    }

    // Pointer groove from centre to outer edge, top face only
    translate([0, 0, knob_h - pointer_depth])
        linear_extrude(height = pointer_depth + eps)
            circle(d = pointer_width, $fn = 64);
}