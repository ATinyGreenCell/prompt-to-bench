// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (facing the hotplate) on the bed at z = 0

// ---------- Dimensions (mm) ----------
knob_d      = 30;    // knob outer diameter
knob_h      = 15;    // knob height
bore_depth  = 12;    // depth of D-bore from bottom face
bore_flat   = 4.7;   // distance from flat to opposite side of D-bore
bore_r      = 6.2 / 2; // radius of D-bore circle (6.2 mm diameter)
groove_n    = 18;    // number of vertical grip grooves
groove_d    = 2;     // grip groove diameter
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth

eps         = 0.5;   // overshoot for clean boolean cuts

// ---------- Derived ----------
bore_chord  = sqrt(bore_r * bore_r - (bore_flat / 2) * (bore_flat / 2)); // half-width of flat cut

// ---------- Model ----------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h, $fn = 96);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        union() {
            cylinder(r = bore_r, h = bore_depth + eps, $fn = 96);
            translate([-bore_chord, 0, -eps])
                cube([bore_flat, bore_depth + eps, 2 * bore_chord]);
        }

    // 18 evenly spaced vertical grip grooves, full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove on top face, same side as D-bore flat
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d)
            circle(r = pointer_w / 2, $fn = 96);
}