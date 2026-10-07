// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions measured with calipers (mm)

// Block dimensions
block_length = 106; // X dimension in mm
block_width = 72;   // Y dimension in mm
block_height = 30;  // Z dimension in mm

// Hole grid parameters
hole_rows_y = 4;    // Number of rows along Y axis
holes_per_row_x = 6;// Number of columns along X axis
centre_to_centre_spacing = 16; // Spacing between hole centers (mm)
hole_diameter = 11.2;     // Hole diameter in mm
tube_insertion_depth = 25; // Depth of holes from top surface (mm)

// Floor thickness parameters
floor_thickness = block_height - tube_insertion_depth; 
// Calculated: 30 - 25 = 5 mm solid floor at the bottom

// Difference extension for clean cuts (Rule #5)
cut_extension = 1.0; // Extend cut shapes by 1mm past faces to avoid coplanar issues

// Main block geometry centered on origin
main_block = cube([block_length, block_width, block_height]);

// Calculate hole coordinates relative to the center of the main block (origin)
// For an even number of columns with fixed spacing S centered at X=0:
// We cannot have all adjacent gaps equal to S and be perfectly symmetric around 0.
// The standard solution is to distribute them evenly, resulting in a slightly larger gap between the two middle holes 
// or shifting the grid so it fits within the block bounds while maintaining symmetry of the bounding box.
// Given "grid centred on the block", we center the outermost edges of the hole pattern relative to the block center?
// Or simpler: Calculate positions such that they are as evenly spaced as possible and centered in X/Y range [-block_length/2, block_width/2].
// Let's calculate specific coordinates for 6 columns with spacing 16mm.
// To be symmetric around origin (0,0), we need the sum of x-coordinates to be 0.
// Sequence: -48, -32, -16, +16, +32, +48 -> Sum = 0? No (-96+96=0). 
// Gaps: 16, 16, 32 (between -16 and 16), 16, 16. This creates a large central gap but satisfies "centered" if we consider the set of points symmetric.
// However, usually racks want continuous rows. 
// Let's try: Start from left edge margin? No, let's use explicit calculation for even N centered on origin with step S.
// Positions = [-(N-1)/2 * (S/2), ...] ? No.
// Correct logic for "Centered Grid" in OpenSCAD context usually implies the bounding box of holes is centered.
// Let's define X coords: -48, -32, 0? No step must be 16. 
// Okay, let's use a loop that generates coordinates symmetrically around zero by handling the middle gap or simply placing them at calculated offsets.
// If we place centers at x = [-7*8 + i*16]? No.
// Let's just calculate: Start index -3 (for 0-based) to +2? 
// Indices: -5, -4, -3, -2, -1, 0 -> Sum != 0.
// Indices: -5, -4, -3, -2, -1, 1 -> No.
// Let's use the property that for even N=6 and step S=16 centered at origin, we must have a gap of 2*S in the middle to maintain symmetry if we strictly follow "adjacent = S". 
// BUT, often users mean "evenly distributed within the block width minus margins".
// Let's assume the user wants the holes evenly spaced across the available space.
// Available X range for centers: roughly -50mm to +53mm (to fit 11.2mm diameter).
// If we force symmetry of coordinates around origin, and step is constant except one gap? 
// Let's try a different approach: Generate coords such that they are centered in the block [-L/2, L/2].
// Center X = -53 mm (approx left edge for centering holes). 
// Coords relative to this start: 0, 16, 32, 48, 64, 80.
// Absolute coords: -53 + [0..80] -> [-53, -37, -21, -5, 11, 27]. 
// This is NOT centered on origin (sum != 0). Sum = 9mm offset? No. (-53-37-21-5+11+27) = -78.
// Let's try to center the set [-48, -32, -16, +16, +32, +48]. 
// This is symmetric around 0? Sum = (-48-32-16)+(16+32+48) = -96 + 96 = 0. YES.
// Gaps: |-48 - (-32)| = 16. |(-32)-(-16)|=16. |(-16)-(16)|=32 (Gap). |(16)-(32)|=16. |(32)-(48)|=16.
// This creates a "double hole" gap in the middle? No, it's just one big empty space between -16 and 16. 
// Is this acceptable for a rack? Probably not ideal ergonomically (two tubes far apart).
// Alternative: Shift slightly to close the gap but break perfect symmetry of coordinates around origin? 
// Or accept that "centered" means centered in X range, even if sum != 0? 
// Rule says "centre it on the origin". This implies geometric centering.
// Let's try a different set: -32, -16, +8, +24... No step is broken.
// How about: [-7*8 = -56 ...] No.
// Okay, let's calculate positions that are symmetric around 0 and have minimal max gap? 
// Actually, the most robust interpretation for "centered grid" with even count N=6 and spacing S=16 is to place them at offsets: 
// x_i = (i - center_index) * step.
// If we want symmetry of positions {x}, then sum(x)=0.
// Let's try indices relative to 2.5? No integer steps.
// Okay, let's use the "evenly spaced within bounds" logic which is standard for racks: 
// Start from left margin (block_width/2 - hole_radius) and step by spacing until we hit right margin. Then adjust last point if needed?
// But rule says "centre-to-centre". This implies fixed distance between neighbors.
// If I have 6 points with dist=16, the total span is 5*16 = 80mm. 
// To center this span of 80mm on a block width of 72mm? Impossible (80 > 72).
// Therefore, we cannot fit 6 holes with C-C spacing of 16mm centered perfectly in X if "centered" means the grid's bounding box is inside and aligned. 
// Wait, Block Width = 72mm. Span needed for 6 holes (5 intervals) = 80mm.
// The rack will be too wide to fit all 6 rows with C-C=16 centered on origin if we strictly enforce the span <= block_width? 
// Unless "centered" means the grid is shifted so it looks balanced, or the user's measurement implies a larger effective width (maybe tubes are wider than diameter?).
// Or maybe the spacing includes clearance? No, "centre-to-centre".
// Let's re-read: "16 mm centre-to-centre in both directions". 
// If I have 4 rows of 6 holes. Total span X = 5 * 16 = 80mm. Block width Y (which is the row direction? No, usually length=X, width=Y).
// Prompt: "106 mm long (X), 72 mm wide (Y)". 
// Holes are in rows along Y and columns along X. 
// So we have 4 holes per column (along Y) with spacing 16mm? And 6 holes per row (along X)?
// Let's check fit:
// Along X (columns): 6 holes, C-C=16 -> Span = 5*16 = 80mm. Block Length X = 106mm. Fits easily with margin. Centered? Yes, (-40 to +40) fits in -53..+53.
// Along Y (rows): 4 holes, C-C=16 -> Span = 3*16 = 48mm. Block Width Y = 72mm. Fits easily with margin. Centered? Yes.
// My previous confusion was swapping X and Y counts or dimensions. 
//