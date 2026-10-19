// 10-well agarose gel comb
// Designed for FDM printing, lying flat on the XY plane.

// --- Dimensions ---
spine_l    = 70.0;    // Length of the spine (X)
spine_w    = 12.0;    // Width of the spine (Y)
plate_t    = 1.5;     // Thickness of the plate (Z)
tooth_w    = 5.0;     // Width of each tooth (X)
tooth_l    = 12.0;    // Length of each tooth (Y)
gap_w      = 1.5;     // Gap between teeth (X)
num_teeth  = 10;      // Number of teeth

$fn = 64;

// --- Calculations ---
// Total width occupied by teeth and gaps:
// (num_teeth * tooth_w) + ((num_teeth - 1) * gap_w)
total_teeth_width = (num_teeth * tooth_w) + ((num_teeth - 1) * gap_w);

// The teeth are centered on the spine in X.
// The spine extends from -spine_l/2 to spine_l/2.
// The teeth extend from the spine edge (spine_w/2) to (spine_w/2 + tooth_l) in Y.
// However, the prompt says teeth "hang from one long edge... in the -Y direction".
// This implies the spine is at +Y and teeth go towards -Y.
// Let's center the spine on X and Y=0.
// Spine Y range: [0, spine_w]
// Teeth Y range: [-tooth_l, 0]

module comb() {
    difference() {
        // Main Body: The spine and the rectangular area containing the teeth
        union() {
            // The spine
            translate([-spine_l/2, 0, 0]) 
                cube([spine_l, spine_w, plate_t]);
            
            // The tooth block (the area where teeth are cut from)
            translate([-total_teeth_width/2, -tooth_l, 0]) 
                cube([total_teeth_width, tooth_l, plate_t]);
        }

        // Subtract the gaps to create the teeth
        // We iterate through the number of teeth to place the gaps.
        // A gap is the space between tooth i and tooth i+1.
        for (i = [0 : num_teeth - 2]) {
            // Calculate X position for the gap
            // The first tooth starts at -total_teeth_width/2
            // The first gap starts after the first tooth.
            let (gap_x_start = -total_teeth_width/2 + (i + 1) * tooth_w + i * gap_w) = 
                translate([gap_x_start, -tooth_l - 0.1, -0.1])
                    cube([gap_w, tooth_l + 0.2, plate_t + 0.2]);
        }
        
        // Note: The prompt asks for "10 rectangular teeth". 
        // Usually, a comb is a single block with slots cut out.
        // To make "teeth" (protrusions), we should model a large block and subtract the gaps.
        // But the prompt says "a flat plate... has a spine... and 10 teeth".
        // This implies the teeth are part of the solid.
        // To achieve this, we model the total bounding box and subtract the gaps.
    }
}

// Corrected approach: 
// 1. Create a solid block that covers the spine AND the area where teeth will be.
// 2. Subtract the gaps between the teeth.

difference() {
    // The solid base (Spine + Tooth area)
    union() {
        // Spine
        translate([-spine_l/2, 0, 0]) 
            cube([spine_l, spine_w, plate_t]);
        // Tooth area
        translate([-total_teeth_width/2, -tooth_l, 0]) 
            cube([total_teeth_width, tooth_l, plate_t]);
    }

    // The gaps (the spaces between teeth)
    // There are (num_teeth - 1) gaps.
    for (i = [0 : num_teeth - 2]) {
        // X position: 
        // Tooth 0 is at -total_teeth_width/2 to -total_teeth_width/2 + tooth_w
        // Gap 0 is at -total_teeth_width/2 + tooth_w to -total_teeth_width/2 + tooth_w + gap_w
        let (gap_x_pos = -total_teeth_width/2 + (i + 1) * tooth_w + i * gap_w)
        translate([gap_x_pos, -tooth_l - 0.1, -0.1])
            cube([gap_w, tooth_l + 0.2, plate_t + 0.2]);
    }
}