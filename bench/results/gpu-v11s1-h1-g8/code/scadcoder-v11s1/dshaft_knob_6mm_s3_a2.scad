// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Print orientation: flat bottom face on the bed (z = 0), builds upward.
// The side of the D-bore that faces the hotplate is down (at z = 0).

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // depth of D-blind bore from bottom face
shaft_d       = 6;     // D-shaft diameter (bore is slightly larger)
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder, centred on surface)
pointer_w     = 1.5;   // pointer groove width (tangential)
pointer_d     = 1;     // pointer groove depth (radial, from centre outward)
eps           = 0.5;   // overcut for clean boolean differences

$fn = 96;              // smoothness for round features

// ---------------- Derived ----------------
bore_r = shaft_d / 2 + 0.1;   // bore radius (6.1 mm -> ~4.7 mm chord)
chord  = bore_d - eps;        // distance from flat to opposite side of bore

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore: circle with one side cut flat
    // Positioned so the flat face is at z = 0 (hotplate-facing side)
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            polygon([for (i = [0 : 63]) [bore_r * cos(i * 6), bore_r * sin(i * 6)],
                         [-(bore_d / 2 - eps), -chord / 2],
                         [-(bore_d / 2 - eps),  chord / 2]]);

    // Vertical grip grooves, evenly spaced along the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2 - groove_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h);

    // Pointer groove on top face: radial slot from centre to outer edge
    // Positioned on the same side as the D-bore flat (negative Y)
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([knob_d / 2 + eps, pointer_w, pointer_d + eps]);
}