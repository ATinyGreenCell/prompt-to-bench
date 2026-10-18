// Hotplate stirrer knob for a 6 mm D-shaft
// Print orientation: bottom face (with D-bore) on the bed at z = 0

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_d        = 6.2;   // D-bore circle diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = (bore_d - 4.7) / 2;  // offset of flat from circle centre (1.95)
groove_d      = 2;     // grip groove diameter
groove_count  = 18;    // number of grip grooves
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overshoot for clean cuts

// ---- Model ----
difference() {
    // Main cylinder
    translate([0, 0, 0])
        cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore
    translate([0, 0, -eps])
        intersection() {
            cylinder(d = bore_d, h = bore_depth + eps);
            translate([-bore_flat, 0, -eps])
                cube([bore_flat + 0.01, bore_d + 2 * bore_flat, bore_depth + eps]);
        };

    // Vertical grip grooves around the outside
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 6);
    }

    // Pointer groove from centre to outer edge
    translate([0, 0, -eps])
        intersection() {
            translate([0, -pointer_w / 2, -eps])
                cube([knob_d / 2 + eps, pointer_w, knob_h + 2 * eps]);
            cylinder(d = knob_d, h = pointer_d + eps);
        };
}