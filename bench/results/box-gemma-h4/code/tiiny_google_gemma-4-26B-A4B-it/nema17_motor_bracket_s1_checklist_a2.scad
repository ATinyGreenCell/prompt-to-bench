// L-shaped NEMA 17 Stepper Motor Mounting Bracket - Corrected Final
// Designed for a syringe pump application.

// --- Dimensions ---
// Base Plate
base_x_min = -25;
base_x_max = 25;
base_y_min = 0;
base_y_max = 45;
base_z_min = 0;
base_z_max = 5;

// Base Plate Holes (M4)
m4_hole_d = 4.5;
m4_hole_x1 = -17;
m4_hole_x2 = 17;
m4_hole_y = 30;

// Vertical Motor Plate
vert_x_min = -25;
vert_x_max = 25;
vert_y_min = 0;
vert_y_max = 5;
vert_z_min = 0;
vert_z_max = 50;

// Motor Boss Hole (Centering)
boss_d = 23;
boss_x = 0;
boss_z = 28;

// M3 Screw Holes (Motor Plate)
m3_hole_d = 3.4;
m3_pattern_size = 31;

// Gussets
gusset_thick = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;

$fn = 64;

// --- Main Assembly ---

difference() {
    union() {
        // 1. Base Plate
        translate([base_x_min, base_y_min, base_z_min])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_max]);
        
        // 2. Vertical Motor Plate
        // Standing on the back edge of the base (y=0 to 5)
        translate([vert_x_min, vert_y_min, 0])
            cube([vert_x_max - vert_x_min, vert_y_max - vert_y_min, vert_z_max]);
            
        // 3. Gussets
        // Left Gusset: x from -25 to -20, right angle at y=5, z=5
        // The gusset is in the YZ plane. 
        // We place it at the left edge (x=-25) and it extends to x=-20.
        translate([base_x_min, 5, 5])
            rotate([0, 90, 0])
            linear_extrude(height = gusset_thick)
            polygon(points = [[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
            
        // Right Gusset: x from 20 to 25, right angle at y=5, z=5
        translate([base_x_max - gusset_thick, 5, 5])
            rotate([0, 90, 0])
            linear_extrude(height = gusset_thick)
            polygon(points = [[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
    }

    // --- Negative Geometry (Cuts) ---
    
    // M4 Holes in Base Plate (Vertical through-holes)
    for (hx = [m4_hole_x1, m4_hole_x2]) {
        translate([hx, m4_hole_y, -1])
            cylinder(h = base_z_max + 2, d = m4_hole_d);
    }

    // Motor Boss Hole (Through the vertical plate along Y axis)
    // Center x=0, z=28, through the plate (y=0 to 5)
    translate([boss_x, -1, boss_z])
        rotate([0, 90, 0])
        cylinder(h = vert_y_max + 2, d = boss_d);

    // M3 Screw Holes in Vertical Plate (4 holes on 31mm square pattern)
    // Centered on the boss hole (0, 28)
    for (sx = [-1, 1], sz = [-1, 1]) {
        translate([sx * (m3_pattern_size / 2), -1, boss_z + sz * (m3_pattern_size / 2)])
            rotate([0, 90, 0])
            cylinder(h = vert_y_max + 2, d = m3_hole_d);
    }
}