// L-shaped mounting bracket for NEMA 17 stepper motor.
// Base plate: 50x45x5, Motor plate: 50x5x50, Gussets on sides.

$fn = 64;

// Base dimensions
base_x = 50;
base_y = 45;
base_z = 5;

// Motor plate dimensions
motor_x = 50;
motor_y = 5;
motor_z = 50;

// Hole dimensions
m4_hole_d = 4.5;
m3_hole_d = 3.4;

// Gusset dimensions
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;

// Boss hole dimensions
boss_hole_d = 23;
boss_hole_z = 28;

// Gusset position (flush with edges)
gusset_x_left = -25;
gusset_x_right = 20;

// Base mounting holes
base_hole_x1 = -17;
base_hole_y1 = 30;
base_hole_x2 = 17;
base_hole_y2 = 30;

// Motor plate boss hole
boss_hole_x = 0;
boss_hole_z = 28;

// Motor plate screw holes (31mm square pattern)
screw_pattern_size = 31;
screw_holes = [
    [0, 0],
    [0, screw_pattern_size],
    [screw_pattern_size, 0],
    [screw_pattern_size, screw_pattern_size]
];

// Base plate
difference() {
    translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);
    
    // Base mounting holes
    for (i = [0 : 1]) {
        translate([
            (i == 0) ? base_hole_x1 : base_hole_x2,
            (i == 0) ? base_hole_y1 : base_hole_y2,
            0
        ]) cylinder(h = base_z + 1, d = m4_hole_d);
    }
}

// Motor plate
difference() {
    translate([-motor_x / 2, 0, base_z]) cube([motor_x, motor_y, motor_z]);
    
    // Boss hole
    translate([boss_hole_x, 0, boss_hole_z]) cylinder(h = motor_z + 1, d = boss_hole_d);
    
    // Screw holes
    for (p = screw_holes) {
        translate([p[0], 0, p[1]]) cylinder(h = motor_z + 1, d = m3_hole_d);
    }
}

// Gussets
// Left Gusset
translate([gusset_x_left, 0, 0]) {
    // Right triangle in YZ plane, extruded along X
    // Vertices: (0, 0), (gusset_leg_y, 0), (gusset_leg_y, gusset_leg_z)
    // Extrude along X from 0 to gusset_thickness
    difference() {
        // Main body: box
        translate([0, 0, 0]) cube([gusset_thickness, gusset_leg_y, gusset_leg_z]);
        
        // Cut out the triangular void
        // The void is a right triangle with vertices (0,0), (gusset_leg_y, 0), (gusset_leg_y, gusset_leg_z)
        // We need to cut a shape that matches this triangle.
        // Since we are extruding along X, we define the 2D profile in YZ.
        // The profile is a polygon: (0,0), (gusset_leg_y, 0), (gusset_leg_y, gusset_leg_z), (0, gusset_leg_z)
        // Wait, the gusset is a solid right triangle. The void is the rest of the rectangle.
        // The gusset occupies the region where y <= gusset_leg_y and z <= (gusset_leg_z / gusset_leg_y) * y?
        // No, the problem says: "right triangle in the YZ plane with legs 20 mm along +Y and 20 mm along +Z, its right-angle corner at y = 5, z = 5".
        // This implies the triangle vertices are (5,5), (5+20, 5), (5, 5+20).
        // So the triangle is defined by points: (5,5), (25,5), (5,25).
        // The hypotenuse connects (25,5) and (5,25).
        // The gusset is the solid triangle. The void is the L-shaped area around it within the 20x20 box.
        
        // Let's redefine the gusset geometry based on the description:
        // "flush with the left and right edges (x = -25 to -20 and x = 20 to 25)"
        // "right triangle in the YZ plane with legs 20 mm along +Y and 20 mm along +Z"
        // "right-angle corner at y = 5, z = 5"
        // This means the triangle vertices are:
        // A: (y=5, z=5) -> Right angle
        // B: (y=25, z=5) -> Leg along Y
        // C: (y=5, z=25) -> Leg along Z
        // The solid is the triangle ABC.
        // The void to cut is the rectangle [5, 25] x [5, 25] MINUS the triangle ABC.
        
        // Define the void polygon (counter-clockwise for difference)
        // Rectangle corners: (5,5), (25,5), (25,25), (5,25)
        // Triangle corners: (5,5), (25,5), (5,25)
        // Void polygon: (5,5) -> (25,5) -> (25,25) -> (5,25) -> (5,5)
        // Wait, the triangle is (5,5)-(25,5)-(5,25). The void is the rest of the square.
        // The square is (5,5)-(25,5)-(25,25)-(5,25).
        // The triangle is the lower-left half of the square? No.
        // Vertices: (5,5), (25,5), (5,25).
        // This is the lower-left triangle if (25,25) is top-right.
        // So the void is the upper-right triangle: (25,5), (25,25), (5,25).
        
        // Void polygon vertices (Y, Z):
        // (25, 5), (25, 25), (5, 25)
        // We need to close the loop.
        // Actually, let's just create the solid triangle directly using polyhedron or rotate_extrude?
        // No, the gusset is a flat plate. We can use linear_extrude with a polygon.
        // Polygon vertices: (5, 5), (25, 5), (5, 25).
        // Note: linear_extrude expects (x, y) where x is horizontal, y is vertical.
        // Here Y is horizontal, Z is vertical.
        
        // Solid triangle polygon:
        // [5, 5], [25, 5], [5, 25]
        // This forms a triangle.
        
        // However, the gusset is attached to the plates.
        // The base plate is at z=0 to 5. The motor plate is at y=0 to 5.
        // The gusset is at y=5 to 25, z=5 to 25.
        // It sits in the corner formed by the extension of the base and motor plates.
        // The gusset thickness is 5mm along X.
        // Left gusset: x from -25 to -20.
        // Right gusset: x from 20 to 25.
        
        // Let's build the gusset as a solid block and then cut the void?
        // Or just extrude the triangle.
        // Extrude the triangle along X.
        
        // Left Gusset
        translate([-25, 0, 0]) {
            linear_extrude(height = gusset_thickness, center = false) {
                polygon([
                    [5, 5],
                    [25, 5],
                    [5, 25]
                ]);
            }
        }
    }
}

// Right Gusset
translate([2