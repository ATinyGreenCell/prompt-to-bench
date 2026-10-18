// Replacement knob for hotplate stirrer with a 6 mm D-shaft
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // D-bore depth from bottom face
shaft_d       = 6.2;   // D-shaft diameter (circle with one flat side)
bore_flat     = 4.7;   // distance from flat to opposite side of D-circle
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean differences

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = bore_depth + 2 * eps, $fn = 64);

    // Vertical grip grooves around full height, centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = (i / (groove_count - 1)) * 360;
        translate([knob_d / 2, 0, -eps])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h + 2 * eps);
    }

    // Pointer groove on top face, same side as D-flat (along +X)
    translate([-eps, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_w, center = true)
            translate([0, 0, -eps])
                cylinder(d = pointer_d * 2, h = knob_h + 2 * eps);
}