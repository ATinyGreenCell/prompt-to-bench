// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (with D-bore) on the bed, z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft bore diameter
flat_dist     = 4.7;   // distance from D-flat to opposite side of circle
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, 0])
        linear_extrude(height = 12)
            circle(d = shaft_d);
    // Cut the flat side of the D (through the extruded piece)
    translate([0, 0, 12])
        linear_extrude(height = eps)
            polygon([
                [shaft_d / 2, 0],
                [flat_dist, 0],
                [flat_dist, -flat_dist],
                [shaft_d / 2, -flat_dist]
            ]);

    // Vertical grip grooves around the outside, full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 16);

    // Pointer groove on the top face, from centre to outer edge
    // placed on the same side as the D-flat (positive X)
    translate([0, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = pointer_w)
                circle(d = pointer_d);
}