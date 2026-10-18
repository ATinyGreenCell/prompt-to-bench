// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (with D-bore) on the bed at z = 0

$fn = 96;

// --- Knob dimensions ---
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height

// --- D-shaft bore ---
bore_d      = 6.2;   // bore diameter (circle)
bore_depth  = 12;    // blind bore depth from bottom face
bore_flat   = 4.7;   // distance from flat side to opposite side of circle

// --- Grip grooves ---
groove_d    = 2;     // groove diameter (half-cylinder)
groove_n    = 18;    // number of evenly spaced grooves
groove_h    = knob_h; // groove height (full height of knob)

// --- Pointer groove ---
pointer_w   = 1.5;   // groove width
pointer_d   = 1;     // groove depth
pointer_a   = 0;     // angle of groove (deg, 0 = along +X)

// --- Cutting overlap ---
eps         = 0.5;   // extension past faces to avoid coplanar surfaces

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, eps])
        linear_extrude(height = bore_depth)
            hull() {
                translate([bore_d / 2, 0, 0])
                    cylinder(d = bore_flat, $fn = 64);
                translate([-bore_d / 2, 0, 0])
                    cylinder(d = bore_flat, $fn = 64);
            }

    // Vertical grip grooves around the outside
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = groove_h, $fn = 64);

    // Pointer groove from centre to outer edge on top face
    translate([0, 0, knob_h - pointer_d])
        rotate([0, 0, pointer_a])
            cylinder(d = pointer_w, h = knob_h - pointer_d + eps, $fn = 64);
}