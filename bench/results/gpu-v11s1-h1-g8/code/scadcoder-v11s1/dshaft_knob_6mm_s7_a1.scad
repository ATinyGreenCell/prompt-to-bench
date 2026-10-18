// Hotplate stirrer knob - D-shaft adapter
// Print orientation: flat bottom on bed (z = 0), curved top up (+Z)

$fn = 96;

// ---- Dimensions (mm) ----
shaft_d        = 6;     // D-shaft diameter
knob_d         = 30;    // knob outer diameter
knob_h         = 15;    // knob height
bore_depth     = 12;    // blind bore depth from bottom face
bore_flat_w    = 4.7;   // D-bore flat width (across the flat side)
groove_count   = 18;    // vertical grip grooves, evenly spaced
groove_d       = 2;     // groove diameter (half-cylinder)
pointer_w      = 1.5;   // pointer groove width
pointer_d      = 1;     // pointer groove depth
eps            = 0.5;   // overshoot for clean boolean cuts

// ---- Derived ----
bore_r = bore_flat_w / 2 + (bore_d = shaft_d + 2 * eps) / 2;   // D-bore circumradius (approx)

difference() {
    // Knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + eps)
            circle(r = bore_r, $fn = 96);   // D-circle, centred on shaft line

    // Vertical grip grooves along full height
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps);

    // Pointer groove: top face, radial, centre -> outer edge
    translate([0, 0, knob_h - pointer_d])
        cube([knob_d / 2 + eps, knob_d / 2, pointer_d + eps]);
}