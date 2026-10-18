// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: flat bottom face on bed (z = 0), builds upward.

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-bore diameter
shaft_bore_l  = 12;    // D-bore depth from bottom face
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Derived ----------------
outer_r = knob_d / 2;
// D-bore: circle diameter = shaft_d, flat depth = (shaft_d - shaft_bore_l)
flat_r  = (shaft_d - shaft_bore_l) / 2;

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = shaft_bore_l + 2 * eps)
            hull() {
                circle(r = outer_r + eps);   // curved side of D
                translate([0, -flat_r, 0])
                    square([shaft_d, shaft_bore_l + 2 * eps]); // flat side
            }

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([outer_r, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on top face (centre to outer edge)
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(r = outer_r + eps, $fn = 96);
}