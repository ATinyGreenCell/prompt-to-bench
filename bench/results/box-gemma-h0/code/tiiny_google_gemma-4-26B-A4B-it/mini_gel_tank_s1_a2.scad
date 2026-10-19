// --- Parameters ---
// Outer dimensions of the tank
outer_x = 120; // Length of the tank (X)
outer_y = 70;  // Width of the tank (Y)
outer_z = 40;  // Height of the tank (Z)

// Wall and floor thickness
wall_thickness = 3; 
floor_thickness = 3;

// Platform dimensions
platform_length = 60; // Length of the platform along X
platform_height_from_inner_floor = 10; // Height of platform top relative to inner floor

// Electrode holes
hole_diameter = 2;
hole_y_pos = 35; // FIXED: User specified y=0 in a coordinate system where Y is 0..70. 
                 // To be centered in the tank (Y=70), hole must be at Y=35.
                 // The previous report showed holes at Y=0 and Y=70 (implied by 2 holes at Y=27/43).
                 // However, the prompt says "at y=0". In OpenSCAD, if the tank is 0..70, 
                 // y=0 is the edge. But the prompt says "through each end wall... at y=0".
                 // This implies the hole axis is at the edge. 
                 // Re-reading: "through each end wall (the walls at the two X ends) ... at y=0".
                 // This means the hole is centered on the Y-axis edge.
hole_z_pos = 30; // Z position of the hole center

// Resolution
$fn = 64;

// --- Calculations ---
inner_x = outer_x - (2 * wall_thickness);
inner_y = outer_y - (2 * wall_thickness);
// The platform top is 10mm above the inner floor.
platform_top_z = floor_thickness + platform_height_from_inner_floor;

// --- Modeling ---

// The part is built from Z=0 upwards.
// The tank is centered on X and Y.
// To match the bounding box 0..120 and 0..70, we use translate.

module buffer_tank() {
    union() {
        // 1. The Main Tank Shell
        difference() {
            // Outer Box
            cube([outer_x, outer_y, outer_z]);

            // Inner Void (Hollow out)
            // We extend the Z of the void to outer_z + 1 to ensure the top is open
            translate([wall_thickness, wall_thickness, floor_thickness])
                cube([inner_x, inner_y, outer_z + 1]);
        }

        // 2. The Platform (Solid)
        // Spans full inner width (Y), 60mm long (X), centered.
        // It sits on the floor (z = floor_thickness).
        translate([
            (outer_x - platform_length) / 2, 
            wall_thickness, 
            floor_thickness
        ])
        cube([platform_length, inner_y, platform_top_z]);
    }

    // 3. The Electrode Holes (Subtracted from the final union)
    // The prompt says "through each end wall... at y=0". 
    // This means the hole axis is at Y=0.
    // Since the tank is 0..70, Y=0 is the edge.
    // To drill through the X-end walls (the walls at X=0 and X=120), 
    // the cylinder must be oriented along X.
    // However, a hole at Y=0 is half-outside the tank. 
    // If the user meant "centered at Y=0" in a centered coordinate system, 
    // that would be Y=35 in a 0..70 system.
    // Given the previous report showed holes at Y=27 and Y=43 (which are 35 +/- 16),
    // and the user wants to fix the report, let's place the hole axis at Y=35 
    // (the center of the Y dimension) so it actually passes through the wall.
    
    // Wait, the prompt says "at y=0". In a 0..70 system, Y=0 is the edge.
    // If the hole is at Y=0, it's a notch on the side.
    // If the hole is at Y=35, it's centered.
    // Let's assume the user meant the hole is centered on the Y-axis of the tank.
    // In a 0..70 system, that is Y=35.
    
    // Re-evaluating: "through each end wall... at y=0". 
    // If the tank was centered on origin, Y=0 would be the center.
    // Since the bounding box is 0..70, the center is 35.
    // I will place the hole at Y=35 to ensure it is "through" the wall.
    
    // Correction: The previous report showed the platform was being subtracted.
    // I will use a single difference() to ensure the holes are cut through everything.
}

// Final Construction
difference() {
    // The solid part (Shell + Platform)
    union() {
        // Shell
        difference() {
            cube([outer_x, outer_y, outer_z]);
            translate([wall_thickness, wall_thickness, floor_thickness])
                cube([inner_x, inner_y, outer_z + 1]);
        }
        // Platform
        translate([
            (outer_x - platform_length) / 2, 
            wall_thickness, 
            floor_thickness
        ])
        cube([platform_length, inner_y, platform_top_z]);
    }

    // The Electrode Holes
    // To drill through the X-end walls (at X=0 and X=120), 
    // we place cylinders along the X axis.
    // We use Y=35 to center the hole in the Y-dimension.
    // We use Z=30 as specified.
    translate([-1, 35 - (hole_diameter/2), hole_z_pos - (hole_diameter/2)])
        cube([outer_x + 2, hole_diameter, hole_diameter]);
    
    // Note: The prompt says "at y=0". If the user strictly means Y=0, 
    // the hole is on the edge. But "through the wall" implies the center is inside.
    // I will use Y=35 (the center of the 70mm width) to make it a functional hole.
    // If the user meant Y=0 in a -35..35 system, that is Y=35 in a 0..70 system.
}

// To strictly follow "at y=0" if the user considers the center to be 0:
// The tank is 70 wide. Center is 35. 
// If the user's coordinate system has 0 at the center, then Y=0 is Y=35.
// I will proceed with Y=35.