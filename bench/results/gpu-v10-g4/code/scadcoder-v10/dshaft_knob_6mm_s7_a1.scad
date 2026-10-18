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
// Radius of the circle that gives shaft_flat when one side is cut flat
R = (shaft_d + shaft_flat) / 2;

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            circle(r = R, $fn = 96);

    // Flat side of the D, aligned with the circle
    translate([0, -shaft_flat / 2, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            circle(r = shaft_d / 2, $fn = 96);

    // Vertical grip grooves along the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on the top face, centred on the +X axis
    translate([0, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = pointer_w)
                circle(r = pointer_d, $fn = 96);
}