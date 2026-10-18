// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------- Dimensions (mm) ----------
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height
bore_depth  = 12;    // depth of the D-shaped blind bore from the bottom face
bore_w      = 4.7;   // width of the D bore: flat to opposite side of the circle
bore_r      = 6.2 / 2; // radius of the D bore circle (6.2 mm diameter)
groove_n    = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter (half-cylinder)
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth
eps         = 0.5;   // overcut so cutting shapes pass beyond the faces they cut

$fn = 96;            // curve resolution

// ---------- Derived ----------
groove_pitch = 360 / groove_n;   // angular spacing of the grip grooves

// ---------- Model ----------
difference() {
    // Main body: cylinder, centred in XY, sitting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face, extended past the top face
    // so the bore is truly blind and does not exit the knob.
    translate([0, 0, eps])
        linear_extrude(height = bore_depth + eps)
            polygon([[-bore_r, 0], [bore_w / 2, 0], [-bore_w / 2, 0]]);

    // 18 evenly spaced vertical grip grooves along the full height,
    // each a half-cylinder centred on the outer surface.
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * groove_pitch])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h);

    // Pointer groove on the top face, from the centre to the outer edge,
    // on the same side as the flat of the D bore.
    translate([-(bore_r + 1), 0, knob_h - pointer_d])
        cube([(bore_r + 1) * 2, knob_d / 2, pointer_d + eps]);
}