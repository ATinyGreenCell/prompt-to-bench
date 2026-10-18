// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
$fn = 100; // High resolution for smooth curves if needed

// Spine dimensions
SPINE_LENGTH = 70;  // X
SPINE_WIDTH = 12;   // Y
PLATE_THICKNESS = 1.5; // Z

// Tooth dimensions
NUM_TEETH = 10;
TOOTH_WIDTH = 5.0;  // X
TOOTH_LENGTH = 12;  // Y (extends from spine edge)
GAP_SIZE = 1.5;     // Gap between teeth

// --- Calculations ---
// Total width occupied by teeth
TOTAL_TEETH_WIDTH = NUM_TEETH * TOOTH_WIDTH;
// Total width occupied by gaps
TOTAL_GAP_WIDTH = (NUM_TEETH - 1) * GAP_SIZE;
// Total width of the tooth row
TOOTH_ROW_WIDTH = TOTAL_TEETH_WIDTH + TOTAL_GAP_WIDTH;

// --- Main Body Construction ---
// The comb consists of a main spine block and 10 teeth blocks.
// We will build the spine first, then subtract the gaps to create the wells,
// or build the spine and teeth as separate unions.
// Strategy: Build the full spine block, then subtract the gap volumes.

// 1. Create the main spine block
// Dimensions: SPINE_LENGTH x SPINE_WIDTH x PLATE_THICKNESS
// Position: Centered at origin (0,0,0)
spine = translate([0, 0, 0])
    cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS]);

// 2. Create the teeth
// The teeth hang from the top edge of the spine (Y = SPINE_WIDTH/2).
// The teeth are 12mm long. Since the spine is 12mm wide, the teeth will reach the bottom edge (Y = -SPINE_WIDTH/2).
// The center of the tooth row in Y should be 0.
// The tooth row spans from Y = TOOTH_LENGTH/2 (top) to Y = -TOOTH_LENGTH/2 (bottom).
// Since TOOTH_LENGTH = 12, the range is 6 to -6.
// This perfectly aligns with the spine width (6 to -6).
// So the teeth start at Y = 6 and go down to Y = -6.

// We will create the teeth as a single block with gaps, then subtract it from the spine?
// No, the teeth are solid material. The gaps are empty space.
// So we build the spine, then we subtract the gap regions.
// The gap regions are rectangular prisms located between the teeth.

// Calculate X positions for the gaps
// The tooth row is centered on the spine in X.
// Spine X range: [-35, 35].
// Tooth row X range: [-TOOTH_ROW_WIDTH/2, TOOTH_ROW_WIDTH/2].
// Center of tooth row is 0.

// We need to subtract 9 gaps.
// Each gap is: GAP_SIZE (X) x TOOTH_LENGTH (Y) x PLATE_THICKNESS (Z).
// The gaps are located between the teeth.
// Let's calculate the X start position of the first tooth.
// The row is centered.
// The first tooth starts at X = -TOOTH_ROW_WIDTH/2 + TOOTH_WIDTH/2.
// Wait, let's define the teeth positions explicitly.
// Tooth i (0 to 9) center X:
// Center of row = 0.
// Tooth i center = -TOOTH_ROW_WIDTH/2 + TOOTH_WIDTH/2 + i * (TOOTH_WIDTH + GAP_SIZE).
// Let's verify:
// i=0: -51.5/2 + 2.5 = -25.75 + 2.5 = -23.25.
// i=9: -25.75 + 2.5 + 9 * 6.5 = -23.25 + 58.5 = 35.25.
// This seems correct.

// Now, where are the gaps?
// Gap i (0 to 8) is between Tooth i and Tooth i+1.
// Gap i center X = Tooth i center + TOOTH_WIDTH/2 + GAP_SIZE/2.
// Or simply: Gap i starts at Tooth i end + epsilon.
// Tooth i end X = Tooth i center + TOOTH_WIDTH/2.
// Gap i start X = Tooth i end X + 0.01 (to ensure cut).
// Gap i width = GAP_SIZE.

// Let's construct the subtraction shapes.
// We iterate i from 0 to NUM_TEETH - 2 (which is 8).
// For each gap, we create a cube to subtract.

// Define the subtraction loop
difference() {
    union() {
        // 1. The Spine
        translate([0, 0, 0])
            cube([SPINE_LENGTH, SPINE_WIDTH, PLATE_THICKNESS]);

        // 2. The Teeth
        // We can build the teeth as a single block with holes, or as individual blocks.
        // Building as individual blocks is safer for alignment.
        for (i = [0 : NUM_TEETH - 1]) {
            // Calculate X position for tooth i
            // Center of the whole row is 0.
            // The row consists of NUM_TEETH teeth and (NUM_TEETH - 1) gaps.
            // Total width = NUM_TEETH * TOOTH_WIDTH + (NUM_TEETH - 1) * GAP_SIZE.
            // The center of the first tooth is:
            // - (Total Width / 2) + (TOOTH_WIDTH / 2)
            // Then add i * (TOOTH_WIDTH + GAP_SIZE)
            
            tooth_center_x = -(TOOTH_ROW_WIDTH / 2) + (TOOTH_WIDTH / 2) + i * (TOOTH_WIDTH + GAP_SIZE);
            
            // Tooth dimensions
            // X: tooth_center_x - TOOTH_WIDTH/2 to tooth_center_x + TOOTH_WIDTH/2
            // Y: SPINE_WIDTH/2 - TOOTH_LENGTH to SPINE_WIDTH/2 (hanging down from top edge)
            // Z: 0 to PLATE_THICKNESS
            
            tooth_x_start = tooth_center_x - TOOTH_WIDTH / 2;
            tooth_x_end = tooth_center_x + TOOTH_WIDTH / 2;
            tooth_y_start = SPINE_WIDTH / 2 - TOOTH_LENGTH; // Bottom of tooth
            tooth_y_end = SPINE_WIDTH / 2;                  // Top of tooth (at spine edge)
            
            translate([tooth_x_start, tooth_y_start, 0])
                cube([TOOTH_WIDTH, TOOTH_LENGTH, PLATE_THICKNESS]);
        }
    }
    
    // Subtract the gaps
    for (i = [0 : NUM_TEETH - 2]) {
        // Calculate X position for gap i
        // Gap i is between tooth i and tooth i+1.
        // Tooth i ends at: tooth_center_x(i) + TOOTH_WIDTH/2
        // Gap i starts at: Tooth i end + 0.01
        // Gap i width: GAP_SIZE
        
        tooth_i_center = -(TOOTH_ROW_WIDTH / 2) + (TOOTH_WIDTH / 2) + i * (TOOTH_WIDTH + GAP_SIZE);
        gap_x_start = tooth_i_center + TOOTH_WIDTH / 2 + 0.01;
        gap_x_end = gap_x_start + GAP_SIZE;
        
        // Gap Y range: same as teeth (from top edge to bottom edge)
        gap_y_start = SPINE_WIDTH / 2 - TOOTH_LENGTH;
        gap_y_end = SPINE_WIDTH / 2;
        
        translate([gap_x_start, gap_y_start, 0])
            cube([GAP_SIZE, TOOTH_LENGTH, PLATE_THICKNESS]);
    }
}