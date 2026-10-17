// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: flat side of D facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_depth    = 12;    // blind bore depth from bottom face
bore_flat     = 4.7;   // flat-to-flat width of D bore (4.7 mm)
bore_r        = bore_d/2; // bore radius (6.2 mm circle)
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = pointer_w + 2; // pointer groove diameter
pointer_depth = 1;     // pointer groove depth

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---------------- Derived ----------------
bore_d = bore_flat + bore_r; // 6.2 mm circle with one side cut flat

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + 2*eps, $fn = 64);

    // Vertical grip grooves around outside, full height
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d/2, 0, 0])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h + 2*eps, $fn = 64);
    }

    // Pointer groove on top face, same side as D flat
    translate([0, 0, knob_h - pointer_depth])
        cylinder(d = pointer_d, h = pointer_depth + 0.01, $fn = 64);
}