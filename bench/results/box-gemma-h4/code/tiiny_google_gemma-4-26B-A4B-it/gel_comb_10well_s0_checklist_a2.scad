// 10-well agarose gel comb
// Designed for FDM printing, lying flat on the XY plane.

// --- Dimensions ---
spine_l     = 70.0;    // Length of the spine (X)
spine_w     = 12.0;    // Width of the spine (Y)
plate_t     = 1.5;     // Thickness of the plate (Z)
tooth_w     = 5.0;     // Width of each tooth (X)
tooth_l     = 12.0;    // Length of each tooth (Y)
gap         = 1.5;     // Gap between teeth
num_teeth   = 10;      // Number of teeth

$fn = 64;

// --- Calculations ---
// Total width of the teeth array (from start of first tooth to end of last)
total_teeth_x = (num_teeth * tooth_w) + ((num_teeth - 1) * gap);

// The teeth array is centered on X=0. 
// The first tooth starts at -(total_teeth_x / 2).
x_start = -total_teeth_x / 2;

// The spine is centered on Y=0, so its edges are at +/- spine_w/2.
// One long edge is at Y = -spine_w/2.
// To "hang" in the -Y direction from that edge, the teeth 
// occupy the space from Y = (-spine_w/2 - tooth_l) to Y = -spine_w/2.
y_tooth_start = -spine_w/2 - tooth_l;

union() {
    // Main Body: The spine
    // Centered on X and Y, sitting on Z=0
    translate([-spine_l/2, -spine_w/2, 0])
        cube([spine_l, spine_w, plate_t]);
    
    // The Teeth
    for (i = [0 : num_teeth - 1]) {
        // X position: start at x_start and increment by (width + gap)
        tx = x_start + (i * (tooth_w + gap));
        
        // Translate to position:
        // X: Centered array
        // Y: From the edge of the spine extending in -Y direction
        // Z: Sitting on the bed
        translate([tx, y_tooth_start, 0])
            cube([tooth_w, tooth_l, plate_t]);
    }
}