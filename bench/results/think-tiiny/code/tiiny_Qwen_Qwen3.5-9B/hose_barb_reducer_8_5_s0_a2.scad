$fn = 128;

// --- Dimensions ---
// Main bore diameter (runs through full length)
BORE_D = 3.0;
BORE_R = BORE_D / 2;

// Section 1: 8mm Tubing Barbs (z=0 to z=20)
// Two barbs stacked, 10mm each
S1_BARB_H = 10;
S1_BARB_BOT_OD = 7.5;
S1_BARB_TOP_OD = 9.5;

// Section 2: Cylindrical Collar (z=20 to z=25)
S2_H = 5;
S2_OD = 12;

// Section 3: 5mm Tubing Barbs (z=25 to z=41)
// Two barbs stacked, 8mm each
S3_BARB_H = 8;
S3_BARB_BOT_OD = 6.5;
S3_BARB_TOP_OD = 5.0;

// Total height: 10 + 10 + 5 + 8 + 8 = 41 mm
TOTAL_H = 2 * S1_BARB_H + S2_H + 2 * S3_BARB_H;

// --- Main Body ---
// Create the profile in XY plane (X=radius, Y=height)
// Then rotate_extrude around Z axis
// Then subtract the bore cylinder

// Profile points: (radius, height)
// z=0, r=3.75 (7.5/2)
// z=10, r=4.75 (9.5/2)
// z=10+, r=3.75 (7.5/2) - step
// z=20, r=4.75 (9.5/2)
// z=20+, r=3.75 (7.5/2) - step
// z=25, r=6.0 (12/2)
// z=33, r=2.5 (5.0/2)
// z=33+, r=6.0 (12/2) - step
// z=41, r=2.5 (5.0/2)

profile_points = [
    [S1_BARB_BOT_OD / 2, 0],
    [S1_BARB_TOP_OD / 2, S1_BARB_H],
    [S1_BARB_BOT_OD / 2, S1_BARB_H],
    [S1_BARB_TOP_OD / 2, S1_BARB_H + S1_BARB_H],
    [S1_BARB_BOT_OD / 2, S1_BARB_H + S1_BARB_H],
    [S2_OD / 2, S1_BARB_H + S1_BARB_H + S2_H],
    [S3_BARB_TOP_OD / 2, S1_BARB_H + S1_BARB_H + S2_H + S3_BARB_H],
    [S3_BARB_BOT_OD / 2, S1_BARB_H + S1_BARB_H + S2_H + S3_BARB_H],
    [S3_BARB_BOT_OD / 2, TOTAL_H]
];

// Create the main body by rotating the profile
difference() {
    // Main outer body
    rotate_extrude() {
        polygon(points = profile_points);
    }
    
    // Subtract the bore cylinder through full length
    cylinder(
        h = TOTAL_H,
        r = BORE_R,
        center = [0, 0, 0]
    );
}