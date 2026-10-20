$fn = 128;

// --- Dimensions ---
// Base Plate
base_x_start = -25;
base_x_end = 25;
base_y_start = 0;
base_y_end = 45;
base_thickness = 5;

// Base Mounting Holes (M4)
hole_m4_diameter = 4.5;
hole_m4_x1 = -17;
hole_m4_y1 = 30;
hole_m4_x2 = 17;
hole_m4_y2 = 30;

// Vertical Motor Plate
motor_plate_width = 25; // -25 to 25
motor_plate_height = 5; // 0 to 5
motor_plate_length = 50; // 0 to 50

// Motor Boss Hole
boss_hole_diameter = 23;
boss_hole_x = 0;
boss_hole_z = 28;

// Motor Screw Holes (M3)
screw_hole_diameter = 3.4;
screw_pattern_size = 31; // 31 mm square pattern

// Gussets
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_x_left_start = -25;
gusset_x_left_end = -20;
gusset_x_right_start = 20;
gusset_x_right_end = 25;

// --- Construction ---

module base_plate() {
    // Create the main L-shaped block
    translate([base_x_start, base_y_start, 0])
        cube([base_x_end - base_x_start, base_y_end - base_y_start, base_thickness]);

    // Cut M4 holes (extend slightly past thickness)
    for (i = [0, 1]) {
        translate([hole_m4_x1, hole_m4_y1, 0])
            cylinder(h = base_thickness + 0.1, r = hole_m4_diameter / 2);
    }
    translate([hole_m4_x2, hole_m4_y2, 0])
        cylinder(h = base_thickness + 0.1, r = hole_m4_diameter / 2);
}

module motor_plate() {
    // Create the vertical plate standing on the back edge of the base
    // Position: x from -25 to 25, y from 0 to 5, z from 0 to 50
    translate([base_x_start, base_y_start, 0])
        cube([motor_plate_width, motor_plate_height, motor_plate_length]);

    // Cut Boss Hole (along Y axis)
    // Center at x=0, z=28. Length of hole is motor_plate_height (5mm)
    translate([boss_hole_x, 0, boss_hole_z])
        cylinder(h = motor_plate_height + 0.1, r = boss_hole_diameter / 2);

    // Cut M3 Screw Holes (31mm square pattern centred on boss hole)
    // Pattern center is at x=0, z=28.
    // Square side 31mm means from -15.5 to 15.5.
    // We need 4 holes.
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            // Calculate position relative to pattern center
            // x_offset = i * (31/2)
            // z_offset = j * (31/2)
            translate([i * (screw_pattern_size / 2), 0, j * (screw_pattern_size / 2)])
                cylinder(h = motor_plate_height + 0.1, r = screw_hole_diameter / 2);
        }
    }
}

module gusset() {
    // Right triangle in YZ plane.
    // Legs: 20mm along +Y, 20mm along +Z.
    // Right angle corner at y=5, z=5.
    // So the triangle spans y from 5 to 25, z from 5 to 25.
    // Thickness is 5mm along X.
    
    // Define polygon points in YZ plane (counter-clockwise for normal +X)
    // Points: (y=5, z=5), (y=25, z=5), (y=25, z=25)
    // Wait, description says "right-angle corner at y=5, z=5".
    // Legs are 20mm along +Y and 20mm along +Z.
    // So vertices are:
    // A: (5, 5) [Right Angle]
    // B: (5+20, 5) = (25, 5) [Along Y]
    // C: (5, 5+20) = (5, 25) [Along Z]
    // Hypotenuse connects B and C.
    
    // Extrude along X direction.
    // Left Gusset: x from -25 to -20. Direction +X.
    // Right Gusset: x from 20 to 25. Direction -X.
    
    // We will generate the shape and mirror/translate appropriately.
    
    // Base point for extrusion
    p = [0, 0, 0];
    
    // Polygon points relative to the corner (5,5)
    // (0,0) -> (20,0) -> (20,20) -> (0,0)
    // This creates the triangle.
    
    // Left Gusset (x: -25 to -20)
    translate([gusset_x_left_start, 5, 5])
        linear_extrude(height = gusset_thickness, center = true)
            polygon(points = [[0, 0], [gusset_leg_y, 0], [gusset_leg_y, gusset_leg_z], [0, gusset_leg_z]], 
                     convexity = 3);

    // Right Gusset (x: 20 to 25)
    // Mirror the left gusset across the YZ plane (x=0) then shift?
    // Or just translate.
    // Left is at x=-25 (width 5). Right is at x=20 (width 5).
    // Distance between inner faces is 40mm.
    // Let's just translate the left gusset to the right position.
    // Left gusset center x = -22.5. Right gusset center x = 22.5.
    // Translation vector = [45, 0, 0].
    
    translate([45, 0, 0])
        translate([gusset_x_left_start, 5, 5])
            linear_extrude(height = gusset_thickness, center = true)
                polygon(points = [[0, 0], [gusset_leg_y, 0], [gusset_leg_y, gusset_leg_z], [0, gusset_leg_z]], 
                         convexity = 3);
}

// --- Main Assembly ---

// Combine all parts
union() {
    base_plate();
    motor_plate();
    
    // Gussets are separate bodies attached to the sides
    // Since we used linear_extrude inside the module, they are solid bodies.
    // We need to ensure they don't interfere with the plate geometry logic if we were doing difference,
    // but here we are Unioning. So we just add them.
    
    // However, the gusset module creates the geometry.
    // We need to call the gusset logic again or refactor. 
    // Refactoring for clarity in main block:
    
    // Left Gusset
    translate([gusset_x_left_start, 5, 5])
        linear_extrude(height = gusset_thickness, center = true)
            polygon(points = [[0, 0], [gusset_leg_y, 0], [gusset_leg_y, gusset_leg_z], [0, gusset_leg_z]], 
                     convexity = 3);

    // Right Gusset
    translate([gusset_x_right_start, 5, 5])
        linear_extrude(height = gusset_thickness, center = true)
            polygon(points = [[0, 0], [gusset_leg_y, 0], [gusset_leg_y, gusset_leg_z],