// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: D-bore flat face down on bed (z = 0)

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_d        = 6.2;   // D-bore circle diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = 4.7;   // distance from D-bore flat to opposite side
groove_d      = 2;     // grip groove diameter
groove_count  = 18;    // number of grip grooves
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + 2 * eps, $fn = 64);
    // Cut the flat side of the D (through, stopping at bore_depth)
    translate([-(bore_flat - 0.5 * bore_d) / 2, 0, -eps])
        cube([(bore_flat - 0.5 * bore_d) / 2 + 0.01, bore_d, bore_depth + eps]);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 64);
    }

    // Pointer groove from centre to outer edge, same side as D-flat
    translate([-(bore_flat - 0.5 * bore_d) / 2, 0, 0])
        linear_extrude(height = knob_h - 2 * pointer_d)
            polygon([
                [-1 * (bore_flat - 0.5 * bore_d) / 2 - 0.01, -pointer_w / 2],
                [-1 * (bore_flat - 0.5 * bore_d) / 2 - 0.01, pointer_w / 2],
                [knob_d / 2, pointer_w / 2],
                [knob_d / 2, -pointer_w / 2]
            ]);
}