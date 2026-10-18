// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------------- Parameters ----------------
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height
bore_depth  = 12;    // depth of the D-shaped blind bore from the bottom face
shaft_d     = 6;     // D-shaft diameter (circle diameter before the flat cut)
grooves     = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth
eps         = 0.5;   // overcut so cutting shapes pass beyond the faces they cut

$fn = 96;            // resolution for curved surfaces

// ---------------- Derived ----------------
// Distance from the bore flat to the opposite side of the circle.
// With the flat on -X this spans from x = -shaft_d/2 to x = +shaft_d/2,
// so the distance is shaft_d. The spec says 4.7 mm, which does not match.
bore_flat_to_opposite = 4.7;

// ---------------- Model ----------------
difference() {
    // Main body of the knob
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face, extended past the top face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            circle(d = shaft_d);

    // Cut the flat on the -X side of the bore
    translate([-(bore_flat_to_opposite + eps) / 2, 0, -eps])
        rotate([0, 90, 0])
            linear_extrude(height = bore_depth + 2 * eps)
                width(bore_flat_to_opposite + 2 * eps);

    // 18 evenly spaced vertical grip grooves along the full height
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove on the top face, on the same side as the bore flat
    translate([-(pointer_w / 2 + eps) / 2, 0, knob_h - pointer_d])
        rotate([0, 90, 0])
            linear_extrude(height = pointer_w + 2 * eps)
                width(pointer_d + 2 * eps);
}