// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: flat bottom face on the bed (z = 0), building up in +Z.
// Placed with the D-flat along +X, so the pointer groove ends up on the -Y side.

$fn = 96;

// ---- Knob body ----
knob_d      = 30;    // outer diameter of the knob
knob_h      = 15;    // overall height of the knob

// ---- D-shaped blind bore (from bottom face, 12 mm deep) ----
bore_d      = 6.2;   // diameter of the circle that makes up the D
bore_depth  = 12;    // depth of the bore from the bottom face
bore_flat   = 4.7;   // distance from the flat side to the opposite side of the circle
eps         = 0.5;   // overshoot so the cut passes cleanly through the bottom face

// ---- Grip grooves ----
groove_n     = 18;   // number of evenly spaced vertical grip grooves
groove_d     = 2;    // diameter of each groove (half-cylinder, centred on the surface)

// ---- Pointer groove ----
pointer_w    = 1.5;  // width of the pointer groove (at the centre)
pointer_d    = 1;    // depth of the pointer groove
pointer_r    = pointer_w / 2;  // radius of the groove circle

// ---- Derived ----
bore_r = bore_d / 2;
// chord length of the flat cut, from circle geometry
bore_chord = sqrt(bore_r * bore_r - (bore_flat / 2) * (bore_flat / 2));

difference() {
    // Main knob body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from the bottom face
    translate([0, 0, -eps])
        union() {
            // circular part of the D
            translate([0, bore_chord, 0])
                cylinder(r = bore_r, h = bore_depth + eps);
            // flat slab between the chord and the cut edge
            translate([-bore_flat / 2, bore_chord, 0])
                cube([bore_flat, bore_chord, bore_depth + eps]);
        }

    // Vertical grip grooves, evenly spaced around the outside
    for (i = [0 : groove_n - 1])
        rotate([0, 0, i * 360 / groove_n])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove: a 2D circle in the X-Y plane, extruded up from the top face
    translate([0, 0, knob_h - pointer_d])
        linear_extrude(height = pointer_d)
            circle(r = pointer_r);
}