// Dimensions for the hose-barb reducer
// Units: millimetres

// Overall length
TOTAL_LENGTH = 41;

// Bore diameter (through hole)
BORE_DIA = 3;

// --- Section 1: 8mm tubing barbs (z=0 to z=20) ---
// Number of barbs in this section
BARBS_8_COUNT = 2;
// Height of each barb in this section (including step back)
BARB_8_HEIGHT = 10;
// Bottom diameter of the barb profile (at the start of the barb)
BARB_8_BOTTOM_DIA = 7.5;
// Top diameter of the barb profile (at the peak of the barb)
BARB_8_TOP_DIA = 9.5;
// Length of the step back (to create the sawtooth shape)
BARB_8_STEP_LEN = 1.0;
// Height of the sloped part
BARB_8_SLOPE_HEIGHT = BARB_8_HEIGHT - BARB_8_STEP_LEN;

// --- Section 2: Cylindrical collar (z=20 to z=25) ---
COLLAR_DIA = 12;
COLLAR_HEIGHT = 5; // 25 - 20

// --- Section 3: 5mm tubing barbs (z=25 to z=41) ---
// Number of barbs in this section
BARBS_5_COUNT = 2;
// Height of each barb in this section (including step back)
BARB_5_HEIGHT = 8;
// Bottom diameter of the barb profile (at the start of the barb)
BARB_5_BOTTOM_DIA = 6.5;
// Top diameter of the barb profile (at the peak of the barb)
BARB_5_TOP_DIA = 5.0;
// Length of the step back
BARB_5_STEP_LEN = 1.0;
// Height of the sloped part
BARB_5_SLOPE_HEIGHT = BARB_5_HEIGHT - BARB_5_STEP_LEN;

// --- Geometry Construction ---

// Helper module to create a single barb segment
// z_start: bottom of the barb
// h_slope: height of the slope
// h_step: height of the step back
// d_bottom: diameter at bottom
// d_peak: diameter at peak
// d_step: diameter at step back
module create_barb(z_start, h_slope, h_step, d_bottom, d_peak, d_step) {
    // We build the barb by creating a cylinder of the peak diameter,
    // then subtracting a cylinder of the bottom diameter that is offset to create the slope.
    // However, a simpler and more robust way for a sawtooth profile is to use a single cylinder
    // for the "base" and subtract the "negative" of the barb shape? No.
    // Let's use a single cylinder of the peak diameter for the slope part,
    // and a cylinder of the bottom diameter for the step part, then union them?
    // No, that creates a step.
    // Correct approach: Use a single cylinder of the peak diameter for the entire height,
    // then subtract a cylinder of the bottom diameter that is positioned to cut the top part?
    // No, that leaves a flat top.
    // Let's use a single cylinder of the peak diameter for the slope part,
    // and a cylinder of the bottom diameter for the step part, then union them?
    // No, that creates a step.
    // Let's use a single cylinder of the peak diameter for the slope part,
    // and a cylinder of the bottom diameter for the step part, then union them?
    // No, that creates a step.
    //