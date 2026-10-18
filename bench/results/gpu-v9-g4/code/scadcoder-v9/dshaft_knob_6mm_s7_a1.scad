// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: bottom face (shaft bore) on bed at z = 0

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_depth    = 12;    // blind bore depth from bottom face
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        cylinder(h = bore_depth + eps, $fn = 64);

    // D-flat cutter: circle with one side cut flat (distance flat-opposite = 4.7)
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            circle(d = shaft_d, $fn = 64);

    // Grip grooves: 18 evenly spaced vertical half-cylinders on outer surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 32);

    // Pointer groove: radial slot from centre to outer edge on top face
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d + eps)
            circle(d = pointer_w, $fn = 64);
}