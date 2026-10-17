// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: the side that faces the hotplate is down on the bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter (mm)
knob_h        = 15;    // knob height (mm)

bore_d        = 6.2;   // D-bore diameter (mm)
bore_depth    = 12;    // D-bore depth from the bottom face (mm)
bore_flat     = 4.7;   // distance from the flat side of the D to the opposite side (mm)

groove_d      = 2;     // grip groove diameter (mm)
groove_count  = 18;    // number of grip grooves, evenly spaced (mm)
groove_depth  = 1;     // grip groove depth (mm)

pointer_w     = 1.5;   // pointer groove width (mm)
pointer_depth = 1;     // pointer groove depth (mm)

eps           = 0.5;   // overcut so cutting shapes pass through faces (mm)

$fn = 96;              // resolution for curved surfaces

// ---------------- Derived ----------------
bore_r = bore_d / 2;
// chord length of the D-bore on the flat side
bore_chord = sqrt(bore_flat * (bore_flat - 2 * eps));

// ---------------- Model ----------------
difference() {
    // Main body of the knob
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            polygon([
                [0, -bore_r],
                [bore_chord / 2, -bore_flat / 2],
                [-bore_chord / 2, -bore_flat / 2]
            ]);

    // Vertical grip grooves along the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on the top face, on the same side as the flat of the D
    translate([0, 0, knob_h - pointer_depth])
        linear_extrude(height = pointer_depth + eps)
            polygon([
                [0, 0],
                [pointer_w / 2, 0],
                [pointer_w / 2, knob_d / 2],
                [-pointer_w / 2, knob_d / 2],
                [-pointer_w / 2, 0]
            ]);
}