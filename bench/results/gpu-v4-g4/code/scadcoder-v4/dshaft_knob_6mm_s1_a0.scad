// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on bed, z = 0

// ---------- Parameters ----------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-bore diameter (circle)
shaft_flat    = 4.7;   // distance from flat to opposite side of D-bore
bore_depth    = 12;    // D-bore depth from bottom face
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width at top face
pointer_d     = pointer_w * 2 / 3; // pointer groove diameter at centre
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------- Model ----------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = bore_depth + 2 * eps, $fn = 64);
    // flat on the D (on -y side)
    translate([0, -shaft_flat / 2, -eps])
        cube([shaft_d, shaft_flat, bore_depth + 2 * eps]);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        rotate([0, 0, a])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 16);
    }

    // Pointer groove on top face, same side as D flat (-y)
    translate([0, -knob_d / 2, knob_h - pointer_d / 2])
        linear_extrude(height = pointer_w)
            circle(d = pointer_d, $fn = 64);
}