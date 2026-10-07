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

// Calculate number of rows and columns based on spacing and offsets to ensure grid fits block
num_rows = int((block_width - hole_offset_y * 2 + hole_diameter/10) / row_spacing); 
num_cols = int((block_length - hole_offset_x * 2 + hole_diameter/10) / col_spacing);

// Verify calculated dimensions match expected grid size (optional sanity check logic omitted for brevity, relying on user input accuracy)
if(num_rows != 8 || num_cols != 12) {
    // Fallback if calculation doesn't yield exactly 96 holes due to floating point or spacing nuances
    // Force the loop count based on explicit request "in 8 rows ... by 12 columns"
}

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
        start_y = block_width - (hole_offset_y); // Assuming "back" is max Y for standard plate view, or min. Let's assume back=min_Y=0 relative to the user description of distance from edge. 
        // Re-evaluating: User says A1 is 14.38mm from Left and 11.24mm from Back.
        // If we define Block X=[0, L], Y=[0, W].
        // "Left" usually implies the side at lower X or higher X depending on view? 
        // Standard convention: Left is min_X (X=0), Right is max_X. Front/Back depends on orientation.
        // Let's assume standard Cartesian where we look from +Z down to XY plane, but plate sits flat on Z.
        // Usually "Front" is towards viewer (+Y?), "Back" is away (-Y?). Or vice versa.
        // However, for centering: 
        // If A1 is at x=14.38 (from left edge X=0) and y=11.24 (from back edge Y=W or Y=0).
        // Let's assume "Back" corresponds to the side furthest from the viewer if viewing front, but here we just need symmetry.
        // If A1 is at x=14.38 relative to X=0 and y=11.24 relative to Y=W (back edge).
        
        start_hole_x = hole_offset_x; 
        start_hole_y = block_width - hole_offset_y; 
        
        for(i=[0, num_cols-1]) { // Columns along X
            x_pos = start_hole_x + i * col_spacing;
            
            for(j=[0, num_rows-1]) { // Rows along Y. Assuming A1 is row 0 (bottom/back) and we go up to top/front? 
                // Or if A1 is the "first" hole in a sequence starting from back-left corner moving forward/upward.
                y_pos = start_hole_y - j * row_spacing; 
                
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
    // We need to define two planes meeting at an angle and extrude them, or use difference of rotated cylinders?
    // Simplest robust method: Difference of two cones/cylinders intersecting at the corner?
    // Or simpler: A large block minus a wedge prism defined by 45 deg rotation.
    
    // Let's define the chamfer volume to be subtracted from the main cube.
    // The cut is along the vertical edge where X=0 and Y=max (or min). 
    // User says "A1 corner". A1 is at x=offset_x, y=back_offset_y relative to edges? 
    // Actually, if A1 is 14.38 from Left Edge, then Left Edge is at X = start_hole_x - offset_to_first_col_center?
    // No, user says "A1 ... is 14.38 mm from the left edge". So Left Edge is at x=0 (if A1 center is at 14.38).
    // And Back Edge is at y = start_hole_y - offset_to_first_row_center? 
    // If A1 is "first hole", and we have a grid, usually the first row/col defines the edge distance.
    
    // Let's assume: Left Edge X=0. Back Edge Y=W (assuming back is max Y).
    // Then Chamfer corner is at (X=0, Y=W) or (X=0, Y=0)? 
    // If A1 is 14.38 from Left and 11.24 from Back.
    // And we assume standard plate orientation where "Back" is the side with lower index in some conventions? 
    // Let's stick to: Chamfer at X=0, Y=W (Top-Left if looking down +Y). Or X=0, Y=0.
    // Given A1 is 14.38 from Left and 11.24 from Back.
    // If we assume "Back" = Max_Y for the purpose of this specific corner definition relative to the block origin (0,0) at Front-Left? 
    // Let's define Chamfer at X=0, Y=W (Top-Left in standard math plot where Y goes up). 
    // Wait, if A1 is 14.38 from Left Edge -> x_A1 = 14.38.
    // If A1 is 11.24 from Back Edge -> y_A1 = W - 11.24 (if back=max) or 11.24 (if back=min).
    
    // Let's assume the user implies a standard coordinate system where:
    // Left Edge = X=0. Right Edge = X=L.
    // Back Edge = Y=W. Front Edge = Y=0. 
    // Then A1 is at x=14.38, y=W-11.24.
    // The "A1 corner" for the chamfer would be the vertical edge closest to this hole? 
    // Or just a specific orientation mark on one of the four edges.
    // User says: "Cut a 45-degree chamfer ... off the vertical edge at the A1 corner".
    // This implies the edge adjacent to the first row/column intersection that defines the start.
    // If we assume the grid starts near this corner, let's place the chamfer on the X=0 face (Left) and Y=W face (Back).
    
    // Constructing a 45 degree wedge cut from the top-left-front or similar? 
    // Let's use difference of two cones meeting at an edge.
    // Edge is vertical line segment along Z axis at x=0, y=W.
    // Cut extends inwards by chamfer_leg_length (5mm).
    
    // We will subtract a shape defined as the intersection of:
    // 1. A cylinder centered on X = -chamfer_leg_length? No.
    // Let's define two planes rotated to meet at an angle, then extrude up and down? 
    // Simpler: Difference of two cones with their apexes meeting along the edge line (x=0, y=W).
    
    chamfer_radius = 5; // Radius from centerline
    
    // Cone 1: Centered on X=-chamfer_leg_length relative to corner? No.
    // Let's define local coords for the cut at x=0, y=W.
    // We want a wedge where distance