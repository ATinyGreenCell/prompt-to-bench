// Hotplate stirrer knob for a 6 mm D-shaft
// Print orientation: bottom face (with D-bore opening) on the bed at z = 0

// ---------- Parameters ----------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_depth    = 12;    // depth of D-blind bore from bottom face
bore_d        = 6.2;   // bore circle diameter (flat reduces it to 4.7 mm)
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove cylinder diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean boolean differences

$fn = 96;

// ---------- Model ----------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore, centred on the -X side
    translate([0, 0, -eps])
        intersection() {
            cylinder(d = bore_d, h = bore_depth + eps);
            translate([-knob_d / 2 - eps, -knob_d / 2 - eps, 0])
                cube([knob_d / 2 + eps, knob_d + 2 * eps, bore_depth + eps]);
        };

    // 18 evenly spaced vertical grip grooves along the full height
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);
    }

    // Pointer groove from centre to outer edge, on the +X side
    translate([0, 0, -eps])
        linear_extrude(height = pointer_d + eps)
            polygon([
                [0, 0],
                [pointer_w, 0],
                [pointer_w * cos(45), pointer_w * sin(45)],
                [knob_d / 2, 0]
            ]);
}