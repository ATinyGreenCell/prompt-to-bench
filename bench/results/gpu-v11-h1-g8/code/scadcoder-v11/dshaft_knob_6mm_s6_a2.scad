// Hotplate stirrer knob for a 6 mm D-shaft
// Print orientation: bottom face (with D-bore) on the bed at z = 0

// ---------- Dimensions (mm) ----------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_d        = 6.2;   // D-bore circle diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = (bore_d - 4.7) / 2;  // offset of flat from circle centre (1.95)
groove_d      = 2;     // grip groove cylinder diameter
groove_count  = 18;    // number of grip grooves
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------- Model ----------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore in bottom face
    translate([0, 0, -eps])
        intersection() {
            cylinder(d = bore_d, h = bore_depth + eps);
            translate([-bore_flat, 0, -eps])
                cube([bore_flat + eps, bore_d + 2 * eps, bore_depth + 2 * eps]);
        }

    // Vertical grip grooves around the outside
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove from centre to outer edge, on the flat side
    // (aligned with -Y so it does not overlap the D-bore flat on +X)
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([knob_d / 2, pointer_w, pointer_d + eps]);
}