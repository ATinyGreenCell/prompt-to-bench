// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: D-flat side facing hotplate down on bed (z = 0)

// ---------- Parameters ----------
knob_d          = 30;    // knob outer diameter
knob_h          = 15;    // knob height
shaft_d         = 6.2;   // D-shaft diameter
bore_depth      = 12;    // blind bore depth from bottom face
bore_flat       = 4.7;   // D-bore flat-to-flat distance (across circle)
groove_count    = 18;    // number of grip grooves
groove_d        = 2;     // grip groove diameter (half-cylinder)
pointer_w       = 1.5;   // pointer groove width
pointer_depth   = 1;     // pointer groove depth

eps             = 0.5;   // cutter overshoot past faces
$fn             = 96;    // curve resolution

// ---------- Derived ----------
// D-bore radius from flat-to-flat distance
bore_r = bore_flat / 2 + eps;

// ---------- Model ----------
difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore, centred on axis, flat on +x side
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = bore_depth + 2 * eps, $fn = 64);
    translate([bore_r, 0, -eps])
        cube([bore_r, 2 * bore_r, bore_depth + 2 * eps]);

    // Grip grooves: vertical half-cylinders centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d / 2 * cos(a), knob_d / 2 * sin(a), 0])
            rotate([0, 90, 0])
                cylinder(d = groove_d, h = knob_h + 2 * eps);
    }

    // Pointer groove: radial slot from centre to edge, on +x side
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            translate([-pointer_depth, 0, 0])
                circle(d = pointer_w);
}