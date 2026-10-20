$fn = 64;

// --- Dimensions (mm) ---
base_x_len = 50;       // -25 to 25
base_y_len = 45;       // 0 to 45
base_z_thick = 5;      // 0 to 5

motor_plate_x_len = 50; // -25 to 25
motor_plate_y_len = 5;  // 0 to 5
motor_plate_z_len = 50; // 0 to 50

hole_m4_dia = 4.5;
hole_m4_pos_x = [-17, 17];
hole_m4_pos_y = 30;

hole_motor_boss_dia = 23;
hole_motor_boss_z = 28;

hole_m3_dia = 3.4;
hole_m3_spacing = 31; // Square pattern side length
hole_m3_z = 28;        // Same height as boss hole

gusset_thick = 5;
gusset_y_len = 20;
gusset_z_len = 20;
gusset_x_start = -25;
gusset_x_end = -20;
gusset_x_start_right = 20;
gusset_x_end_right = 25;

// --- Geometry ---

// Base Plate
module base_plate() {
    difference() {
        // Main block
        cube([base_x_len, base_y_len, base_z_thick], center=false);
        
        // M4 Holes
        for (x = hole_m4_pos_x) {
            translate([x, hole_m4_pos_y, -0.01])
            cylinder(d = hole_m4_dia, h = base_z_thick + 0.02, center=false);
        }
    }
}

// Vertical Motor Plate
module motor_plate() {
    difference() {
        // Main block
        cube([motor_plate_x_len, motor_plate_y_len, motor_plate_z_len], center=false);
        
        // Motor Boss Hole (23mm)
        translate([0, 0, hole_motor_boss_z - 0.01])
        cylinder(d = hole_motor_boss_dia, h = motor_plate_z_len + 0.02, center=false);
        
        // M3 Screw Holes (31mm square pattern)
        // Calculate offsets from center (0,0) to corners of the square
        // Pattern is centered at x=0, y=0 relative to the plate
        let(offset = hole_m3_spacing / 2) {
            for (x = [-offset, offset]) {
                for (y = [-offset, offset]) {
                    translate([x, y, hole_m3_z - 0.01])
                    cylinder(d = hole_m3_dia, h = motor_plate_z_len + 0.02, center=false);
                }
            }
        }
    }
}

// Gussets
module gusset(x_start, x_end) {
    // Right triangle in YZ plane
    // Right angle corner at y=5, z=5
    // Legs: 20mm along +Y, 20mm along +Z
    // The hypotenuse connects (y=5, z=25) to (y=25, z=5)
    
    // Using polygon to define the triangle shape
    polygon([
        [0, 0], // Bottom-Left (0,0)
        [x_end - x_start, 0], // Bottom-Right (thickness, 0)
        [x_end - x_start, gusset_z_len], // Top-Right (thickness, 20)
        [0, gusset_z_len]  // Top-Left (0, 20)
    ]);
}

module gussets() {
    // Left Gusset
    translate([gusset_x_start, 0, 0])
    rotate([0, 0, 90])
    translate([gusset_thick, 0, 0])
    color("red") // Visual aid only
    cylinder(d = gusset_thick, h = gusset_y_len, center=false);
    
    // Right Gusset
    translate([gusset_x_end_right, 0, 0])
    rotate([0, 0, 90])
    translate([gusset_thick, 0, 0])
    color("red") // Visual aid only
    cylinder(d = gusset_thick, h = gusset_y_len, center=false);
}

// Assembly
union() {
    base_plate();
    
    // Motor Plate positioned on the back edge (y=0) of the base
    translate([0, 0, base_z_thick])
    motor_plate();
    
    // Gussets
    gussets();
}