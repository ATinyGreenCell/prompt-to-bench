// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Dimensions in millimetres

// Block Dimensions
block_length = 106;  // X
block_width = 72;    // Y
block_height = 30;   // Z

// Hole Grid Dimensions
hole_spacing_x = 16; // Centre-to-centre distance along X
hole_spacing_y = 16; // Centre-to-centre distance along Y

// Hole Dimensions
hole_diameter = 11.2;
hole_depth = 25;
hole_floor_thickness = 5;

// Derived Dimensions
hole_radius = hole_diameter / 2;
hole_floor_height = block_height - hole_depth - hole_floor_thickness;

// Grid Configuration
rows = 4;
cols = 6;

$fn = 64;

module rack() {
    union() {
        // Main Block
        cube([block_length, block_width, block_height], center=true);
        
        // Vertical Holes
        for (x = [-(cols-1)/2 : 1 : (cols-1)/2]) {
            for (y = [-(rows-1)/2 : 1 : (rows-1)/2]) {
                translate([x * hole_spacing_x, y * hole_spacing_y, 0]) {
                    // Hole cutout
                    cylinder(h = hole_depth + 1, r = hole_radius, center=false);
                    
                    // Bottom Floor Cutout (to create the 5mm floor)
                    // We cut a small cylinder slightly deeper than the hole to remove the bottom material
                    translate([0, 0, hole_floor_height]) {
                        cylinder(h = 1.1, r = hole_radius, center=false);
                    }
                }
            }
        }
    }
}

rack();