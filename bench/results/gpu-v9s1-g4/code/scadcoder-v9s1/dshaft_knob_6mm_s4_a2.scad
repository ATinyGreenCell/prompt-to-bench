// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (with D-bore) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height
bore_d      = 6.2;   // D-bore diameter
bore_depth  = 12;    // D-bore depth from bottom face
bore_flat   = 4.7;   // distance from D-bore flat to opposite side of circle
grooves     = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth

eps         = 0.5;   // overcut so cutting shapes pass beyond faces

$fn = 96;            // resolution for curved surfaces

// ---------------- Derived ----------------
// Half-width of the flat cut into the D-bore circle
bore_flat_half = (bore_d - bore_flat) / 2;

// ---------------- Model ----------------
difference() {
    // Main body of the knob
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, eps])
        cylinder(d = bore_d, h = bore_depth + eps, $fn = 64);

    // Flat on one side of the D-bore (extends past the top face, keeps the shape)
    translate([-bore_flat_half, -bore_flat / 2, eps])
        cube([bore_flat_half, bore_flat, bore_depth + 2 * eps]);

    // 18 evenly spaced vertical grip grooves along the full height
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on the top face, on the same side as the D-bore flat
    translate([-bore_flat_half - 1, -pointer_w / 2, knob_h - pointer_d])
        cube([bore_flat_half + 2, pointer_w, pointer_d]);
}