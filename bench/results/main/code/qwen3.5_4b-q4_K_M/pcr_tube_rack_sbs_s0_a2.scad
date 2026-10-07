// Dimensions for standard microplate (ANSI/SLAS) footprint and PCR tube rack
block_length = 127.76; // Length along X axis in mm
block_width = 85.48;   // Width along Y axis in mm
block_height = 20;     // Height of the block in mm

hole_diameter = 6.2;   // Diameter of through-holes in mm
row_spacing = 9.0;     // Centre-to-centre spacing between rows (Y) in mm
col_spacing = 9.0;     // Centre-to-centre spacing between columns (X) in mm

hole_offset_x = 14.38; // X offset of the first hole from left edge in mm
hole_offset_y = 11.24; // Y offset of the first hole from back edge in mm

chamfer_leg_length = 5; // Length of chamfer legs in mm (legs are equal)
chamfer_angle_degrees = 45; // Angle of chamfer in degrees

// Calculate number of rows and columns based on spacing to ensure grid fits block
num_rows = int((block_width - hole_offset_y * 2 + hole_diameter/10) / row_spacing); 
num_cols = int((block_length - hole_offset_x * 2 + hole_diameter/10) / col_spacing);

// Define the main block geometry
module make_block() {
    cube([block_length, block_width, block_height]);
}

// Function to create a single hole with chamfered edges if needed
function get_hole(x_pos, y_pos) = 
    cylinder(h=block_height+0.1, r=hole_diameter/2); // +0.1mm extension for difference operation stability

// Generate the grid of holes using loops
module make_holes() {
    union() {
        // Calculate starting positions based on offsets and spacing
        start_x = hole_offset_x; 
        start_y = block_width - (hole_offset_y); 
        
        for(i=[0, num_cols-1]) { // Columns along X
            x_pos = start_x + i * col_spacing;
            
            for(j=[0, num_rows-1]) { // Rows along Y. Assuming A1 is row 0 and we go up to top/front? 
                y_pos = start_y - j * row_spacing; 
                
                translate([x_pos, y_pos]) {
                    get_hole(x_pos, y_pos);
                }
            }
        }
    }
}

// Create the chamfer at the A1 corner (Bottom-Left or Top-Right depending on Y definition)
module make_chamfer() {
    // Chamfer is 45 degrees with 5mm legs. 
    // This creates a wedge shape cut from the vertical edge.
    
    // We will subtract two cones meeting at an angle along the corner edge (X=0, Y=max).
    // The intersection of these two cones forms the chamfered volume to be removed.
    
    chamfer_radius = 5; 
    
    cone1 = rotate([-45*360/90, -45*360/90]) { 
        cylinder(h=block_height+2*rchamfer_length, r=rchamfer_length); // Radius is leg length for square chamfer
    };

    translate([0, block_width + 1.0]) cone1; // Shift to align with corner edge
    
}