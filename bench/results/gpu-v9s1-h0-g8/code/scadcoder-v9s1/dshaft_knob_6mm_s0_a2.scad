// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------- Dimensions (mm) ----------
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height
bore_depth  = 12;    // D-bore depth from bottom face
bore_w      = 4.7;   // D-bore width (flat to opposite side of circle)
bore_d      = 6.2;   // D-bore circle diameter
groove_n    = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth

// ---------- Derived ----------
eps = 0.5;             // overcut so cutting faces are not coplanar
flat_x = -bore_d / 2;  // x position of D-bore flat (circle centre)

// ---------- Model ----------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([flat_x, 0, eps])
        cylinder(r = bore_d / 2, h = bore_depth + eps, $fn = 96);

    // 18 evenly spaced vertical grip grooves, full height, centred on surface
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge, same side as the D-flat
    translate([flat_x - pointer_w / 2, 0, knob_h - pointer_d])
        cube([pointer_w, knob_d / 2 + 2, pointer_d]);
}