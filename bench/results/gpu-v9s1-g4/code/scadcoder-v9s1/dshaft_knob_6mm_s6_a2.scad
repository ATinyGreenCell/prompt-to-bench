// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: the side that faces the hotplate is down on the bed (z = 0)

// ---------------- Parameters ----------------
knob_d      = 30;    // knob diameter (mm)
knob_h      = 15;    // knob height (mm)
bore_depth  = 12;    // depth of D-shaped blind bore from bottom face (mm)
shaft_d     = 6.2;   // D-shaft diameter (mm)
bore_w      = 4.7;   // width of D-bore: flat to opposite side of circle (mm)
grooves     = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter (mm)
pointer_w   = 1.5;   // pointer groove width (mm)
pointer_d   = 1;     // pointer groove depth (mm)
eps         = 0.5;   // overcut for clean boolean differences (mm)

$fn = 96;            // smoothness of curved surfaces

// ---------------- Derived ----------------
angle_res = 360 / grooves;   // groove spacing angle
flat_t    = sqrt(shaft_d^2 - bore_w^2);  // thickness of D-flat (2.8 mm)

// ---------------- Model ----------------
difference() {
    // Main body: cylinder 30 mm in diameter, 15 mm tall, resting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face, extended past the top face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            polygon([[-flat_t / 2, -shaft_d / 2], [-flat_t / 2, shaft_d / 2],
                     [bore_w / 2, 0]]);

    // 18 evenly spaced vertical grip grooves along the full height
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * angle_res])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on the top face, on the same side as the D-flat
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(d = pointer_w, $fn = 64);
}