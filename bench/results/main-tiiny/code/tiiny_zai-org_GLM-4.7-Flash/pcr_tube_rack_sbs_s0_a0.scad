// 96-Well PCR Tube Rack
// Dimensions based on ANSI/SLAS standard microplate footprint
// Units: mm

// --- Physical Dimensions ---
block_length_x = 127.76;  // Length of the rack
block_width_y = 85.48;    // Width of the rack
block_height_z = 20.00;   // Height of the rack

// --- Hole Geometry ---
hole_diameter = 6.20;     // Diameter of the 0.2 mL PCR tube hole
hole_spacing_x = 9.00;    // Center-to-center distance along X (Columns)
hole_spacing_y = 9.00;    // Center-to-center distance along Y (Rows)

// --- Positioning of the Grid ---
// Distance from the left edge of the block to the center of the A1 hole (Column 1, Row 1)
grid_offset_x = 14.38;    
// Distance from the back edge of the block to the center of the A1 hole (Column 1, Row 1)
grid_offset_y = 11.24;    

// --- Chamfer Geometry ---
chamfer_length = 5.00;    // Length of the chamfer leg
chamfer_angle = 45;       // Angle of the chamfer

// --- Rendering Settings ---
$fn = 64;                 // High resolution for curved surfaces

// --- Main Module ---
module pcr_rack() {
    union() {
        // 1. The main block body
        cube([block_length_x, block_width_y, block_height_z], center=true);
        
        // 2. The 96 vertical through-holes
        // We iterate through 12 columns (X) and 8 rows (Y)
        for (col = [0 : 11]) {
            for (row = [0 : 7]) {
                // Calculate center position for this hole
                let(x_pos = grid_offset_x + (col * hole_spacing_x),
                    y_pos = grid_offset_y + (row * hole_spacing_y)) {
                    
                    translate([x_pos, y_pos, 0]) {
                        cylinder(h = block_height_z + 1, d = hole_diameter, center = true);
                    }
                }
            }
        }
        
        // 3. The 45-degree chamfer at the A1 corner
        // A1 is at (grid_offset_x, grid_offset_y). 
        // We cut a shape that extends slightly beyond the block to ensure clean separation.
        let(chamfer_x = grid_offset_x - 0.1,
             chamfer_y = grid_offset_y - 0.1) {
            
            translate([chamfer_x, chamfer_y, 0]) {
                // Create a chamfered corner shape
                // It is a square rotated 45 degrees, then extruded
                rotate([0, 0, chamfer_angle]) {
                    square([chamfer_length, chamfer_length], center=true);
                }
            }
        }
    }
}

// Render the part
pcr_rack();