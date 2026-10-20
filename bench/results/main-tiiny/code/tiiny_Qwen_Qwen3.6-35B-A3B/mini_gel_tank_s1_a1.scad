// Buffer tank for mini horizontal gel-electrophoresis box
// Dimensions in mm

// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Platform dimensions
platform_length = 60;
platform_height_above_inner_floor = 10;
// Platform spans full inner width (Y)

// Electrode hole
hole_diameter = 2;
hole_z = 30;
hole_y = 0;

// Derived dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;

// Platform top Z position relative to global origin
// Floor is at z=0, floor thickness is 3. Inner floor is at z=3.
// Platform top is 10mm above inner floor.
platform_top_z = floor_thickness + platform_height_above_inner_floor; // 13 mm

// Platform half-length in X
platform_half_x = platform_length / 2;

// Hole radius
hole_radius = hole_diameter / 2;

// Extrusion depth for cutting holes (must extend past faces)
cut_depth = 1.0;

// Build the part
difference() {
    // Main tank body (outer shell)
    // Centered on X, Y. Resting on Z=0.
    // To center on X/Y, we translate the cube.
    // Outer X: 0 to 120. Center X: 60.
    // Outer Y: 0 to 70. Center Y: 35.
    // Outer Z: 0 to 40.
    
    // Let's build it directly at the correct position to avoid translation confusion.
    // The prompt says "centre it on the origin in X and Y".
    // So X goes from -60 to 60. Y goes from -35 to 35.
    
    // Re-defining coordinates based on centering at origin (0,0)
    // Outer Box
    translate([0, 0, 0]) {
        cube([outer_x, outer_y, outer_z], center = true);
    }

    // Subtract inner cavity
    // Inner cavity starts at z = floor_thickness (3mm)
    // Inner dimensions:
    // X: -inner_x/2 to inner_x/2
    // Y: -inner_y/2 to inner_y/2
    // Z: floor_thickness to outer_z (open top)
    
    translate([0, 0, floor_thickness]) {
        cube([inner_x, inner_y, outer_z - floor_thickness], center = true);
    }

    // Subtract the platform
    // Platform sits on inner floor (z = floor_thickness)
    // Platform top is at z = platform_top_z (13mm)
    // Platform length is 60mm in X, centered.
    // Platform spans full inner width in Y.
    
    translate([0, 0, floor_thickness]) {
        cube([platform_length, inner_y, platform_top_z - floor_thickness], center = true);
    }

    // Drill electrode holes
    // Hole is at y = 0, z = hole_z (30mm)
    // Hole goes through the end walls.
    // The walls are at X = -outer_x/2 and X = outer_x/2.
    // We need to cut a cylinder through the solid at these locations.
    // However, the hole is "horizontal along X".
    // This implies the hole axis is parallel to X? 
    // "drill a 2 mm diameter horizontal hole along X ... for the electrode wires"
    // Usually, wires come out from the sides. If the hole is "along X", it might mean the hole is oriented in the X direction?
    // No, "along X" usually describes the position or the axis. 
    // If it's a hole *for* wires, and it's in the end wall, the hole axis is perpendicular to the end wall.
    // The end walls are at the X ends. So the hole axis is along X.
    // So we drill a cylinder with its axis parallel to the X-axis.
    
    // Left hole (at X = -outer_x/2)
    // Center of hole in X: -outer_x/2
    // Center of hole in Y: 0
    // Center of hole in Z: 30
    
    // Right hole (at X = outer_x/2)
    // Center of hole in X: outer_x/2
    // Center of hole in Y: 0
    // Center of hole in Z: 30
    
    // We use a cylinder oriented along X.
    // OpenSCAD cylinder is along Z by default. We rotate it.
    
    // Left Hole
    translate([-outer_x / 2, hole_y, hole_z]) {
        $fn = 64;
        rotate([90, 0, 0]) {
            cylinder(
                d = hole_diameter + 0.02, // Slightly larger to ensure cut
                h = outer_x + cut_depth, // Long enough to cut through
                center = true
            );
        }
    }

    // Right Hole
    translate([outer_x / 2, hole_y, hole_z]) {
        $fn = 64;
        rotate([90, 0, 0]) {
            cylinder(
                d = hole_diameter + 0.02,
                h = outer_x + cut_depth,
                center = true
            );
        }
    }
}