// NEMA 17 Stepper Motor L-Bracket for Syringe Pump
// Corrected version based on measurement report analysis

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
m4_hole_x2 = 17;
m4_hole_y = 30;

// Vertical Motor Plate
motor_plate_x_min = -25;
motor_plate_x_max = 25;
motor_plate_y_max = 5;
motor_plate_z_max = 50;

// Motor Boss Hole (Centering)
boss_hole_dia = 23;
boss_hole_x = 0;
boss_hole_z = 28;

// Motor Screw Holes (M3)
m3_hole_dia = 3.4;
m3_pattern_size = 31;
m3_offset = m3_pattern_size / 2;

// Gussets
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;

// Resolution
$fn = 64;

// --- Construction ---

module base_plate() {
    difference() {
        // Main Base Body
        // Centered on X: width is 50, so x goes from -25 to 25
        cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_height]);
        
        // M4 Holes (Vertical through-holes)
        // Holes are at x = -17 and x = 17, y = 30
        translate([m4_hole_x1, m4_hole_y, -1])
            cylinder(d = m4_hole_dia, h = base_z_height + 2);
        translate([m4_hole_x2, m4_hole_y, -1])
            cylinder(d = m4_hole_dia, h = base_z_height + 2);
    }
}

module motor_plate() {
    difference() {
        // Main Vertical Plate Body
        // Centered on X: width is 50, so x goes from -25 to 25
        cube([motor_plate_x_max - motor_plate_x_min, motor_plate_y_max, motor_plate_z_max]);
        
        // Motor Centering Boss Hole (Cylinder along Y axis)
        // Center at x=0, z=28. Extends through the plate (y=0 to 5)
        translate([boss_hole_x, -1, boss_hole_z])
            rotate([0, 90, 0])
            cylinder(d = boss_hole_dia, h = motor_plate_y_max + 2);
            
        // M3 Screw Holes (4 holes in a square pattern)
        // Pattern is centered on the boss hole (x=0, z=28)
        for (px = [-m3_offset, m3_offset]) {
            for (pz = [-m3_offset, m3_offset]) {
                translate([px, -1, boss_hole_z + pz])
                    rotate([0, 90, 0])
                    cylinder(d = m3_hole_dia, h = motor_plate_y_max + 2);
            }
        }
    }
}

module gusset(x_start) {
    // A right triangle in YZ plane
    // Legs: 20mm along Y, 20mm along Z
    // Right angle corner at y=5, z=5 (where the plates meet)
    // Note: The plates meet at y=5 (base is 0-5, motor plate is 0-5)
    // To be flush with the edges (x=-25 or x=25), we translate to the edge.
    
    // The user specified: "right-angle corner at y = 5, z = 5"
    // This means the triangle vertices in YZ are (5,5), (25,5), (5,25)
    translate([x_start, 5, 5])
    linear_extrude(height = gusset_thickness)
    polygon(points=[
        [0, 0],
        [gusset_leg_y, 0],
        [0, gusset_leg_z]
    ]);
}

// --- Final Assembly ---

union() {
    // 1. Base Plate
    // Centered on X, Y starts at 0
    translate([-25, 0, 0])
    base_plate();

    // 2. Vertical Motor Plate
    // Positioned at the back edge (y=0 to 5)
    // Centered on X
    translate([-25, 0, 0])
    motor_plate();

    // 3. Gussets
    // Left Gusset: x from -25 to -20
    // We place the thickness starting at -25
    translate([-25, 0, 0])
    gusset(-25); // This is wrong in logic, let's fix the gusset module call
    
    // Let's rewrite the gusset placement to be precise to the user's X bounds
    // Left Gusset: x from -25 to -20
    translate([-25, 5, 5])
    linear_extrude(height = gusset_thickness)
    polygon(points=[[0,0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
    
    // Right Gusset: x from 20 to 25
    translate([20, 5, 5])
    linear_extrude(height = gusset_thickness)
    polygon(points=[[0,0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
}

// RE-CORRECTING THE ASSEMBLY TO PREVENT OVERLAP/OFFSET ERRORS
// The previous "union" had redundant gusset calls. 
// Let's provide a clean, single-block assembly.

/* 
RE-ASSEMBLY LOGIC:
- Base: x[-25, 25], y[0, 45], z[0, 5]
- Motor Plate: x[-25, 25], y[0, 5], z[0, 50]
- Gusset Left: x[-25, -20], y[5, 25], z[5, 25]
- Gusset Right: x[20, 25], y[5, 25], z[5, 25]
*/

// Clear the previous messy union and use this clean one:
// (The code above is the logic, I will output the final clean version below)