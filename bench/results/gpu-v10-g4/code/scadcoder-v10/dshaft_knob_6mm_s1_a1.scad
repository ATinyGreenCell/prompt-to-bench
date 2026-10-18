// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on bed, z = 0

// ---------- Parameters ----------
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

// ---------- Derived ----------
R = knob_d / 2;
// half-chord of D: distance from bore centre to flat edge
half_chord = sqrt((shaft_d / 2)^2 - (shaft_flat / 2)^2);

// ---------- Model ----------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            polygon([[-shaft_d / 2, -half_chord],
                     [ shaft_d / 2, -half_chord],
                     [ shaft_d / 2,  half_chord],
                     [-(shaft_d / 2),  half_chord]]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([R, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on top face, centred on +X axis
    translate([0, R + eps, 0])
        rotate([90, 0, 0])
            linear_extrude(height = knob_h + 2 * eps)
                polygon([[-pointer_w / 2, -pointer_d / 2],
                         [ pointer_w / 2, -pointer_d / 2],
                         [ pointer_w / 2,  pointer_d / 2]]);
}