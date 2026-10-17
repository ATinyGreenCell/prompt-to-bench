// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Print orientation: side facing hotplate down on bed (z = 0)

$fn = 96;

// ---- Knob body ----
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height

// ---- D-shaped blind bore ----
bore_d      = 6.2;   // bore circle diameter
bore_flat   = 4.7;   // distance from flat to opposite side of circle
bore_depth  = 12;    // bore depth from bottom face

// ---- Grip grooves ----
groove_n    = 18;    // number of grooves
groove_d    = 2;     // groove (half-cylinder) diameter, centred on outer surface

// ---- Pointer groove ----
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth

// ---- Misc ----
eps         = 0.5;   // overcut for clean boolean differences

// Derived
bore_r      = bore_d / 2;
flat_x      = bore_flat - bore_r;   // flat position from bore centre (1.8 mm)

module d_bore_2d() {
    intersection() {
        circle(d = bore_d);
        // keep everything from the far side of the circle up to the flat
        translate([-bore_r - eps, -bore_r - eps])
            square([flat_x + bore_r + eps, bore_d + 2 * eps]);
    }
}

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            d_bore_2d();

    // Vertical grip grooves along full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 48);

    // Pointer groove on top face, from centre to outer edge
    translate([0, 0, knob_h - eps])
        intersection() {
            cylinder(d = knob_d + 2 * eps, h = eps + 0.01);
            translate([-pointer_w / 2, -knob_d / 2 - eps])
                square([pointer_w, knob_d + 2 * eps]);
        }
}