// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d      = 30;    // knob outer diameter (mm)
knob_h      = 15;    // knob height (mm)

bore_depth  = 12;    // D-bore depth from bottom face (mm)
bore_w      = 4.7;   // D-bore width: flat to opposite side of circle (mm)
bore_d      = 6.2;   // diameter of the circle the D-bore is cut from (mm)

groove_n    = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter (mm)

pointer_w   = 1.5;   // pointer groove width (mm)
pointer_d   = 1;     // pointer groove depth (mm)

eps         = 0.5;   // overcut so cutting shapes pass beyond faces (mm)

$fn = 128;           // circle resolution

// ---------------- Derived ----------------
// Offset of the D-bore circle centre from its lowest point.
// The lowest point lies on the same horizontal line as the flat,
// so the distance from the flat to the centre is bore_d / 2.
bore_y0 = bore_d / 2;

// ---------------- Model ----------------
difference() {
    // Main body: cylinder centred on the origin in X and Y,
    // resting on z = 0 and building upward.
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face.
    // In the file the circle is centred at (0, bore_y0); the flat
    // is cut along the negative Y axis, so the distance from the
    // flat to the opposite side of the circle is exactly bore_w.
    translate([0, -bore_y0, eps])
        union() {
            // Circle of diameter bore_d
            cylinder(d = bore_d, h = bore_depth + eps, $fn = 96);
            // Flat extension along -Y, from the circle edge out to eps
            translate([0, -bore_d / 2 - eps, 0])
                cube([bore_d / 2 + 2 * eps, eps, bore_depth + eps]);
        }

    // 18 evenly spaced vertical grip grooves along the full height,
    // each a half-cylinder of diameter groove_d centred on the outer surface.
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on the top face, on the same side as the D-bore flat.
    // It runs from the centre to the outer edge: a straight slot 1 mm
    // deep, 1.5 mm wide, from radius 0 out to radius knob_d / 2.
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([pointer_d, pointer_w, knob_h - pointer_d + eps]);
}