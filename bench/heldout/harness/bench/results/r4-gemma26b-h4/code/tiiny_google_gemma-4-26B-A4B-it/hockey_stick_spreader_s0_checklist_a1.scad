// L-shaped (hockey-stick) cell spreader for bacterial plating.
// Corrected to match exact coordinate specifications.

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
            // We translate by [handle_l/2, 0, handle_t/2] to center it on Y and Z, 
            // and place the start at X=0.
            translate([handle_l / 2, 0, handle_t / 2])
                cube([handle_l, handle_w, handle_t], center = true);

            // 2. The Spreading Foot
            // Specification: 40mm long, 5mm wide, 2.5mm thick.
            // Center line starts at origin and points 120 deg CCW from +X.
            // We create the foot such that its end is at the origin, then rotate.
            // To make the "smooth bed side" (the bottom) at Z=0, we translate by foot_t/2.
            rotate([0, 0, angle_deg])
            translate([foot_l / 2, 0, foot_t / 2])
                cube([foot_l, foot_w, foot_t], center = true);

            // 3. The Boss
            // Specification: 6mm diameter, 4mm tall at the origin.
            // To ensure it sits on the bed, we place it from Z=0 to Z=4.
            translate([0, 0, boss_h / 2])
                cylinder(d = boss_d, h = boss_h, center = true);
        }

        // 4. The Hanging Hole
        // Specification: 4mm diameter through the handle at x = 143, y = 0.
        // We extend the cylinder in Z to ensure a clean cut.
        translate([143, 0, -1])
            cylinder(d = hole_d, h = handle_t + 2, center = true);
    }
}

// Render the part
spreader();