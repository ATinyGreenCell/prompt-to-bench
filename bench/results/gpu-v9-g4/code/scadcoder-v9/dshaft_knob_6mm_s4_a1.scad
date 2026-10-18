// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: bottom face (shaft bore) on bed at z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft diameter
bore_depth    = 12;    // blind bore depth from bottom face
bore_flat     = 4.7;   // D-bore width (flat to opposite side of circle)
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// Derived
bore_r = shaft_d / 2;
// chord length of D-bore at depth = bore_flat
bore_chord = 2 * sqrt(bore_r * bore_r - (bore_flat / 2) ** 2);

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            circle(r = bore_r, $fn = 64);
    // cut out the chord (flat side of D)
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            polygon([[-bore_chord / 2, -bore_flat / 2],
                     [ bore_chord / 2, -bore_flat / 2]]);

    // Grip grooves around outside, full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on top face, centre to outer edge
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(d = pointer_w, $fn = 64);
    // extend radially to outer edge
    for (a = [0 : 360 : groove_count * 4])
        rotate([0, 0, a])
            translate([pointer_w / 2, 0, 0])
                cube([knob_d / 2 - pointer_w / 2, pointer_w, pointer_d + eps]);
}