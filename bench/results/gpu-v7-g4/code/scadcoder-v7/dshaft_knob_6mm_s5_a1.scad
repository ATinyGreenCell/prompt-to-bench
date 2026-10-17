// Replacement knob for hotplate stirrer - D-shaft
// Print orientation: D-flat side down on bed (z = 0)

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft diameter
bore_flat     = 4.7;   // distance from D-flat to opposite side of bore
bore_depth    = 12;    // blind bore depth from bottom face
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d    = 1;     // pointer groove depth

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---- Model ----
difference() {
    // Main cylinder
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore, centred on axis, flat on -x side
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = bore_depth + 2 * eps, $fn = 64);
    translate([-bore_flat, 0, -eps])
        cylinder(d = bore_flat, h = bore_depth + 2 * eps, $fn = 32);

    // Grip grooves: half-cylinders centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = i * 360 / groove_count;
        translate([knob_d / 2 * cos(a), knob_d / 2 * sin(a), 0])
            rotate([0, 90, 0])
                cylinder(d = groove_d, h = knob_h + 2 * eps);
    }

    // Pointer groove: radial slot from centre to edge, on flat side
    translate([-pointer_w / 2, 0, 0])
        linear_extrude(height = pointer_d)
            translate([-(knob_d / 2 + eps), 0, 0])
                cube([knob_d + 2 * eps, pointer_w, knob_h]);
}