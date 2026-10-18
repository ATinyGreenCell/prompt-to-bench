// L-shaped mounting bracket for NEMA 17 stepper motor.
// Base plate: 50x45x5 mm. Motor plate: 50x5x50 mm.
// Includes M4 mounting holes, motor boss hole, M3 screw holes, and gussets.

// Base dimensions
base_x = 50;
base_y = 45;
base_z = 5;

// Motor plate dimensions
motor_x = 50;
motor_y = 5;
motor_z = 50;

// Hole dimensions
m4_diameter = 4.5;
m3_diameter = 3.4;
boss_diameter = 23;

// Gusset dimensions
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;

// Hole positions
hole1_x = -17;
hole1_y = 30;
hole2_x = 17;
hole2_y = 30;

// Motor boss position
boss_x = 0;
boss_z = 28;

// Gusset positions (flush with edges)
gusset_left_x_start = -25;
gusset_left_x_end = -20;
gusset_right_x_start = 20;
gusset_right_x_end = 25;

$fn = 64;

// Create the base plate with M4 holes
difference() {
    // Main base block
    translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);

    // M4 holes (through Z)
    for (i = [0 : 1]) {
        if (i == 0) {
            translate([hole1_x, hole1_y, -1]) cylinder(h = base_z + 2, d = m4_diameter);
        } else {
            translate([hole2_x, hole2_y, -1]) cylinder(h = base_z + 2, d = m4_diameter);
        }
    }
}

// Create the vertical motor plate with boss and screw holes
difference() {
    // Main motor block
    translate([-motor_x / 2, 0, 0]) cube([motor_x, motor_y, motor_z]);

    // Motor boss hole (along Y axis)
    translate([boss_x, 0, boss_z]) cylinder(h = motor_y + 2, d = boss_diameter);

    // M3 screw holes (4 holes on 31mm square pattern)
    // Pattern centered at x=0, z=28.
    // Pattern size 31mm means radius 15.5mm.
    // Holes at (0, 15.5), (0, -15.5), (15.5, 0), (-15.5, 0) relative to center.
    // Absolute Z = 28.
    // Absolute X = 0.
    // Absolute Y = 0.
    
    // Hole 1: Top (Y+)
    translate([0, 15.5, boss_z - 1]) cylinder(h = motor_y + 2, d = m3_diameter);
    
    // Hole 2: Bottom (Y-)
    translate([0, -15.5, boss_z - 1]) cylinder(h = motor_y + 2, d = m3_diameter);
    
    // Hole 3: Right (X+)
    translate([15.5, 0, boss_z - 1]) cylinder(h = motor_y + 2, d = m3_diameter);
    
    // Hole 4: Left (X-)
    translate([-15.5, 0, boss_z - 1]) cylinder(h = motor_y + 2, d = m3_diameter);
}

// Create the left gusset
difference() {
    // Gusset shape: Right triangle in YZ plane, extruded along X.
    // Right angle at (y=5, z=5). Legs along +Y and +Z.
    // Vertices in YZ plane: (5, 5), (5+20, 5) = (25, 5), (5, 5+20) = (5, 25).
    // Extrude from x = -25 to x = -20.
    
    translate([gusset_left_x_start, 0, 0]) {
        // Define the 2D profile in YZ plane
        // Points: (y, z)
        // (5, 5) -> (25, 5) -> (5, 25) -> close
        polygon(
            points = [
                [5, 5],
                [25, 5],
                [5, 25]
            ],
            path = true
        );
        // Extrude along X
        linear_extrude(height = gusset_left_x_end - gusset_left_x_start, center = false) {
            // We need to define the polygon in the local coordinate system of the extrusion.
            // The extrusion direction is X. The polygon is in YZ.
            // OpenSCAD linear_extrude extrudes along Z by default if the polygon is in XY.
            // We need to rotate the polygon to be in YZ and extrude along X.
            // Actually, simpler: define polygon in XY, rotate 90 deg around X to put it in YZ?
            // No, let's use rotate_extrude or just build the polyhedron directly or rotate the polygon.
            // Let's rotate the polygon 90 deg around X axis so it lies in YZ plane, then extrude along X?
            // No, linear_extrude extrudes along Z.
            // Let's rotate the whole thing 90 deg around Y axis so the extrusion goes along X?
            // No, let's just use rotate_extrude with a circle? No, it's a triangle.
            // Let's use rotate_extrude with a polygon? No, rotate_extrude rotates around Z.
            // Let's use rotate_extrude with a polygon in XY, then rotate the result?
            // Let's try: define polygon in XY, rotate_extrude to make a cylinder-like thing, then rotate?
            // No, let's use the `polygon` command with `linear_extrude` but orient correctly.
            // If we define points in XY, linear_extrude makes a prism along Z.
            // We want a prism along X.
            // So we define points in YZ, then rotate the whole assembly 90 deg around Y?
            // No, let's just use `rotate([0, 90, 0])` to put the X-axis into the Z-axis direction?
            // Let's try this:
            // 1. Define polygon in XY plane: (0,0), (20,0), (0,20).
            // 2. Extrude along Z (height = 5).
            // 3. Rotate 90 deg around Y axis. Now the extrusion is along X.
            // 4. Translate to position.
            
            // Let's do it step by step inside the module.
            // Profile in XY:
            // (0,0) -> (20,0) -> (0,20)
            // Extrude height = 5 (along Z).
            // Rotate 90 deg around Y (X becomes Z, Z becomes -X).
            // Translate to final position.
            
            // Wait, the gusset is in the YZ plane.
            // Let's define the profile in XY: (0,0), (20,0), (0,20).
            // Extrude along Z (height = 5).
            // Rotate 90 deg around Y axis.
            // The extrusion (Z) becomes X. The profile (XY) becomes XZ? No.
            // Rotation around Y: X -> Z, Z -> -X. Y -> Y.
            // So the profile (XY) becomes (ZY). The extrusion (Z) becomes (X).
            // This works.
            
            // Profile points in XY:
            // (0,0) -> (20,0) -> (0,20)
            // This corresponds to Y=0, Z=0; Y=20, Z=0; Y=0, Z=20.
            // After rotation around Y:
            // (0,0) -> (0,0,0)
            // (20,0) -> (0,20,0) -> Y=20, Z=0.
            // (0,20) -> (0,0,20) -> Y=0, Z=20.
            // This matches the required shape: Y from 5 to 25, Z from 5 to 25.
            // We need to translate by (5, 5) in YZ.