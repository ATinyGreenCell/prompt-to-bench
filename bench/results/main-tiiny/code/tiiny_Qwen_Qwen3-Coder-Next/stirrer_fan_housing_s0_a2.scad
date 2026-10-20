// DIY Magnetic Stirrer Housing
// Dimensions in mm

// Parameters
outer_size = 90;           // Outer X/Y size of the housing
wall_thickness = 2.5;      // Wall thickness
top_thickness = 2;         // Top plate thickness
height = 40;               // Total height (from top plate to open top)
hole_pattern = 71.5;       // Screw hole pattern square size
hole_diameter = 4.5;       // Screw hole diameter
notch_width = 12;          // Power cable notch width
notch_depth = 8;           // Notch depth from top (40 - 32 = 8)
notch_height_start = 32;   // Notch starts at z = 32

// Set resolution for curves
$fn = 64;

// Calculate inner dimensions
inner_size = outer_size - 2 * wall_thickness;

// Base plate (top plate in use, printed flat at z=0)
module base_plate() {
    size = outer_size;
    translate([-(size/2), -(size/2), 0]) {
        cube([size, size, top_thickness]);
    }
}

// Walls
module walls() {
    // Front wall (Y+ side)
    translate([-(outer_size/2), (outer_size/2) - wall_thickness, top_thickness]) {
        cube([outer_size, wall_thickness, height - top_thickness]);
    }
    
    // Back wall (Y- side)
    translate([-(outer_size/2), -(outer_size/2), top_thickness]) {
        cube([outer_size, wall_thickness, height - top_thickness]);
    }
    
    // Left wall (X- side)
    translate([-(outer_size/2), -(outer_size/2), top_thickness]) {
        cube([wall_thickness, outer_size, height - top_thickness]);
    }
    
    // Right wall (X+ side)
    translate([(outer_size/2) - wall_thickness, -(outer_size/2), top_thickness]) {
        cube([wall_thickness, outer_size, height - top_thickness]);
    }
}

// Screw holes (4.5mm for M4 screws) - only through top plate
module screw_holes() {
    half_pattern = hole_pattern / 2;
    hole_radius = hole_diameter / 2;
    
    // Positions of the four holes relative to center
    positions = [
        [half_pattern, half_pattern],
        [half_pattern, -half_pattern],
        [-half_pattern, half_pattern],
        [-half_pattern, -half_pattern]
    ];
    
    for (i = [0:3]) {
        translate([positions[i][0], positions[i][1], -0.01]) {
            cylinder(h = top_thickness + 0.02, r = hole_radius);
        }
    }
}

// Power cable notch - only in front wall
module notch() {
    // Notch in the front wall (Y+ side)
    // Centered along the wall (X direction), 12mm wide
    // Extends from z = 32 to z = 40 (height - notch_depth to height)
    translate([-(notch_width/2), (outer_size/2) - wall_thickness + 0.01, notch_height_start]) {
        cube([notch_width, wall_thickness + 0.02, height - notch_height_start + 0.01]);
    }
}

// Assemble the housing
module housing() {
    union() {
        // Base plate
        base_plate();
        
        // Walls
        walls();
        
        // Subtract screw holes (only through top plate)
        translate([0, 0, 0]) {
            screw_holes();
        }
        
        // Subtract notch
        notch();
    }
}

// Build the housing
housing();