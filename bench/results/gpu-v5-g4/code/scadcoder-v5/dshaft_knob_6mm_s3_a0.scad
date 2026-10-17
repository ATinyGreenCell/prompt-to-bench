// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: bottom face (with D-bore) on the bed (z = 0)

// ---------------- Parameters ----------------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
shaft_d         = 6;     // D-shaft diameter
bore_depth      = 12;    // blind bore depth from bottom face
bore_d          = 6.2;   // bore circle diameter
bore_flat       = 4.7;   // distance from flat to opposite side of bore
groove_count    = 18;    // number of grip grooves
groove_d        = 2;     // groove diameter (half-cylinder)
pointer_w       = 1.5;   // pointer groove width
pointer_d       = 1;     // pointer groove depth
eps             = 0.5;   // overcut for clean differences
$fn             = 96;    // curve resolution

// Derived
bore_r          = bore_d / 2;
flat_x          = bore_flat / 2;   // flat centre offset (X+)
outer_r         = knob_d / 2;

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = bore_depth + 2 * eps, $fn = 64);

    // Flat on one side of the bore
    translate([flat_x, 0, -eps])
        cube([eps, bore_depth + 2 * eps, 2 * bore_r + 0.01]);

    // Vertical grip grooves around the full height
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([outer_r * cos(a), outer_r * sin(a), -eps])
            cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);
    }

    // Pointer groove on top face, same side as the bore flat
    translate([-pointer_w / 2, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            polygon([[-pointer_w / 2, 0], [pointer_w / 2, 0],
                     [pointer_w / 2, pointer_d], [-pointer_w / 2, pointer_d]]);
}