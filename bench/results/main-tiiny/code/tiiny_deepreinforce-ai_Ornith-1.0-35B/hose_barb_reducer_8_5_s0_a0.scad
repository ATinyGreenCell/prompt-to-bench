// Hose-barb reducer: 8mm ID to 5mm ID silicone tubing
// Print orientation: upright along Z, resting on XY plane at z=0

// --- Dimensions (mm) ---
BORE_DIA = 3.0;          // Through-bore diameter
COLLAR_DIA = 12.0;        // Collar outer diameter
COLLAR_HEIGHT = 5.0;    // Collar height (z=20 to z=25)

// 8mm tubing section (z=0 to z=20)
BARB1_HEIGHT = 10.0;      // Height of each 8mm barb
BARB1_BOTTOM_DIA = 7.5;   // Smaller diameter at bottom of 8mm barb
BARB1_TOP_DIA = 9.5;      // Larger diameter at top of 8mm barb

// 5mm tubing section (z=25 to z=41)
BARB2_HEIGHT = 8.0;      // Height of each 5mm barb
BARB2_BOTTOM_DIA = 6.5;   // Smaller diameter at bottom of 5mm barb
BARB2_TOP_DIA = 5.0;      // Larger diameter at top of 5mm barb

// --- Helper: single sawtooth barb (diameter grows linearly, then steps back) ---
// A barb has two parts: a conical frustum (linear taper) and a flat step-back
module sawtooth_barb(height, bottom_dia, top_dia, bore_dia) {
    // Conical frustum (linear taper from bottom to top)
    cylinder(h = height, d1 = bottom_dia, d2 = top_dia, center = false, $fn = 64);
    // Flat step-back: extends slightly past bottom to ensure clean cut
    cylinder(h = 0.01, d = bottom_dia, center = false, $fn = 64);
}

// --- Build the part ---
difference() {
    union() {
        // 8mm tubing barbs (z=0 to z=20): two stacked barbs
        // First barb: z=0 to z=10
        translate([0, 0, 0])
            sawtooth_barb(BARB1_HEIGHT, BARB1_BOTTOM_DIA, BARB1_TOP_DIA, BORE_DIA);
        // Second barb: z=10 to z=20
        translate([0, 0, BARB1_HEIGHT])
            sawtooth_barb(BARB1_HEIGHT, BARB1_BOTTOM_DIA, BARB1_TOP_DIA, BORE_DIA);
        
        // Collar (z=20 to z=25)
        translate([0, 0, 20])
            cylinder(h = COLLAR_HEIGHT, d = COLLAR_DIA, center = false, $fn = 64);
        
        // 5mm tubing barbs (z=25 to z=41): two stacked barbs
        // First barb: z=25 to z=33
        translate([0, 0, 25])
            sawtooth_barb(BARB2_HEIGHT, BARB2_BOTTOM_DIA, BARB2_TOP_DIA, BORE_DIA);
        // Second barb: z=33 to z=41
        translate([0, 0, 25 + BARB2_HEIGHT])
            sawtooth_barb(BARB2_HEIGHT, BARB2_BOTTOM_DIA, BARB2_TOP_DIA, BORE_DIA);
    }
    
    // Through-bore: extend slightly past both ends for clean cutting
    cylinder(h = 41 + 0.01, d = BORE_DIA, center = false, $fn = 64);
}