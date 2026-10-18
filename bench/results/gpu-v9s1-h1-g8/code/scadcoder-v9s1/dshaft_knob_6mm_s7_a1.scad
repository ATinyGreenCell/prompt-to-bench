// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter (mm)
knob_h        = 15;    // knob height (mm)

bore_d        = 6.2;   // D-bore circle diameter (mm)
bore_depth    = 12;    // D-bore depth from bottom face (mm)
bore_flat     = 4.7;   // distance from D-bore flat to opposite side of circle (mm)

groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // grip groove diameter (mm)

pointer_w     = 1.5;   // pointer groove width (mm)
pointer_d     = 1;     // pointer groove depth (mm)

eps           = 0.5;   // overcut past cut faces to avoid coplanar faces (mm)

$fn = 128;             // circle resolution

// ---------------- Derived ----------------
bore_r = bore_d / 2;
// D-bore centre is offset toward the flat by (bore_r - bore_flat/2)
bore_x = -(bore_r - bore_flat / 2);
bore_y = 0;

// ---------------- Model ----------------
difference() {
    // Main body: cylinder, printed upright
    translate([0, 0, 0])
        cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([bore_x, bore_y, -eps])
        cylinder(r = bore_r, h = bore_depth + 2 * eps);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h);

    // Pointer groove: radial slot from centre to outer edge,
    // on the same side as the D-bore flat (positive Y)
    translate([0, pointer_w / 2, 0])
        cube([knob_d / 2 - eps, pointer_w, knob_h - pointer_d]);
}