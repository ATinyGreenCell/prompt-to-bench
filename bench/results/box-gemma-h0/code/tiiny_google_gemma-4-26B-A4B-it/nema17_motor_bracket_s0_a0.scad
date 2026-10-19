// NEMA 17 Stepper Motor L-Bracket for Syringe Pump
// Designed for FDM 3D Printing

// --- Dimensions ---
// Base Plate
base_width_x = 50;           // Total width (-25 to 25)
base_depth_y = 45;           // Total depth (0 to 45)
base_height_z = 5;           // Thickness of base
base_hole_dia = 4.5;         // M4 screw holes
base_hole_x1 = -17;          // X position of hole 1
base_hole_x2 = 17;           // X position of hole 2
base_hole_y = 30;            // Y position of holes

// Vertical Motor Plate
motor_plate_width_x = 50;    // Total width (-25 to 25)
motor_plate_depth_y = 5;     // Thickness of vertical plate
motor_plate_height_z = 50;   // Total height (0 to 50)

// Motor Mounting Features (on Vertical Plate)
boss_hole_dia = 23;          // Centering boss hole diameter
boss_hole_x = 0;             // Center X of boss hole
boss_hole_z = 28;            // Center Z of boss hole
boss_hole_y_offset = 2.5;    // Center of hole in Y (half of plate thickness)

screw_hole_dia = 3.4;        // M3 screw holes
screw_pattern_size = 31;     // Square pattern for M3 screws
screw_offset = screw_pattern_size / 2;

// Gussets
gusset_thickness = 5;        // Thickness of gussets
gusset_leg_y = 20;           // Leg length along Y
gusset_leg_z = 20;           // Leg length along Z
gusset_x_outer = 25;         // Outer X edge
gusset_x_inner = 20;         // Inner X edge

// --- Constants ---
$fn = 64;
eps = 0.1; // Overlap for difference operations

// --- Main Assembly ---

union() {
    // 1. Base Plate
    difference() {
        // Main Body
        translate([-base_width_x/2, 0, 0])
            cube([base_width_x, base_depth_y, base_height_z]);
        
        // M4 Holes (Vertical through holes)
        translate([base_hole_x1, base_hole_y, -eps])
            cylinder(d=base_hole_dia, h=base_height_z + 2*eps);
        translate([base_hole_x2, base_hole_y, -eps])
            cylinder(d=base_hole_dia, h=base_height_z + 2*eps);
    }

    // 2. Vertical Motor Plate
    difference() {
        // Main Body
        translate([-motor_plate_width_x/2, 0, 0])
            cube([motor_plate_width_x, motor_plate_depth_y, motor_plate_height_z]);
        
        // Boss Centering Hole (Cut through Y axis)
        translate([boss_hole_x, -eps, boss_hole_z])
            cylinder(d=boss_hole_dia, h=motor_plate_depth_y + 2*eps);
        
        // M3 Screw Holes (4 holes in square pattern)
        // Pattern is centered on the boss hole
        for (px = [-screw_offset, screw_offset]) {
            for (pz = [-screw_offset, screw_offset]) {
                translate([px, -eps, boss_hole_z + pz])
                    cylinder(d=screw_hole_dia, h=motor_plate_depth_y + 2*eps);
            }
        }
    }

    // 3. Gussets
    // Left Gusset
    translate([-gusset_x_outer, 5, 5])
        rotate([0, -90, 0]) // Rotate to lie in YZ plane
        linear_extrude(gusset_thickness)
            polygon(points=[[0,0], [gusset_leg_y, 0], [0, gusset_leg_z]]);

    // Right Gusset
    translate([gusset_x_inner, 5, 5])
        rotate([0, -90, 0]) // Rotate to lie in YZ plane
        linear_extrude(gusset_thickness)
            polygon(points=[[0,0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
}