// Replacement knob for hotplate stirrer (D-shaft 6 mm)
// Print orientation: bottom face (with bore) on bed at z = 0

$fn = 96;

// --- Knob body ---
knob_d      = 30;   // outer diameter
knob_h      = 15;   // height

// --- D-bore (blind, from bottom face) ---
bore_d      = 6.2;  // circle diameter
bore_flat   = 4.7;  // distance from flat to opposite side
bore_depth  = 12;   // depth from bottom face

// --- Grip grooves ---
groove_n    = 18;   // number of grooves
groove_d    = 2;    // groove diameter (half-cylinder)

// --- Pointer groove ---
pointer_w   = 1.5;  // groove width
pointer_d   = 1;    // groove depth

// --- Cutting overlap ---
eps         = 0.5;  // extension past cut faces

difference() {
    // Main body, centred in X/Y, resting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped bore: circle with one side cut flat
    translate([0, 0, -eps])
        union() {
            cylinder(d = bore_d, h = bore_depth + 2 * eps);
            translate([-bore_flat / 2, -bore_d / 2, 0])
                cube([bore_flat, bore_d, bore_depth + eps]);
        }

    // Vertical grip grooves along full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove from centre to outer edge
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            polygon([[-pointer_w / 2, knob_d / 2],
                     [ pointer_w / 2, knob_d / 2],
                     [ pointer_w / 2, -knob_d / 2],
                     [-pointer_w / 2, -knob_d / 2]]);
}