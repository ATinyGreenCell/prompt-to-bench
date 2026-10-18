// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on the bed, z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-bore diameter
shaft_flat    = 4.7;   // distance from D-flat to opposite side
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Derived ----------------
// Half-width of D on the flat side (x < 0), so the flat spans x = -flat..0
flat_half = (shaft_d - shaft_flat) / 2;

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            polygon([
                [-flat_half, -shaft_flat / 2],
                [ flat_half, -shaft_flat / 2],
                [ shaft_d / 2, shaft_flat / 2],
                [- shaft_d / 2, shaft_flat / 2]
            ]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on top face, centred on +x axis
    translate([0, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = pointer_d + eps)
                polygon([
                    [-pointer_w / 2, 0],
                    [ pointer_w / 2, 0],
                    [ pointer_w / 2, -pointer_w / 2]
                ]);
}