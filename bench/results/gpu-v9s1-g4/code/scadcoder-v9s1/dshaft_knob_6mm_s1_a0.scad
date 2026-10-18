// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: flat bottom face on bed (z = 0)

$fn = 96;

// --- Dimensions (mm) ---
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat_w   = 4.7;   // width of D-bore (flat to opposite side)
bore_d        = 6.2;   // D-bore circle diameter
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth

eps           = 0.5;   // overcut for clean differences

// Derived
bore_r = bore_d / 2;
bore_x = (bore_d - bore_flat_w) / 2;   // offset of circle centre from flat

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, eps])
        union() {
            translate([bore_x, 0, 0])
                cylinder(r = bore_r, h = bore_depth + eps);
            translate([-bore_x, 0, 0])
                cylinder(r = bore_r, h = eps);
        }

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 6);

    // Pointer groove from centre to outer edge (same side as flat)
    translate([bore_x + 0.75, 0, knob_h - pointer_d])
        cube([pointer_w, knob_d / 2 + 1, pointer_d]);
}