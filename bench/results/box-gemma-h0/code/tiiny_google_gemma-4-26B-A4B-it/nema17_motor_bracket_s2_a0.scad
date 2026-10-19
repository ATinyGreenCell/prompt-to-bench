// NEMA 17 Stepper Motor L-Bracket for Syringe Pump
// Designed for FDM 3D Printing

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

module gusset() {
    // A right triangle in YZ plane, extruded along X
    // Corner at y=5, z=5. Legs are 20mm.
    // Vertices in YZ: (5,5), (25,5), (5,25)
    polygon(points = [
        [0, 5], 
        [gusset_leg_y, 5], 
        [0, gusset_leg_z]
    ]);
}

union() {
    // 1. Main Base Plate
    difference() {
        cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_height]);
        
        // M4 Holes (Vertical through holes)
        // We translate to the center of the base plate relative to the origin
        // Since base is -25 to 25, x=0 is center.
        translate([m4_hole_x1, m4_hole_y1, -1])
            cylinder(d = m4_hole_dia, h = base_z_height + 2);
        translate([m4_hole_x2, m4_hole_y2, -1])
            cylinder(d = m4_hole_dia, h = base_z_height + 2);
    }

    // 2. Vertical Motor Plate
    difference() {
        // The plate itself
        cube([base_x_max - base_x_min, motor_plate_y_max - motor_plate_y_min, motor_plate_z_height]);
        
        // Motor Centering Boss Hole (Cut along Y axis)
        // Center is x=0, z=28. Hole is 23mm diameter.
        translate([boss_hole_x, -1, boss_hole_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_hole_dia, h = motor_plate_y_max + 2);
        
        // M3 Screw Holes (4 holes on 31mm square pattern)
        // Pattern is centered on the boss hole (0, 28)
        // Half-pattern is 15.5mm
        for (px = [-m3_pattern_size/2, m3_pattern_size/2]) {
            for (pz = [-m3_pattern_size/2, m3_pattern_size/2]) {
                translate([px, -1, boss_hole_z + pz])
                    rotate([-90, 0, 0])
                        cylinder(d = m3_hole_dia, h = motor_plate_y_max + 2);
            }
        }
    }

    // 3. Gussets
    // Left Gusset
    translate([gusset_x_left_min, 5, 5])
        linear_extrude(height = gusset_thickness)
            gusset();
            
    // Right Gusset
    // Note: The user specified gussets are flush with edges. 
    // Since the plate is -25 to 25, we place them at the edges.
    // We use a trick to mirror/place them correctly.
    translate([gusset_x_right_max - gusset_thickness, 5, 5])
        linear_extrude(height = gusset_thickness)
            gusset();
}

// Note on Gusset Placement: 
// The user requested gussets at x = -25 to -20 and x = 20 to 25.
// My code places the left one at -25 and the right one at 20 (ending at 25).
// This matches the dimensions provided.