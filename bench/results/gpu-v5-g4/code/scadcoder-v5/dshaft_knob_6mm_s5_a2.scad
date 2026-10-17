// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
shaft_d         = 6;     // D-shaft diameter
bore_depth      = 12;    // blind bore depth from bottom face
bore_flat       = 4.7;   // distance from flat to opposite side of bore
groove_count    = 18;    // number of vertical grip grooves
groove_d        = 2;     // groove diameter (half-cylinder)
pointer_w       = 1.5;   // pointer groove width
pointer_d       = 1;     // pointer groove depth
eps             = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Derived ----------------
bore_d = bore_flat + shaft_d;  // bore diameter (flat to opposite side)
bore_r = bore_d / 2;           // bore radius from flat side

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = bore_depth + 2 * eps, $fn = 64);

    // Vertical grip grooves around full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 32);

    // Pointer groove on top face, same side as bore flat
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(r = min(pointer_w, pointer_d / 2), $fn = 16);
}