// Replacement knob for a hotplate stirrer with a 6 mm D-shaft.
// Designed for FDM printing, resting on the bottom face (z=0).

// --- Dimensions ---
knob_dia    = 30.0;    // Diameter of the knob
knob_height = 15.0;    // Total height of the knob
d_shaft_dia = 6.2;     // Diameter of the D-shaft hole
d_shaft_flat_dist = 4.7; // Distance from flat to opposite side of D-shaft
bore_depth   = 12.0;   // Depth of the D-shaped blind bore
num_grooves  = 18;     // Number of vertical grip grooves
groove_dia   = 2.0;    // Diameter of the grip grooves
pointer_w    = 1.5;    // Width of the pointer groove
pointer_d    = 1.0;    // Depth of the pointer groove

$fn = 64;

// --- Calculations ---
// The distance from the center to the flat side of the D-shaft.
chord_dist = d_shaft_flat_dist / 2;

// --- Modules ---

module d_shaft_profile() {
    // Creates a 2D D-shape profile centered on the origin.
    difference() {
        circle(d = d_shaft_dia);
        // Subtract a rectangle that is offset so its edge is at chord_dist.
        // To make the flat side at X = chord_dist, we move the rectangle.
        // The rectangle must be wide enough to cover the circle's width.
        translate([chord_dist, 0])
            square([d_shaft_dia, d_shaft_dia], center = true);
    }
}

// --- Final Assembly ---

difference() {
    // 1. The Main Knob Body
    cylinder(h = knob_height, d = knob_dia);

    // 2. The D-shaped blind bore
    // Extrude the 2D D-shape profile vertically.
    translate([0, 0, -0.01])
    linear_extrude(height = bore_depth + 0.01)
    d_shaft_profile();

    // 3. Vertical Grip Grooves
    // 18 evenly spaced vertical grooves.
    // Each is a 2mm diameter cylinder centered on the outer surface.
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle])
        translate([knob_dia / 2, 0, 0])
        // Use a cylinder that is tall enough to cut through the whole knob.
        // We rotate it 90 degrees on Y to make it vertical.
        rotate([0, 90, 0])
        cylinder(h = knob_dia, d = groove_dia, center = true);
    }

    // 4. Pointer Groove
    // On the top face, 1.5mm wide, 1mm deep, from center to edge.
    // Located on the same side as the D-shaft flat (positive X).
    translate([0, -pointer_w / 2, knob_height - pointer_d])
    cube([knob_dia / 2 + 1, pointer_w, pointer_d + 0.01]);
}