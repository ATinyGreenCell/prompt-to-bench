// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: flat side of D facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_len      = 12;    // blind bore depth from bottom face
bore_flat     = 6.2;   // bore circle diameter
bore_straight = 4.7;   // distance from flat to opposite side of bore
groove_n      = 18;    // number of grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Derived ----------------
bore_r = bore_d = bore_flat + bore_straight; // 6.2 + 4.7 = 10.9
first_angle = -180 / groove_n;               // start groove so first lies on X+

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_len + 2 * eps, $fn = 64);
    translate([-(bore_r - bore_straight) / 2, 0, -bore_len - eps])
        cube([bore_straight, 2 * bore_r, bore_len + 2 * eps]);

    // Vertical grip grooves along full height
    for (i = [0 : groove_n - 1]) {
        rotate([0, 0, i * 360 / groove_n + first_angle])
            translate([knob_d / 2, 0, -eps / 2])
                cylinder(d = groove_d, h = knob_h + eps, $fn = 64);
    }

    // Pointer groove on top face, same side as flat of D
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d)
            circle(d = pointer_w, $fn = 64);
}