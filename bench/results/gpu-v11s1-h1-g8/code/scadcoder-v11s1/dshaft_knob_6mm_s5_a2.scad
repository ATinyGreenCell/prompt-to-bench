// Hotplate stirrer knob - D-shaft (6 mm)
// Print orientation: bottom face (with bore) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_d        = 6.2;   // D-bore diameter (circle diameter)
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = 4.7;   // D-bore flat side length
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_depth = 1;     // pointer groove depth
eps           = 0.5;   // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            polygon([
                [bore_d / 2, bore_d / 2],
                [-bore_flat, bore_d / 2],
                [bore_d / 2, -bore_d / 2]
            ]);

    // Vertical grip grooves around the outside
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2 - eps, 0, 0])
                cylinder(d = groove_d, h = knob_h, $fn = 64);

    // Pointer groove on top face, same side as the D-flat
    translate([0, -pointer_w / 2, knob_h - pointer_depth])
        cube([knob_d, pointer_w, pointer_depth + eps]);
}