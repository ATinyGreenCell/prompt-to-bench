// L-shaped NEMA 17 Stepper Motor Mounting Bracket
// Designed for a syringe pump application.

// --- Dimensions ---
// Base Plate
base_x_min    = -25;
base_x_max    = 25;
base_y_min    = 0;
base_y_max    = 45;
base_z_min    = 0;
base_z_max    = 5;

// Base Plate Holes (M4)
m4_hole_d     = 4.5;
m4_hole_x1    = -17;
m4_hole_y1    = 30;
m4_hole_x2    = 17;
m4_hole_y2    = 30;

// Vertical Motor Plate
vert_x_min    = -25;
vert_x_max    = 25;
vert_y_min    = 0;
vert_y_max    = 5;
vert_z_min    = 5; // Sits on top of base plate
vert_z_max    = 55; // Total height 50 + base 5

// Motor Boss Hole (Centering)
boss_d        = 23;
boss_x        = 0;
boss_z        = 28;
boss_y_len    = 50; // Length of cut through the plate

// M3 Screw Holes (Pattern)
m3_hole_d     = 3.4;
m3_pattern_s  = 31; // Square pattern spacing

// Gussets
gusset_thick   = 5;
gusset_leg_y   = 20;
gusset_leg_z   = 20;

$fn = 64;

// --- Helper Modules ---

module gusset() {
    // Right triangle in YZ plane, extruded along X
    // Corner at y=5, z=5 (relative to global origin)
    // Note: The user specified the corner at y=5, z=5. 
    // Since the base is 5mm thick, the vertical plate starts at z=5.
    // The gusset is flush with the edges.
    rotate([0, -90, 0])
    linear_extrude(height = gusset_thick)
    polygon(points=[[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
}

// --- Main Assembly ---

difference() {
    // --- Positive Geometry ---
    union() {
        // Base Plate
        translate([0, 0, 0])
        cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_max]);

        // Vertical Motor Plate
        translate([0, 0, base_z_max])
        cube([vert_x_max - vert_x_min, vert_y_max - vert_y_min, vert_z_max - base_z_max]);

        // Gusset Left
        translate([base_x_min, base_y_max - gusset_leg_y, base_z_max])
        rotate([0, 0, 0]) // Orientation handled in module
        gusset();

        // Gusset Right
        translate([vert_x_max - gusset_thick, base_y_max - gusset_leg_y, base_z_max])
        gusset();
    }

    // --- Negative Geometry (Cuts) ---

    // M4 Holes in Base Plate
    translate([m4_hole_x1, m4_hole_y1, -1]) 
        cylinder(h = base_z_max + 2, d = m4_hole_d);
    translate([m4_hole_x2, m4_hole_y2, -1]) 
        cylinder(h = base_z_max + 2, d = m4_hole_d);

    // Motor Boss Hole (through the vertical plate along Y)
    // The plate is at Y = 0 to 5. The hole is 23mm diameter.
    // The user says "cut a 23mm hole... along Y". 
    // Since the plate is only 5mm wide in Y, we cut through the thickness.
    translate([boss_x, -1, boss_z])
        rotate([0, 90, 0])
        cylinder(h = vert_y_max + 2, d = boss_d);

    // M3 Screw Holes (4 holes in a 31mm square pattern)
    // Centered on the boss hole (0, 28)
    for (sx = [-1, 1], sz = [-1, 1]) {
        translate([sx * (m3_pattern_s / 2), 2.5, boss_z + sz * (m3_pattern_s / 2)])
            rotate([0, 90, 0])
            cylinder(h = vert_y_max + 2, d = m3_hole_d);
    }
}