// L-shaped (hockey-stick) cell spreader, printed lying flat on XY plane
$fn = 64;

// Handle
handle_len   = 150;  // handle length along +X (mm)
handle_w     = 6;    // handle width in Y (mm)
handle_t     = 4;    // handle thickness in Z (mm)

// Spreading foot
foot_len     = 40;   // foot length along its centre line (mm)
foot_w       = 5;    // foot width (mm)
foot_t       = 2.5;  // foot thickness in Z (mm), bed side spreads agar
foot_angle   = 120;  // foot direction, degrees CCW from +X (mm/deg)

// Joint boss
boss_d       = 6;    // boss diameter (mm)
boss_h       = 4;    // boss height (mm)

// Hanging hole
hole_d       = 4;    // hanging hole diameter (mm)
hole_x       = 143;  // hanging hole centre X (mm)
hole_y       = 0;    // hanging hole centre Y (mm)

eps          = 0.5;  // cutter overshoot (mm)

difference() {
    union() {
        // Handle bar: x 0..150, y -3..3, z 0..4
        translate([0, -handle_w/2, 0])
            cube([handle_len, handle_w, handle_t]);

        // Spreading foot: starts at origin, points 120 deg CCW from +X
        rotate([0, 0, foot_angle])
            translate([0, -foot_w/2, 0])
                cube([foot_len, foot_w, foot_t]);

        // Round joining boss at origin
        cylinder(d = boss_d, h = boss_h);
    }

    // Hanging hole through handle
    translate([hole_x, hole_y, -eps])
        cylinder(d = hole_d, h = handle_t + 2*eps);
}