// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: the side that faces the hotplate is down on the bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter (mm)
knob_h        = 15;    // knob height (mm)

shaft_d       = 6.2;   // D-bore diameter (mm)
shaft_flat    = 4.7;   // distance from the flat of the D to the opposite side (mm)

groove_count  = 18;    // number of vertical grip grooves (mm)
groove_d      = 2;     // groove diameter (mm)

pointer_w     = 1.5;   // pointer groove width (mm)
pointer_d     = 1;     // pointer groove depth (mm)

eps           = 0.5;   // overcut for clean differences (mm)

$fn = 96;              // resolution for curved shapes

// ---------------- Derived ----------------
shaft_r = shaft_d / 2;
// chord length of the D cut at depth eps, keeping the flat horizontal
chord   = sqrt(shaft_d * eps - eps * eps);

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            union() {
                translate([0, 0, 0])
                    cylinder(d = shaft_d, h = knob_h);
                translate([-shaft_r, 0, 0])
                    translate([0, 0, -eps])
                        cube([chord, 2 * eps, knob_h + 2 * eps]);
            }

    // Vertical grip grooves, evenly spaced, centred on the outer surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 32);

    // Pointer groove on the top face, on the same side as the flat of the D
    translate([0, 0, knob_h - eps])
        linear_extrude(height = eps + pointer_d)
            polygon([
                [0, 0],
                [pointer_w / 2, 0],
                [pointer_w / 2, knob_d / 2],
                [-pointer_w / 2, knob_d / 2],
                [-pointer_w / 2, 0]
            ]);
}