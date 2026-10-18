// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on the bed, z = 0

$fn = 96;

// ---- Dimensions (mm) ----
knob_d      = 30;    // outer diameter of knob
knob_h      = 15;    // overall height
bore_d      = 6.2;   // D-bore diameter
bore_flat   = 4.7;   // distance from flat to opposite side of D-bore
groove_d    = 2;     // grip groove diameter (half-cylinder)
groove_n    = 18;    // number of grip grooves
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth
eps         = 0.5;   // overcut for clean differences

// Derived
bore_r = bore_d / 2;

difference() {
    // Main cylinder
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, 0])
        linear_extrude(height = knob_h - bore_r + eps)
            circle(r = bore_r, $fn = 64);
    // Cut the flat side of the D
    translate([bore_flat - eps, 0, 0])
        cube([eps, knob_h - bore_r + eps, 1]);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 16);

    // Pointer groove on top face, from centre to outer edge
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(r = knob_d / 2, $fn = 64);
    // Remove material outside the pointer width
    translate([pointer_w / 2, 0, knob_h - pointer_d])
        cube([knob_d / 2 - pointer_w / 2, knob_d / 2 + eps, pointer_d + eps]);
}