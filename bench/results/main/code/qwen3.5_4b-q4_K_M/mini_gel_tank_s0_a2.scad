// Buffer tank for mini horizontal gel-electrophoresis box
$fn = 64; // Polygon resolution for smooth curves/holes and round holes

// --- Dimensions (measured with calipers) ---
outer_width_x = 120;   // X dimension in mm
inner_height_y = 70;   // Y dimension in mm
tank_depth_z = 40;     // Z depth of tank in mm

wall_thickness = 3;    // Thickness of walls/floor in mm
floor_thickness = wall_thickness; // Floor is part of the structure, same thickness as walls

// Platform dimensions (measured with calipers)
platform_length_x = 60;   // Length along X axis in mm
platform_z_offset_from_floor = 13; // Height of top surface above floor (z=13 relative to bottom face)

// Electrode hole specifications
hole_diameter = 2;        // Diameter in mm
electrode_height_z = 30; // Z position for the horizontal cut through side walls

// --- Geometry Calculations ---
tank_inner_width_y = inner_height_y - (wall_thickness * 2); // Inner width available inside tank

// Platform dimensions relative to outer box center
platform_outer_length_x = platform_length_x + wall_thickness * 2; 

// --- Modules ---

module build_tank_body() {
    // Create a hollow rectangular box (open top) with walls of 'wall_thickness'
    
    translate([0, -inner_height_y/2, 0]) {
        difference() {
            cube([outer_width_x, inner_height_y, tank_depth_z + wall_thickness], center=false);
            
            // Cut out the inner volume to create walls/floor. 
            // Inner void starts at Z = floor_thickness (bottom of liquid chamber) and goes up to top rim.
            i_w = outer_width_x - (wall_thickness * 2); 
            i_h = tank_inner_width_y; 
            i_z = tank_depth_z + wall_thickness - floor_thickness; 
            
            cube([i_w, i_h, i_z], center=false); 
        }
    }
}

module build_platform() {
    // Platform is solid raised block in the middle of the bottom chamber(s).
    // It spans full inner width (Y), length 60mm along X.
    // Top surface at z = tank_depth_z + wall_thickness - floor_thickness? 
    // Prompt says: "top is 10 mm above the inner floor". Inner floor is effectively the base of the chamber.
    // If we consider the bottom face of the assembly as Z=0, then inner floor plane for liquid is at Z = wall_thickness (assuming walls hold liquid up to this level).
    // So Platform Top should be at Z = 13 + wall_thickness? 
    // Wait, prompt says "top is ... above the inner floor". If Inner Floor is the bottom-most surface inside (Z=wall_thickness), then top is at Z=23.
    // HOWEVER, looking at standard lab trays: The gel tray sits on a base plate which might be lower than the tank walls? 
    // Or maybe "inner floor" refers to the very bottom of the chamber where liquid collects if not covered by platform.
    // Let's re-read carefully: "top is 10 mm above the inner floor (at z = 13)".
    // This phrasing "(at z=13)" likely defines the absolute Z coordinate of the top surface in the user's mental model or measurement reference frame where Z=0 is the bottom.
    // If Top is at Z=13, and it is 10mm above Inner Floor -> Inner Floor must be at Z = 13 - 10 = 3mm.
    // This matches perfectly with a 3mm thick wall/floor starting from the bottom (Z=0). 
    // So: Bottom of tank = Z=0. Top of inner floor surface = Z=3. Platform top = Z=13.
    
    translate([-(platform_length_x/2), -(tank_inner_width_y)/2, 3]) { 
        cube( [outer_width_x - (wall_thickness * 2) + wall_thickness*2, // Width matches inner width? No, platform is solid block inside.
               tank_inner_width_y, 
               platform_z_offset_from_floor], center=false );
        
    }

}

module build_electrode_hole() {
    
    // Left side hole at X = outer_width_x/2 - wall_thickness (inner edge), Y=centered on inner width, Z=30
    
    translate([outer_width_x/2 - 1.5 * (hole_diameter) + wall_thickness, 
               -(tank_inner_width_y / 2), 
               electrode_height_z]) { // Adjusted to ensure hole is centered in the side wall thickness and at correct height
        
        cylinder(h = tank_depth_z + wall_thickness - floor_thickness, r=hole_diameter/2);
        
    }

}


// Main build sequence: Tank body -> Platform (difference) -> Electrode holes (difference)
build_tank_body(); // Build the main rectangular box with walls and open top
translate([0, 0, tank_depth_z + wall_thickness - floor_thickness]) { 
    difference() {
        union() {
            build_platform(); // Add platform as a solid block
            
            translate([-outer_width_x/2 + hole_diameter/2 + wall_thickness, -(tank_inner_width_y / 2), electrode_height_z]) {
                cylinder(h = tank_depth_z + wall_thickness - floor_thickness, r=hole_diameter/2);
                
            }

        }, 
    // Cut out the electrode holes from both sides of the tank body
    
}


// Finalize: Ensure all parts are properly positioned and assembled in a single solid object.