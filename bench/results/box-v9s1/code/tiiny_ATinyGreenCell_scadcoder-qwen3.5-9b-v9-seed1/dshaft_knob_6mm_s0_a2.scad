// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: the side that faces the hotplate is down on the bed (z = 0)

// ---------------- Parameters ----------------
knob_d      = 30;    // knob diameter (mm)
knob_h      = 15;    // knob height (mm)

bore_d      = 6.2;   // D-bore circle diameter (mm)
bore_depth  = 12;    // D-bore depth from bottom face (mm)
bore_flat   = 4.7;   // distance from the flat side to the opposite side of the circle (mm)

groove_d    = 2;     // grip groove diameter (mm)
groove_n    = 18;    // number of grip grooves
groove_h    = 1;     // grip groove depth (mm), full-height half-cylinder

pointer_w   = 1.5;   // pointer groove width (mm)
pointer_d   = 1;     // pointer groove depth (mm)

eps         = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 96;            // circle resolution

// ---------------- Derived ----------------
half_flat = bore_flat / 2;   // offset of the flat from the circle centre

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + 2 * eps, $fn = 64);
    // Cut the flat side of the D through the bottom face
    translate([0, 0, -eps])
        cylinder(d = 2 * half_flat, h = bore_depth + 2 * eps);

    // 18 evenly spaced vertical grip grooves along the full height
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, 0])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on the top face, on the same side as the D-flat
    translate([0, 0, knob_h - pointer_d])
        rotate([90, 0, 0])
            linear_extrude(height = pointer_w)
                circle(d = knob_d, $fn = 96);
}