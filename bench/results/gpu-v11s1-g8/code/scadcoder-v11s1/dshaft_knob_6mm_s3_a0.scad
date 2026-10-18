// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with D-bore) on the bed, z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_d        = 6.2;   // D-bore diameter (circle diameter)
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = 4.7;   // D-bore width: flat to opposite side of circle
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_depth = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Derived ----------------
bore_r = bore_d / 2;
// chord length of the D-bore (flat + opposite arc segment)
chord = bore_flat + (bore_d - bore_flat) * 0.5;   // = 4.7 + 2.35 = 7.05
// height of that chord above the bottom of the circle
chord_h = (bore_d - bore_flat) / 2;              // = 1.15
// D-bore centre offset from bottom face
bore_cz = knob_h - chord_h;                      // = 13.85

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, 0])
        difference() {
            cylinder(r = bore_r, h = bore_depth);
            // flat on +y side, extended past the bottom face
            translate([-(bore_r + eps), 0, -eps])
                cube([2 * (bore_r + eps), bore_flat + 2 * eps, bore_depth + eps]);
        }

    // Vertical grip grooves, evenly spaced, full height
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h);
    }

    // Pointer groove on top face, from centre to outer edge
    translate([-(pointer_w / 2), 0, knob_h - pointer_depth])
        cube([pointer_w, knob_d / 2 + pointer_w / 2, pointer_depth]);
}