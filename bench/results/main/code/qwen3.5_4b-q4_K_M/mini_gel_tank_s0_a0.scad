// Buffer tank dimensions and parameters
$fn = 64; // Polygon resolution for smooth curves/holes

// Outer dimensions (measured with calipers)
outer_width_x = 120;   // X dimension in mm
inner_height_y = 70;   // Y dimension in mm
tank_depth_z = 40;     // Z depth of tank in mm

// Wall and floor thicknesses
wall_thickness = 3;    // Thickness of walls/floor in mm
floor_thickness = 3;   // Floor is part of the wall structure, so same as wall

// Platform dimensions (measured with calipers)
platform_length_x = 60;     // Length along X axis in mm
platform_width_y_inner = inner_height_y - 2 * wall_thickness;       // Inner width available for platform
platform_z_offset_from_floor = 13;   // Height of top surface above floor (z=13)

// Electrode hole specifications
hole_diameter = 2;         // Diameter in mm
hole_position_x_start = outer_width_x / 2 - wall_thickness + 0.5 * hole_diameter; // Start X for left end
hole_position_y = inner_height_y / 2 - (wall_thickness/2);                   // Y position at center of side walls

// Variables to define the tank geometry clearly
tank_outer_radius_left = outer_width_x / 2;   // Radius from origin to left edge
tank_inner_radius_right = outer_width_x / 2 + wall_thickness; // Inner radius on right (for symmetry)

// Define the main rectangular block for the tank body
module build_tank_body() {
    translate([0, -inner_height_y/2, 0]) {
        cube( [outer_width_x, inner_height_y, tank_depth_z], center=false ); // Base rectangle
        
        // Extrude walls up from base to create box shape (open top)
        linear_extrude(height = tank_depth_z + wall_thickness - floor_thickness, 
                       angle=0) {
            polygon(points=[[outer_width_x/2, inner_height_y/2], [inner_height_y/2, outer_width_x/2]]) // Right side corner for extrusion logic if needed
            
        }

    }
}

// Define the raised platform module (solid block in center of tank bottom)
module build_platform() {
    translate([0, -platform_width_y_inner/2, 13]) { // Position at z=13 relative to floor level
        cube( [tank_depth_z + wall_thickness, 
               inner_height_y - 2 * (wall_thickness), 
               platform_length_x], center=false );
        
    }

}

// Define electrode hole module for each end wall
module build_electrode_hole() {
    
    // Left side hole at X = outer_width_x/2, Y=centered on inner width, Z=30
    translate([outer_width_x/2 - 1.5 * (hole_diameter), 
               -(inner_height_y / 2) + wall_thickness, 
               30]) { // Adjusted to ensure hole is centered in the side wall thickness and at correct height
        
        cylinder(h = tank_depth_z + wall_thickness - floor_thickness, r=hole_diameter/2);
        
    }

}

// Define right side electrode hole (symmetric)
module build_right_electrode_hole() {
    
    // Right side hole at X=-outer_width_x/2, Y=centered on inner width, Z=30
    
    translate([-outer_width_x/2 + 1.5 * (hole_diameter), 
               -(inner_height_y / 2) - wall_thickness, 
               30]) { // Adjusted to ensure hole is centered in the side wall thickness and at correct height
        
        cylinder(h = tank_depth_z + wall_thickness - floor_thickness, r=hole_diameter/2);
        
    }

}


// Main build sequence: Tank body -> Platform (difference) -> Electrode holes (difference)
build_tank_body(); // Build the main rectangular box with walls and open top
translate([0, 0, tank_depth_z + wall_thickness - floor_thickness]) { 
    difference() {
        union() {
            build_platform(); // Add platform as a solid block
            
            translate([-outer_width_x/2 + hole_diameter/2, -(inner_height_y / 2) - (wall_thickness), 30]) {
                cylinder(h = tank_depth_z + wall_thickness - floor_thickness, r=hole_diameter/2);
                
            }

        }, 
    // Cut out the electrode holes from both sides of the tank body
    
}


// Finalize: Ensure all parts are properly positioned and assembled in a single solid object.