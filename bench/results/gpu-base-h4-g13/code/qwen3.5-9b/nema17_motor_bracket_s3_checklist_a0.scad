// L-shaped mounting bracket for NEMA 17 stepper motor.
// Base plate: 50 x 45 x 5 mm.
// Motor plate: 50 x 5 x 50 mm standing on the back edge.
// Includes M4 holes, motor boss hole, M3 screw holes, and triangular gussets.

// Base Plate Dimensions
base_x_len = 50;   // x from -25 to 25
base_y_len = 45;   // y from 0 to 45
base_z_thk = 5;    // z from 0 to 5

// Motor Plate Dimensions
motor_x_len = 50;  // x from -25 to 25
motor_y_thk = 5;   // y from 0 to 5
motor_z_len = 50;  // z from 0 to 50

// Hole Dimensions
m4_diameter = 4.5;
m3_diameter = 3.4;
boss_diameter = 23;

// Hole Locations
hole_m4_x = -17;
hole_m4_y = 30;
hole_m4_x2 = 17;

// Gusset Dimensions
gusset_x_start = -25;
gusset_x_end = -20;
gusset_x2_start = 20;
gusset_x2_end = 25;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_thk = 5;

// Screw hole pattern for motor plate
screw_pattern_size = 31;
screw_pattern_count = 4;

$fn = 64;

// Create the base plate
difference() {
    // Main block
    translate([-base_x_len / 2, 0, 0]) 
        cube([base_x_len, base_y_len, base_z_thk]);
    
    // Cut M4 holes
    for (i = [0 : 1]) {
        translate([
            i == 0 ? hole_m4_x : hole_m4_x2,
            hole_m4_y,
            0
        ]) 
            cylinder(h = base_z_thk + 1, d = m4_diameter);
    }
}

// Create the motor plate
difference() {
    // Main block
    translate([-motor_x_len / 2, 0, 0]) 
        cube([motor_x_len, motor_y_thk, motor_z_len]);
    
    // Cut boss hole (along Y axis)
    translate([0, -1, 28]) 
        cylinder(h = motor_y_thk + 2, d = boss_diameter);
    
    // Cut M3 screw holes (square pattern)
    for (i = [0 : screw_pattern_count - 1]) {
        // Calculate positions for 4 holes on a square pattern
        // Pattern is 31mm square, centred at x=0, z=28
        // Holes are at corners of the square
        let(
            offset = (screw_pattern_size - m3_diameter) / 2,
            pos_x = [
                i == 0 ? -offset : offset,
                i == 1 ? -offset : offset,
                i == 2 ? -offset : offset,
                i == 3 ? -offset : offset
            ],
            pos_z = [
                i == 0 ? 28 - offset : 28 + offset,
                i == 1 ? 28 - offset : 28 + offset,
                i == 2 ? 28 - offset : 28 + offset,
                i == 3 ? 28 - offset : 28 + offset
            ]
        ) {
            translate([pos_x[i], -1, pos_z[i]]) 
                cylinder(h = motor_y_thk + 2, d = m3_diameter);
        }
    }
}

// Create the gussets
// Left Gusset
difference() {
    // Right triangle in YZ plane, extruded along X
    // Right angle at y=5, z=5. Legs 20mm along +Y and +Z.
    // Vertices: (-25, 5, 5), (-20, 5, 5), (-20, 25, 5), (-20, 5, 25), (-25, 5, 5)
    // Wait, the description says "right-angle corner at y = 5, z = 5".
    // Legs 20mm along +Y and +Z.
    // So vertices are:
    // A: (-25, 5, 5) - corner
    // B: (-20, 5, 5) - along X? No, gusset is flush with left edge x=-25 to -20.
    // The gusset is a right triangle in the YZ plane.
    // Let's re-read: "flush with the left and right edges (x = -25 to -20 and x = 20 to 25)"
    // "each is a right triangle in the YZ plane with legs 20 mm along +Y and 20 mm along +Z"
    // "its right-angle corner at y = 5, z = 5"
    // So the triangle vertices in YZ are: (5, 5), (25, 5), (5, 25).
    // The gusset thickness is 5mm, spanning x from -25 to -20 (width 5).
    
    // Define the polygon for the YZ profile
    // Points: (y=5, z=5), (y=25, z=5), (y=5, z=25)
    // Extrude along X from -25 to -20
    
    translate([-25, 0, 0]) 
        linear_extrude(height = 5, center = false) 
            polygon([
                [5, 5],
                [25, 5],
                [5, 25]
            ]);
    
    // Cut out the space where the plates meet to avoid interference
    // The gusset should be solid, but we need to ensure it doesn't intersect the plates incorrectly
    // Actually, the gusset is added to the union of the plates.
    // We just need to make sure the gusset shape is correct.
    // The gusset sits on the base (y=0 to 5) and goes up (z=5 to 25).
    // The base is y=0 to 45. The motor plate is y=0 to 5.
    // The gusset starts at y=5? No, the right angle is at y=5, z=5.
    // So the gusset occupies y from 5 to 25 and z from 5 to 25?
    // Wait, "legs 20 mm along +Y and +Z".
    // If the corner is at (5, 5), then the legs go to (25, 5) and (5, 25).
    // So the gusset is in the region y >= 5, z >= 5.
    // This means it sits on top of the base (which is y=0 to 45, z=0 to 5) and next to the motor plate (y=0 to 5, z=0 to 50).
    // The gusset fills the corner between the base and the motor plate.
    // The base is at z=0 to 5. The motor plate is at y=0 to 5.
    // The gusset is at y=5 to 25, z=5 to 25.
    // This seems to be a support structure in the corner.
    
    // Let's re-evaluate the geometry.
    // Base: x=-25 to 25, y=0 to 45, z=0 to 5.
    // Motor: x=-25 to 25, y=0 to 5, z=0 to 50.
    // Gusset: x=-25 to -20.
    // Triangle in YZ plane. Right angle at y=5, z=5.
    // Legs 20mm along +Y and +Z.
    // So vertices: (y=5, z=5), (y=25, z=5), (y=5, z=25).
    // This triangle is in the region y >= 5, z >= 5.
    // It sits on the base (z=0 to 5) and next to the motor plate (y=0 to 5).
    // The gusset is effectively a wedge that fills the corner.
    // It connects the base (at z=5) and the motor plate (at y=5).
    // Wait, the base is z=