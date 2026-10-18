// Replacement knob for hotplate stirrer with D-shaft
// Print orientation: flat bottom face on bed (z = 0), builds upward.

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // D-bore depth from bottom face
bore_w        = 4.7;   // D-bore width (flat to opposite side of circle)
bore_d        = 6.2;   // D-bore circle diameter
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // grip groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth

// ---- Derived ----
eps = 0.5;             // overcut for clean differences
flat_x = -bore_d/2;    // x position of D-bore flat

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, eps])
        cylinder(d = bore_d, h = bore_depth + eps, $fn = 96);
    translate([flat_x, 0, eps])
        cube([bore_w - bore_d, knob_d/2, bore_depth + eps]);

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d/2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2*eps, $fn = 64);

    // Pointer groove from centre to outer edge, same side as flat
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d)
            circle(d = pointer_w, $fn = 96);
}