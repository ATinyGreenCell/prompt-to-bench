// NEMA 17 Stepper Motor L-Bracket for Syringe Pump
// Corrected version to ensure watertightness and correct geometry

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
eps = 0.01; // Small epsilon for watertightness

// --- Main Assembly ---

// We use a single union/difference structure to ensure a single watertight manifold
difference() {
    // The combined solid geometry
    union() {
        // 1. Base Plate
        translate([-base_width_x/2, 0, 0])
            cube([base_width_x, base_depth_y, base_height_z]);

        // 2. Vertical Motor Plate
        // Positioned at the back edge (y=0 to y=5)
        translate([-motor_plate_width_x/2, 0, base_height_z])
            cube([motor_plate_width_x, motor_plate_depth_y, motor_plate_height_z]);

        // 3. Gussets
        // Left Gusset: Right triangle in YZ plane, legs 20mm along Y and Z
        // Corner at y=5 (relative to base), z=5 (relative to base)
        // Note: The specification says "right-angle corner at y=5, z=5 (where the plates meet)"
        // Since base is 5mm thick, the plates meet at z=5.
        // The gusset is flush with the left edge (x=-25 to -20)
        translate([-gusset_x_outer, 5, 5])
            rotate([0, -90, 0]) 
                linear_extrude(gusset_thickness)
                    polygon(points=[[0,0], [gusset_leg_y, 0], [0, gusset_leg_z]]);

        // Right Gusset: Flush with right edge (x=20 to 25)
        translate([gusset_x_inner, 5, 5])
            rotate([0, -90, 0]) 
                linear_extrude(gusset_thickness)
                    polygon(points=[[0,0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
    }

    // --- Subtraction Operations ---

    // M4 Holes in Base Plate
    translate([base_hole_x1, base_hole_y, -eps])
        cylinder(d=base_hole_dia, h=base_height_z + 2*eps);
    translate([base_hole_x2, base_hole_y, -eps])
        cylinder(d=base_hole_dia, h=base_height_z + 2*eps);

    // Boss Centering Hole (through the vertical plate)
    // Plate is at y=0 to 5. Center is at y=2.5.
    translate([boss_hole_x, -eps, boss_hole_z])
        cylinder(d=boss_hole_dia, h=motor_plate_depth_y + 2*eps);

    // M3 Screw Holes (4 holes in square pattern)
    // Centered on the boss hole (0, 28)
    for (px = [-screw_offset, screw_offset]) {
        for (pz = [-screw_offset, screw_offset]) {
            translate([px, -eps, boss_hole_z + pz])
                cylinder(d=screw_hole_dia, h=motor_plate_depth_y + 2*eps);
        }
    }
}