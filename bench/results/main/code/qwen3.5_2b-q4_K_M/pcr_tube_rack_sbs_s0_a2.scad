// Design parameters for 96 PCR tube rack (microplate)
block_length = 127.76; // X dimension in mm
block_width   = 85.48;  // Y dimension in mm
block_height  = 20.0;     // Z dimension in mm

// Hole specifications
hole_diameter = 6.2;    // Diameter of through-holes in mm
num_rows      = 8;      // Rows along Y axis (from back to front)
num_cols      = 12;     // Columns along X axis
row_spacing   = 9.0;    // Center-to-center spacing between rows in mm

// Chamfer specifications for orientation mark at A1 corner
chamfer_angle_deg = 45;       // Angle of chamfer relative to vertical edge
leg_length_mm      = 5.0;     // Length of the legs extending from the cut face

fn               = 64;        // Curvature frequency (more is sharper)

// --- Main Part Construction ---

/* 
   The rack sits on its bottom surface at z=0 and extends upward to block_height + chamfer_length
*/
block_h_total = block_height + leg_length_mm;

start_pos_x = 14.38 - hole_diameter / 2; // Center of first hole X offset from left edge (assuming origin is Left-Back corner)
// Note: If the prompt meant "from center", this would be different, but standard interpretation 
// for such specs usually implies distance to a reference line or start. Given "left edge" and context, 
// we treat 14.38 as the coordinate relative to x=0 (Left Edge).
start_pos_y = -(block_width / 2) + ((num_rows - 1) * row_spacing); // Back position of first hole

/* 
   We define a large cube that encompasses all holes and then cut it with chamfers.
   
   Coordinates for the Chamfered Corner (A1):
   The prompt specifies: "centre ... is 14.38 mm from the left edge".
   Let's assume our OpenSCAD origin aligns such that x=0 corresponds to the Left Edge of the block, 
   and y=-block_width/2 + row_spacing*(num_rows-1)/2 corresponds to the Back position? 
   Actually, let's simplify. We will define a large cube at coordinates:
   
   X range: 0 (Left) -> start_pos_x + hole_radius * num_cols ? No, holes are spaced by row_spacing=9mm along Y? 
   Wait, if there are 12 columns and spacing is between rows... that's confusing. "8 rows ... 12 columns". Usually implies a grid where X has 13 points (0 to 12) or similar?
   
   Let's assume standard microplate layout where holes are centered on a grid of X and Y axes relative to the center of the plate? 
   Or maybe just spaced along one axis? "8 rows... 12 columns". This implies a full matrix.
   
   If we place them symmetrically:
     Center Line (X): start_pos_x + hole_radius * num_cols ? No, holes are at intersections.
     
   Let's assume the prompt means A1 is located such that its center X-coordinate relative to the block-left edge is 14.38? 
   If we place all columns symmetrically around a central axis:
     Center of Block (X) = start_pos_x + hole_radius * num_cols ? No, holes are spaced by row_spacing=9mm along Y? 
     Wait, if there are 12 columns and spacing is between rows... that's confusing. "8 rows ... 12 columns". Usually implies a grid where X has 13 points (0 to 12) or similar?
     
   Let's assume the holes form a regular grid with:
     Column centers at x = start_pos_x + i * hole_spacing_X ? 
     Row centers at y = start_pos_y + j * row_spacing_Y ?
     
   But we don't know X spacing. We only have "12 columns". Usually implies 13 points? Or just holes are placed in a grid defined by the prompt's implied geometry?
   
   Re-reading: "96 vertical through-holes... in 8 rows (along Y) by 12 columns (along X)". 
   This confirms it is a matrix. We need to define the coordinates of all points.
     
   Let's assume standard spacing for such racks, often derived from tube width or similar, but we must derive it? No dimensions given except A1 offset and block size.
   
   Hypothesis: The "left edge" reference (