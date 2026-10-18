// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d      = 30;    // knob outer diameter (mm)
knob_h      = 15;    // knob height (mm)

bore_depth  = 12;    // D-bore depth from bottom face (mm)
bore_w      = 4.7;   // D-bore width: flat to opposite side of circle (mm)
bore_r      = bore_w / 2 + 0.785; // radius of the circle the D is drawn on (mm)

groove_n    = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter (mm)

pointer_w   = 1.5;   // pointer groove width (mm)
pointer_d   = 1;     // pointer groove depth (mm)

eps         = 0.5;   // overcut so cutting faces are not coplanar (mm)

$fn = 96;            // circle resolution

// ---------------- Model ----------------
difference() {
    // Main body: cylinder, centred on origin, resting on z = 0
    translate([0, 0, -eps])
        cylinder(d = knob_d, h = knob_h + 2 * eps);

    // D-shaped blind bore from the bottom face, extending past z = 0
    // The circle is centred on the origin; the flat is at x = -bore_r,
    // so the distance from the flat to the opposite side is exactly bore_w.
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            circle(r = bore_r);
    translate([-bore_r, 0, -eps])
        cube([bore_w - bore_r, bore_depth + 2 * eps, bore_depth + 2 * eps]);

    // 18 evenly spaced vertical grip grooves along the full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on the top face, on the same side as the D's flat
    translate([-pointer_w / 2, 0, knob_h - pointer_d])
        cube([pointer_w, knob_d / 2 + eps, pointer_d]);
}