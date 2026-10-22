$fn = 128;

// --- Dimensions ---
// Base Plate
base_width_x = 50;   // x from -25 to 25
base_height_y = 45;  // y from 0 to 45
base_thickness_z = 5; // z from 0 to 5

// Base Mounting Holes (M4)
base_hole_diameter = 4.5;
base_hole_x1 = -17;
base_hole_y1 = 30;
base_hole_x2 = 17;
base_hole_y2 = 30;

// Vertical Motor Plate
motor_plate_width_x = 50; // x from -25 to 25
motor_plate_height_y = 5; // y from 0 to 5
motor_plate_thickness_z = 50; // z from 0 to 50

// Motor Plate Hole (Centring Boss)
motor_hole_diameter = 23;
motor_hole_x = 0;
motor_hole_z = 28;

// Motor Plate Screw Holes (M3)
motor_screw_hole_diameter = 3.4;
motor_screw_pattern_size = 31; // 31 mm square pattern
motor_screw_pattern_center_x = 0;
motor_screw_pattern_center_z = motor_hole_z;

// Gussets
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
// Gusset position: Right angle corner at y=5, z=5. Extends +Y and +Z.
// Left Gusset: x from -25 to -20 (width 5)
// Right Gusset: x from 20 to 25 (width 5)

// --- Construction ---

module base_plate() {
    // Main block
    translate([0, 0, 0])
        cube([base_width_x, base_height_y, base_thickness_z]);

    // Cut M4 holes
    // Extend slightly past faces to ensure clean cut
    $fn = 64;
    for (i = [0, 1]) {
        translate([base_hole_x1, base_hole_y1, 0])
            cylinder(h = base_thickness_z + 0.1, r = base_hole_diameter / 2);
        
        translate([base_hole_x2, base_hole_y2, 0])
            cylinder(h = base_thickness_z + 0.1, r = base_hole_diameter / 2);
    }
}

module motor_plate() {
    // Main block
    translate([0, 0, 0])
        cube([motor_plate_width_x, motor_plate_height_y, motor_plate_thickness_z]);

    // Cut Motor Centring Boss Hole
    // Center at x=0, z=28. Hole is along Y axis.
    // Extend slightly past faces
    translate([motor_hole_x, 0, motor_hole_z])
        cylinder(h = motor_plate_height_y + 0.1, r = motor_hole_diameter / 2);

    // Cut M3 Screw Holes (4 holes on 31mm square pattern)
    // Pattern centered at (0, 28). 
    // Square size 31mm means half-size is 15.5mm.
    // Corners at +/- 15.5 in X and Z relative to center.
    $fn = 64;
    for (i = [0, 1, 2, 3]) {
        // Calculate corner offsets
        // i=0: (-15.5, -15.5)
        // i=1: (15.5, -15.5)
        // i=2: (15.5, 15.5)
        // i=3: (-15.5, 15.5)
        if (i == 0) { tx = -motor_screw_pattern_size/2; tz = -motor_screw_pattern_size/2; }
        else if (i == 1) { tx = motor_screw_pattern_size/2; tz = -motor_screw_pattern_size/2; }
        else if (i == 2) { tx = motor_screw_pattern_size/2; tz = motor_screw_pattern_size/2; }
        else { tx = -motor_screw_pattern_size/2; tz = motor_screw_pattern_size/2; }

        translate([motor_screw_pattern_center_x + tx, 0, motor_screw_pattern_center_z + tz])
            cylinder(h = motor_plate_height_y + 0.1, r = motor_screw_hole_diameter / 2);
    }
}

module gusset() {
    // Right triangle in YZ plane.
    // Legs: 20mm along +Y, 20mm along +Z.
    // Right angle corner at y=5, z=5.
    // So the triangle vertices in local coords (relative to corner) are:
    // (0,0), (20,0), (0,20).
    // We need to position this such that the corner is at y=5, z=5.
    // The gusset has thickness 5mm along X.
    
    // Create the triangular profile in YZ
    // Vertices: (y=0, z=0), (y=20, z=0), (y=0, z=20)
    // This forms the right angle at (0,0).
    // We will translate this so (0,0) lands at (y=5, z=5).
    
    // Profile definition
    points = [
        [0, 0], // y=0, z=0 (corner)
        [gusset_leg_y, 0], // y=20, z=0
        [0, gusset_leg_z]  // y=0, z=20
    ];

    // Extrude along X axis
    // We need to rotate the profile so it lies in XZ plane, extrude along Y?
    // No, let's stick to the rule: Build on XY, build up Z.
    // The gusset is a block.
    // Let's construct it by rotating the profile 90 deg around Y, extruding along Z (which becomes X), then rotating back.
    // Wait, if I rotate 90 deg around Y, the Z axis becomes X axis.
    // So:
    // 1. Define polygon in YZ plane (y, z).
    // 2. Rotate -90 deg around Y. Now the plane is XZ. The "y" coord of the polygon becomes "x" coord in space, "z" stays "z".
    // 3. Linear extrude along Z? No, linear_extrude extrudes along Z.
    // Let's try a different approach:
    // 1. Define polygon in XZ plane (x, z).
    // 2. Linear extrude along Y.
    
    // We want the triangle in the YZ plane.
    // Vertices: (y=0, z=0), (y=20, z=0), (y=0, z=20).
    // We want to extrude this along X.
    // To use linear_extrude (which extrudes along Z), we can:
    // 1. Rotate the whole thing 90 deg around Y. Now the YZ plane is the XZ plane.
    //    The point (y, z) becomes (z, y) in the new XZ plane?
    //    Rotation around Y: x' = z, z' = -x.
    //    So a point (0, 0, z) becomes (0, 0, -z)? No.
    //    Let's just build the prism directly using a loop or a specific shape.
    
    // Simplest robust way for a prism in YZ extruded along X:
    // 1. Create the 2D shape in the XZ plane (x, z).
    //    Since we are extruding along X, the "width" of the extrusion is the X dimension.
    //    The "profile" is in the YZ plane.
    //    So we need to rotate the profile 90 deg around Z? No.
    //    Let's rotate the profile 90 deg around Y.
    //    Original: y (horizontal), z (vertical).
    //    Rotate -90 around Y: y becomes z, z becomes -x.
    //    This is getting confusing.
    
    // Let's use the standard trick:
    // 1. Define the polygon in the XZ plane (x, z).
    //    We want the cross section in YZ to be the triangle.
    //    So if we extrude along Y, the cross section is in XZ.
    //    We want the cross section in YZ.
    //    So we should