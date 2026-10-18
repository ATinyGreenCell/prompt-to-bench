// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on the bed, z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-bore diameter
shaft_flat    = 4.7;   // distance from D flat to opposite side
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Derived ----------------
D = knob_d - 2 * eps;                       // outer cylinder diameter
R = D / 2;
pitch = 360 / groove_count;                // groove angular spacing

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = D, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            hull() {
                circle(d = shaft_d);
                translate([-(shaft_d - shaft_flat) / 2, 0, 0])
                    square([shaft_d - shaft_flat, shaft_d - shaft_flat]);
            }

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, pitch * i])
            translate([R, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on top face, centred on +X axis
    translate([0, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = pointer_d)
                polygon([
                    [0, 0],
                    [R, 0],
                    [R - pointer_w / 2, pointer_w / 2],
                    [R - pointer_w / 2, -pointer_w / 2]
                ]);
}