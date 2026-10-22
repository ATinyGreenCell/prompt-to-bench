// L-shaped (hockey-stick) cell spreader for bacterial plating.
// Corrected to ensure the foot starts at the origin and handle is in the correct X range.

// --- Dimensions ---
handle_l    = 150.0; // Length of the handle
handle_w    = 6.0;   // Width of the handle
handle_t    = 4.0;   // Thickness of the handle
foot_l      = 40.0;  // Length of the spreading foot
foot_w      = 5.0;   // Width of the spreading foot
foot_t      = 2.5;   // Thickness of the spreading foot
boss_d      = 6.0;   // Diameter of the joining boss
boss_h      = 4.0;   // Height of the joining boss
hole_d      = 4.0;   // Diameter of the hanging hole
angle_deg   = 120.0; // Angle between handle and foot (counter-clockwise from +X)

$fn = 64;

module spreader() {
    difference() {
        union() {
            // 1. The Handle
            // Specification: x = 0 to 150, y = -3 to 3, z = 0 to 4
            // We use translate to place the corner at [0, -3, 0]
            translate([0, -handle_w/2, 0])
                cube([handle_l, handle_w, handle_t]);

            // 2. The Spreading Foot
            // Specification: 40mm long, 5mm wide, 2.5mm thick.
            // Center line starts at origin and points 120 deg CCW from +X.
            // To make the start at origin, we translate the cube by [foot_l/2, 0, 0]
            // then rotate around the origin.
            rotate([0, 0, angle_deg])
            translate([0, -foot_w/2, 0])
                cube([foot_l, foot_w, foot_t]);

            // 3. The Boss
            // Specification: 6mm diameter, 4mm tall at the origin.
            // We place it at the origin. Since the handle is at z=0 to 4,
            // and the foot is at z=0 to 2.5, the boss sits at the base.
            translate([0, 0, 0])
                cylinder(d = boss_d, h = boss_h);
        }

        // 4. The Hanging Hole
        // Specification: 4mm diameter through the handle at x = 143, y = 0.
        // We use a small offset to ensure it cuts through the handle faces.
        translate([143, 0, -1])
            cylinder(d = hole_d, h = handle_t + 2);
    }
}

// Render the part
spreader();