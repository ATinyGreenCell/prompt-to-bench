// L-shaped NEMA 17 Stepper Motor Mounting Bracket - FINAL CORRECTED
// Designed for a syringe pump application.

// --- Dimensions ---
// Base Plate
base_x_size    = 50; // -25 to 25
base_y_size    = 45; // 0 to 45
base_z_size    = 5;  // 0 to 5

// Base Plate Holes (M4)
m4_hole_d     = 4.5;
m4_hole_x1    = -17;
m4_hole_y1    = 30;
m4_hole_x2    = 17;
m4_hole_y2    = 30;

// Vertical Motor Plate
vert_x_size    = 50; // -25 to 25
vert_y_size    = 5;  // 0 to 5
vert_z_size    = 50; // 5 to 55

// Motor Boss Hole (Centering)
boss_d        = 23;
boss_x        = 0;
boss_z        = 28;

// M3 Screw Holes (Pattern)
m3_hole_d     = 3.4;
m3_pattern_s  = 31; 

// Gussets
gusset_thick   = 5;
gusset_leg_y   = 20;
gusset_leg_z   = 20;

$fn = 64;

// --- Helper Modules ---

module gusset_shape() {
    // Right triangle in YZ plane
    polygon(points=[[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
}

// --- Main Assembly ---

difference() {
    union() {
        // Base Plate
        // Centered on X, Y starts at 0, Z starts at 0
        translate([0, base_y_size/2, base_z_size/2])
            cube([base_x_size, base_y_size, base_z_size], center = true);

        // Vertical Motor Plate
        // Centered on X, Y starts at 0, Z starts at 5
        translate([0, vert_y_size/2, (vert_z_size/2) + 5])
            cube([vert_x_size, vert_y_size, vert_z_size], center = true);

        // Gusset Left (Flush with X = -25)
        translate([-base_x_size/2 + gusset_thick/2, base_y_size - gusset_leg_y, 5])
            rotate([0, -90, 0])
            linear_extrude(height = gusset_thick)
            gusset_shape();

        // Gusset Right (Flush with X = 25)
        translate([base_x_size/2 - gusset_thick/2, base_y_size - gusset_leg_y, 5])
            rotate([0, -90, 0])
            linear_extrude(height = gusset_thick)
            gusset_shape();
    }

    // --- Negative Geometry (Cuts) ---

    // M4 Holes in Base Plate
    translate([m4_hole_x1, m4_hole_y1, -1]) 
        cylinder(h = base_z_size + 2, d = m4_hole_d);
    translate([m4_hole_x2, m4_hole_y2, -1]) 
        cylinder(h = base_z_size + 2, d = m4_hole_d);

    // Motor Boss Hole (through the vertical plate along Y)
    translate([boss_x, -1, boss_z])
        rotate([0, 90, 0])
        cylinder(h = vert_y_size + 2, d = boss_d);

    // M3 Screw Holes (4 holes in a 31mm square pattern)
    // Pattern is in X and Z plane.
    for (sx = [-1, 1], sz = [-1, 1]) {
        translate([sx * (m3_pattern_s / 2), -1, boss_z + sz * (m3_pattern_s / 2)])
            rotate([0, 90, 0])
            cylinder(h = vert_y_size + 2, d = m3_hole_d);
    }
}