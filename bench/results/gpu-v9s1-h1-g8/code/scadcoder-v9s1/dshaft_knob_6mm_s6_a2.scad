// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (with bore) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter (mm)
knob_h        = 15;    // knob height (mm)

bore_d        = 6.2;   // D-bore circle diameter (mm)
bore_depth    = 12;    // D-bore depth from bottom face (mm)
bore_flat     = 4.7;   // distance from D-bore flat to opposite side (mm)

groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // grip groove diameter (mm)

pointer_w     = 1.5;   // pointer groove width (mm)
pointer_d     = 1;     // pointer groove depth (mm)

eps           = 0.5;   // overcut so cutting faces are not coplanar (mm)

$fn = 128;             // circle resolution

// ---------------- Derived ----------------
function bore_r() = bore_d / 2;

// ---------------- Model ----------------
difference() {
    // Main body: cylinder, centred in X/Y, sitting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, -eps])
        union() {
            // Circle
            cylinder(r = bore_r(), h = bore_depth + 2 * eps);
            // Flat on one side: extend past the wall, keep the same y span
            translate([-bore_flat / 2, -bore_r() + eps, 0])
                cube([bore_flat, 2 * (bore_r() - eps), bore_depth + eps]);
        }

    // Vertical grip grooves along the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on the top face, on the same side as the D-flat
    // (extruded along X, so the polygon lies in the X/Y plane)
    translate([-knob_d / 2 - eps, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = knob_d / 2 + eps)
                polygon([
                    [0,         knob_d / 2],
                    [pointer_w, knob_d / 2],
                    [pointer_w, -knob_d / 2],
                    [0,         -knob_d / 2]
                ]);
}