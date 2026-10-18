// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on bed at z = 0

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // D-bore depth from bottom face
bore_w        = 4.7;   // D-bore width (flat to opposite side)
bore_d        = 6.2;   // D-bore circle diameter
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth

eps           = 0.5;   // overcut for clean differences

// ---- Derived ----
bore_r = bore_d / 2;
flat_x = (bore_r - bore_w / 2) * -1;   // x of flat face (circle centred on origin)

difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, eps])
        union() {
            translate([flat_x, 0, 0])
                cube([bore_w, bore_r + eps, bore_depth + eps]);
            translate([flat_x - eps, 0, 0])
                cylinder(r = bore_r, h = bore_depth + 2 * eps);
        }

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d / 2 * cos(a), knob_d / 2 * sin(a), 0])
            rotate([0, 90, a])
                cylinder(d = groove_d, h = knob_h + 2 * eps, center = true);
    }

    // Pointer groove from centre to outer edge, on same side as flat
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_w, center = true)
            polygon([[-knob_d / 2, knob_h], [knob_d / 2, knob_h], [0, knob_h - pointer_d]]);
}