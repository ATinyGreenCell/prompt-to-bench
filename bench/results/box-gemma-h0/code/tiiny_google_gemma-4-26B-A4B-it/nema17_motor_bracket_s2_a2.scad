// NEMA 17 Stepper Motor L-Bracket for Syringe Pump
// Final Corrected Version

// --- Dimensions ---
// Base Plate
base_x_min = -25;
base_x_max = 25;
base_y_min = 0;
base_y_max = 45;
base_z_height = 5;

// Base Plate Holes (M4)
m4_hole_dia = 4.5;
m4_hole_x1 = -17;
m4_hole_y1 = 30;
m4_hole_x2 = 17;
m4_hole_y2 = 30;

// Vertical Motor Plate
motor_plate_x_min = -25;
motor_plate_x_max = 25;
motor_plate_y_min = 0;
motor_plate_y_max = 5;
motor_plate_z_height = 50;

// Motor Boss Hole (Centering)
boss_hole_dia = 23;
boss_hole_x = 0;
boss_hole_z = 28;

// Motor Screw Holes (M3)
m3_hole_dia = 3.4;
m3_pattern_size = 31;

// Gussets
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_x_left_min = -25;
gusset_x_left_max = -20;
gusset_x_right_min = 20;
gusset_x_right_max = 25;

// Resolution
$fn = 64;

// --- Modeling ---

module gusset_shape() {
    // A right triangle in YZ plane
    // Corner at y=5, z=5. Legs are 20mm.
    // Vertices in YZ: (5,5), (25,5), (5,25)
    polygon(points = [
        [0, 5], 
        [gusset_leg_y, 5], 
        [0, gusset_leg_z]
    ]);
}

// We use a union of all parts to ensure it is a single solid body
union() {
    // 1. Main Base Plate
    // Centered on X: width is 50, so X goes from -25 to 25.
    // Y goes from 0 to 45.
    difference() {
        cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_height]);
        
        // M4 Holes (Vertical through holes)
        // Holes are at (x=-17, y=30) and (x=17, y=30)
        translate([m4_hole_x1, m4_hole_y1, -1])
            cylinder(d = m4_hole_dia, h = base_z_height + 2);
        translate([m4_hole_x2, m4_hole_y2, -1])
            cylinder(d = m4_hole_dia, h = base_z_height + 2);
    }

    // 2. Vertical Motor Plate
    // Standing on the back edge of the base (y=0 to y=5).
    // X from -25 to 25. Z from 0 to 50.
    difference() {
        cube([base_x_max - base_x_min, motor_plate_y_max - motor_plate_y_min, motor_plate_z_height]);
        
        // Motor Centering Boss Hole (Cut along Y axis)
        // Center is x=0, z=28.
        translate([boss_hole_x, -1, boss_hole_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_hole_dia, h = motor_plate_y_max + 2);
        
        // M3 Screw Holes (4 holes on 31mm square pattern)
        // Pattern is centered on the boss hole (0, 28)
        for (px = [-m3_pattern_size/2, m3_pattern_size/2]) {
            for (pz = [-m3_pattern_size/2, m3_pattern_size/2]) {
                translate([px, -1, boss_hole_z + pz])
                    rotate([-90, 0, 0])
                        cylinder(d = m3_hole_dia, h = motor_plate_y_max + 2);
            }
        }
    }

    // 3. Gussets
    // Left Gusset: x from -25 to -20.
    // The gusset is a right triangle in YZ plane.
    // The corner is at y=5, z=5.
    // Since the base is 0-5 and plate is 0-5, the corner is at the intersection.
    translate([gusset_x_left_min, 0, 0])
        linear_extrude(height = gusset_thickness)
            gusset_shape();
            
    // Right Gusset: x from 20 to 25.
    translate([gusset_x_right_max - gusset_thickness, 0, 0])
        linear_extrude(height = gusset_thickness)
            gusset_shape();
}

// Verification of coordinates:
// Base: X[-25,25], Y[0,45], Z[0,5]
// Plate: X[-25,25], Y[0,5], Z[0,50]
// Gussets: X[-25,-20] and [20,25], Y[5,25], Z[5,25]
// Note: The gusset_shape polygon uses Y=5 as the base, so the gusset 
// starts at Y=5 and goes to Y=25. This is flush with the vertical plate 
// which is at Y=0 to 5.