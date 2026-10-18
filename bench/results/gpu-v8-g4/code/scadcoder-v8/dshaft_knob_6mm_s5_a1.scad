// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (with D-bore) on the bed, z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft bore diameter
shaft_flat    = 4.7;   // distance from D-flat to opposite side of circle
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, eps])
        linear_extrude(height = knob_h - 2 * eps)
            circle(d = shaft_d);
    // Cut the flat side of the D
    translate([0, 0, eps])
        linear_extrude(height = knob_h - 2 * eps)
            polygon([
                [shaft_d / 2, 0],
                [shaft_flat, 0],
                [shaft_d / 2, shaft_flat]
            ]);

    // Vertical grip grooves around the outside, full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, eps])
                cylinder(d = groove_d, h = knob_h - 2 * eps, $fn = 16);

    // Pointer groove from the centre to the outer edge on the top face
    translate([0, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = pointer_w)
                circle(d = pointer_d);
}