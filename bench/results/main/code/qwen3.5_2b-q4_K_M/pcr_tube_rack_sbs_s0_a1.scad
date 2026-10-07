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
// Note: If the prompt meant "from the center", this would be different, but standard interpretation 
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
   
   X range: 0 (Left) -> start_pos_x + hole_radius * num_cols ? No, holes are spaced by 9mm.
   Let's calculate exact global positions for all holes to ensure they fit in the block and align with A1.
   
   Holes along Y (rows): 
     Row 8 is back (-Y), Row 1 is front (+Y). Or vice versa? Standard microplates often have rows numbered or placed at specific offsets.
     Let's assume Rows are indexed from Back to Front: 8, 7, ..., 1.
     Center of Hole(1) = start_pos_y + row_spacing/2 ? 
     
   Let's re-calculate based on "A1 is the first hole". Usually A=Anterior (Front), B=Posterior (Back). Or just Row 1?
   Prompt: "centre ... is 14.38 mm from left edge... grid is centred on the block."
   
   Let's assume standard indexing where Col 1 = Left, Row 1 = Back or Front? 
   If we place holes symmetrically around a center line in Y and X to ensure alignment:
   
   Center of Block (X): start_pos_x + hole_radius * num_cols ? No.
   Holes are spaced by row_spacing=9mm along the rows, but there is also spacing between columns? 
   Wait, "8 rows... 12 columns". This implies a grid where holes exist at every intersection of these two axes.
   
   Let's define the hole positions explicitly to ensure they fit and align with A1 (Row 1, Col 1).
   
   X coordinates for Columns:
     If we place them symmetrically around start_pos_x? 
     Or is "left edge" a reference point where x=0 corresponds to Left Edge of Block?
     Let's assume the block starts at x = -block_length/2 + hole_radius (if centered) or just 0.
     
   Let's try this logic:
   Origin (0,0) in OpenSCAD aligns with a corner such that we can easily calculate positions relative to it? 
   No, better to define the block geometry directly using coordinates derived from A1 position.
   
   If Center of Hole(1) is at X = 14.38 - radius (assuming "from left edge" means distance to hole center)? 
   Radius = 6.2/2 = 3.1. So x_center_A1 = 14.38? Then Left Edge of Block would be at 0, and Hole(1) starts at 11.28?
   This seems odd for a rack where holes are usually centered on the block face or spaced evenly from edges.
   
   Alternative interpretation: "Centre ... is 14.38 mm from left edge" means the coordinate of the center point (X,Y,Z) in our model's local frame relative to x=0? 
   If we set Left Edge at x = -block_length/2 + hole_radius, then Center A1 would be...
   
   Let's assume a simpler approach that guarantees fit:
   Place all holes on a grid. Calculate the coordinates of Hole(1) based on "Center is 14.38 from left edge". 
   If we define our block to start at x=0 (Left Edge), then Center A1 = 14.38? No, that would mean radius > half-block if it's a rack.
   
   Most likely: The prompt implies the coordinate system origin is such that Left-Back Corner of Block is not necessarily 0, but relative positions matter.
   However, "from left edge" usually means x=0 = Left Edge. So Center A1_x = 14.38? 
   If Diameter = 6.2, Radius = 3.1. Then Hole(1) extends from X=11.28 to X=17.58 (if centered at 14.38).
   This leaves a gap of ~0.9mm between the hole and the left edge? That's possible for PCR tubes which are small (~6-8mm wide, but here diameter is specified as through-hole size, not tube width). 
   
   Let's proceed with: Left Edge at x=0. Center A1 = 14.38. Radius = 3.1.
   So Hole(1) spans [11.28, 17.58] in X? No, that would mean the hole is very close to the edge (gap ~1mm). 
   Wait, if Center A1 is at 14.38 and Radius is 3.1, then Left Edge of Hole = 11.28. Distance from Block Left Edge (0) to Hole Start = 11.28 mm.
   
   Y coordinates for Rows: 
     If we have 8 rows along the width? No, "along Y axis". The block is 85mm wide in Y.
     So Row spacing must be calculated such that they fit within -43 to +43 (approx).
     
     Let's assume standard microplate layout where holes are centered on a grid of X and Y axes relative to the center of the plate? 
     Or maybe just spaced along one axis? "8 rows... 12 columns". This implies a full matrix.
     
   If we place them symmetrically:
     Center Line (X): start_pos_x + hole_radius * num_cols ? No, holes are at intersections.
     
   Let's assume the prompt means A1 is located such that its center X-coordinate relative to the block-left edge is 14.38? 
   If we place all columns symmetrically around a central axis:
     Center of Block (X) = start_pos_x + hole_radius * num_cols ? No, holes are spaced by row_spacing=9mm along Y? 
     Wait, if there are 12 columns and spacing is between rows... that's confusing. "8 rows ... 12 columns". Usually means a grid where X has 13 points (0 to 12) or similar?
     
   Let's assume the holes form a regular grid with:
     Column centers at x = start_pos_x + i * hole_spacing_X ? 
     Row centers at y = start_pos_y + j * row_spacing_Y ?
     
   But we don't know X spacing. We only have "12 columns". Usually implies 13 points? Or just holes are placed in a grid defined by the prompt's implied geometry?
   
   Re-reading: "96 vertical through-holes... in 8 rows (along Y) by 12 columns (along X)". 
   This confirms it is a matrix. We need to define the coordinates of all points.
     
   Let's assume standard spacing for such racks, often derived from tube width or similar, but we must derive it? No dimensions given except A1 offset and block size.
   
   Hypothesis: The "left edge" reference (