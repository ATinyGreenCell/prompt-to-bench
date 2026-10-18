// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints standing upright along Z, centred on origin in X and Y.

$fn = 64;

// Dimensions
z_start_8mm = 0;
z_end_8mm   = 20;
z_start_coll = 20;
z_end_coll  = 25;
z_start_5mm = 25;
z_end_5mm   = 41;

// 8mm Tubing Barbs (Stacked)
// Barb 1: z = 0 to 10
// Barb 2: z = 10 to 20
barb_8_height = 10;
barb_8_bottom_od = 7.5;
barb_8_top_od    = 9.5;
barb_8_step_od   = 7.5;

// Collar
collar_od = 12;
collar_height = 5;

// 5mm Tubing Barbs (Stacked)
// Barb 1: z = 25 to 33
// Barb 2: z = 33 to 41
barb_5_height = 8;
barb_5_bottom_od = 6.5;
barb_5_top_od    = 5.0;
barb_5_step_od   = 6.5;

// Bore
bore_d = 3;

// Construct the main body using rotate_extrude
// We define the full profile from z=0 to z=41 manually to ensure the sawtooth shape is exact.
// The profile is a list of [radius, z] points.
// We start at (7.5, 0), go up the tapers, step down, go up the tapers, step down, etc.
// Finally, we close the loop by going back down the Z-axis to the start point.
// Note: The last point must connect back to the first point to form a closed polygon.

difference() {
    // Main body: Rotate the full profile around Z
    rotate_extrude() {
        // Profile points: [radius, z]
        // Section 1: Barb 1 Taper (0 to 10): 7.5 -> 9.5
        // Section 2: Barb 1 Step (10): 9.5 -> 7.5
        // Section 3: Barb 2 Taper (10 to 20): 7.5 -> 9.5
        // Section 4: Barb 2 Step (20): 9.5 -> 7.5
        // Section 5: Collar (20 to 25): 7.5 -> 12
        // Section 6: Barb 3 Taper (25 to 33): 12 -> 5.0
        // Section 7: Barb 3 Step (33): 5.0 -> 6.5
        // Section 8: Barb 4 Taper (33 to 41): 6.5 -> 5.0
        // Section 9: Close loop (41 to 0): 5.0 -> 7.5 (This creates the internal void if we were doing difference, 
        // but here we are defining the outer shell. The "closing" segment from (5.0, 41) to (7.5, 0) 
        // actually defines the outer surface of the part if the part was a solid of revolution of that path.
        // However, the part has a bore. The bore is handled by the difference operation below.
        // The outer profile must be a continuous line.
        // Let's trace the outer surface:
        // (7.5, 0) -> (9.5, 10) -> (7.5, 10) -> (9.5, 20) -> (7.5, 20) -> (12, 25) -> (5.0, 33) -> (6.5, 33) -> (5.0, 41)
        // Now we are at the top (5.0, 41). We need to get back to the start (7.5, 0) to close the loop.
        // The path from (5.0, 41) to (7.5, 0) is a straight line in the r-z plane.
        // This creates a conical surface connecting the top of the 5mm barbs to the bottom of the 8mm barbs.
        // This is physically correct for a reducer that tapers at the very ends if the user didn't specify otherwise.
        // However, the user specified "From z = 0 to z = 20... From z = 25 to z = 41".
        // This implies the part exists at z=0 with radius 7.5 and at z=41 with radius 5.0.
        // The connection between z=41 and z=0 is not explicitly described as a taper, but a closed polygon is required.
        // The most logical interpretation for a "reducer" is that the outer diameter changes linearly between the ends
        // if not specified, OR the user expects the part to just stop. But rotate_extrude requires a closed loop.
        // The standard way to close such a profile is a straight line from the end point back to the start point.
        // So we add (7.5, 0) at the end.
        
        polygon([
            [7.5, 0],
            [9.5, 10],
            [7.5, 10],
            [9.5, 20],
            [7.5, 20],
            [12, 25],
            [5.0, 33],
            [6.5, 33],
            [5.0, 41],
            [7.5, 0] // Close the loop
        ])
    }
    
    // Subtract the bore
    translate([0, 0, -1]) cylinder(h = 43, d = bore_d);
}