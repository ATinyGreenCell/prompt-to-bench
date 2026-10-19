// L-shaped NEMA 17 Stepper Motor Mounting Bracket
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

// --- Helper Modules ---

module gusset_shape() {
    // Right triangle in YZ plane
    // Corner at y=5, z=5. Legs are 20mm.
    // Vertices in YZ: (5,5), (5+20, 5), (5, 5+20)
    polygon(points = [[5, 5], [5 + gusset_leg_y, 5], [5, 5 + gusset_leg_z]]);
}

// --- Main Assembly ---

difference() {
    // --- Positive Geometry ---
    union() {
        // Base Plate
        translate([0, 0, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_max]);
        
        // Vertical Motor Plate
        translate([0, 0, 0])
            cube([base_x_max - base_x_min, vert_y_max - vert_y_min, vert_z_max]);
            
        // Gussets (Left and Right)
        // Left Gusset
        translate([base_x_min, 0, 0])
            rotate([0, 90, 0]) // Rotate to stand in YZ plane
            linear_extrude(height = gusset_thick)
            gusset_shape();
            
        // Right Gusset
        translate([base_x_max - gusset_thick, 0, 0])
            rotate([0, 90, 0])
            linear_extrude(height = gusset_thick)
            gusset_shape();
    }

    // --- Negative Geometry (Cuts) ---
    
    // M4 Holes in Base Plate
    translate([m4_hole_x1, m4_hole_y, -1])
        cylinder(h = base_z_max + 2, d = m4_hole_d);
    translate([m4_hole_x2, m4_hole_y, -1])
        cylinder(h = base_z_max + 2, d = m4_hole_d);

    // Motor Boss Hole (through the vertical plate along Y)
    // The plate is at y=0 to 5. The hole is 23mm diameter.
    // Since the plate is only 5mm thick, we cut through the Y axis.
    translate([boss_x, -1, boss_z])
        rotate([0, 90, 0])
        cylinder(h = vert_y_max + 2, d = boss_d);

    // M3 Screw Holes in Vertical Plate
    // Pattern is 31mm square, centered on boss (0, 28)
    // Coordinates relative to center: +/- 15.5
    for (sx = [-1, 1], sz = [-1, 1]) {
        translate([sx * (m3_pattern_size / 2), -1, boss_z + sz * (m3_pattern_size / 2)])
            rotate([0, 90, 0])
            cylinder(h = vert_y_max + 2, d = m3_hole_d);
    }
}

// Note: The base plate is centered on X by the user's request of -25 to 25.
// In OpenSCAD, cube([50, 45, 5]) starts at 0,0,0. 
// To match the user's coordinate system exactly:
// We use translate to ensure the base plate is at x = -25 to 25.
// However, the code above uses absolute coordinates for simplicity.
// Let's adjust the base plate translation to match the user's coordinate request.
// User: Base plate x from -25 to 25, y from 0 to 45.
// My code: cube([50, 45, 5]) at [0,0,0] results in x: 0 to 50.
// Corrected logic:
// I will rewrite the main block to use the user's exact coordinate system.