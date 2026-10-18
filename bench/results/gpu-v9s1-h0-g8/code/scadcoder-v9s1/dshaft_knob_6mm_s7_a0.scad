// Replacement knob for a hotplate stirrer with a D-shaft
// Print orientation: bottom face (with D-bore) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft diameter (bore diameter)
bore_depth    = 12;    // blind bore depth from bottom face
bore_flat     = 4.7;   // distance from D-bore flat to opposite side of circle
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // grip groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // overcut so cutting faces are not coplanar

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main body, centred on origin in XY, sitting on z = 0
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(d = shaft_d, h = bore_depth + 2 * eps, $fn = 64);
    // cut the flat side of the D, leaving the specified distance to the arc
    translate([-(bore_flat - shaft_d) / 2, 0, -eps])
        cube([bore_flat, knob_d + 2 * eps, bore_depth + 2 * eps]);

    // Vertical grip grooves around the full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on top face, from centre to outer edge
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_w, center = true)
            polygon([[-pointer_w / 2, -knob_d / 2],
                     [ pointer_w / 2, -knob_d / 2],
                     [0, knob_d / 2]]);
}