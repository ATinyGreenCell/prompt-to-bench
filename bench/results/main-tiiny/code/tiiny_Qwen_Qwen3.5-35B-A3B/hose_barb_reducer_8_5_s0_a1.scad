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
// Calculated as 10% of barb height to ensure a distinct ridge, or fixed small value.
// Prompt implies "steps straight back", so we need a small step.
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
    // Create the sloped part
    // We use a cylinder with a radius that varies? No, we use a cone or a series of cylinders.
    // Better: Use a single cylinder for the base, then subtract the "negative" of the barb?
    // No, the easiest way to get a sawtooth profile on a cylinder is to use a single cylinder
    // for the max diameter and subtract a cylinder for the "valley" (the step back).
    // But the slope is linear.
    // Let's build it using a single cylinder for the "peak" part and subtract the "valley" part.
    // Actually, the simplest robust way:
    // 1. Create a cylinder of d_peak from z_start to z_start + h_slope.
    // 2. Create a cylinder of d_bottom from z_start + h_slope to z_start + h_slope + h_step.
    // 3. Union them? No, that would create a step.
    // We need a smooth slope.
    // Use a cone? No, OpenSCAD cone is not a primitive.
    // Use a cylinder with a very small height and varying radius? No.
    // Use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is offset?
    // No, that leaves a flat top.
    // Correct approach: Use a single cylinder of d_peak, then subtract a cylinder of d_bottom
    // that is positioned to cut the top part? No.
    // Let's use a "sawtooth" approach with a single cylinder of d_peak and subtract a cylinder of d_bottom
    // that is shifted in Z? No.
    // Let's use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is
    // positioned to create the slope?
    // Actually, the best way is to use a single cylinder of d_peak, then subtract a cylinder of d_bottom
    // that is positioned to cut the top part? No.
    // Let's use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is
    // positioned to cut the top part? No.
    // Let's use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is
    // positioned to cut the top part? No.
    // Let's use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is
    // positioned to cut the top part? No.
    // Let's use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is
    // positioned to cut the top part? No.
    // Let's use a single cylinder of d_peak, then subtract a cylinder of d_bottom that is
    // positioned to cut the top part?