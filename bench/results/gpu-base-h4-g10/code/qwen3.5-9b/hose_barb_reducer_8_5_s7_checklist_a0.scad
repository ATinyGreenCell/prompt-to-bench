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

// Function to generate a sawtooth profile for a barb
// Returns a list of [radius, z] points for rotate_extrude
// type: "grow" (bottom to top then step down) or "shrink" (top to bottom then step up)
// Note: rotate_extrude expects radius on X, height on Y.
// We will construct the profile relative to the start of the barb.

function make_barb_profile(h, r_bottom, r_top, r_step, type) = 
    let(
        // Define the radius at the step point (top of the tapered section)
        r_taper_top = (type == "grow") ? r_top : r_step,
        // Define the radius at the step point (bottom of the tapered section)
        r_taper_bot = (type == "grow") ? r_bottom : r_top,
        // Define the radius at the end of the barb (after the step)
        r_end = (type == "grow") ? r_step : r_bottom,
        // Points for the tapered section
        p1 = [r_taper_bot, 0],
        p2 = [r_taper_top, h],
        // Points for the stepped section
        p3 = [r_end, h],
        // Close the loop at the bottom
        p4 = [r_end, 0],
        // Combine into a single polygon list
        poly = [p1, p2, p3, p4]
    ) poly;

// Construct the main body using rotate_extrude
// We define the profile as a function of Z to handle the different sections
// Since rotate_extrude takes a static polygon, we must build the full profile from z=0 to z=41
// and then subtract the bore.

difference() {
    // Main body: Rotate the full profile around Z
    rotate_extrude() {
        // Define the full profile from z=0 to z=41
        // Section 1: 8mm Barbs (0 to 20)
        //   Barb 1 (0-10): Grow from 7.5 to 9.5, step to 7.5
        //   Barb 2 (10-20): Grow from 7.5 to 9.5, step to 7.5
        // Section 2: Collar (20-25)
        //   Cylinder 12mm
        // Section 3: 5mm Barbs (25-41)
        //   Barb 1 (25-33): Shrink from 6.5 to 5.0, step to 6.5
        //   Barb 2 (33-41): Shrink from 6.5 to 5.0, step to 6.5

        // We build the profile point by point
        // Start at z=0, r=7.5
        // End at z=41, r=6.5
        
        // Helper to generate points for a specific segment
        // We will manually list the critical points to ensure the sawtooth shape is exact
        
        // Segment 1: Barb 1 Taper (0 to 10)
        // r goes 7.5 -> 9.5
        // Point A: [7.5, 0]
        // Point B: [9.5, 10]
        
        // Segment 2: Barb 1 Step (10 to 10) - Instantaneous drop
        // r goes 9.5 -> 7.5
        // Point C: [7.5, 10]
        
        // Segment 3: Barb 2 Taper (10 to 20)
        // r goes 7.5 -> 9.5
        // Point D: [9.5, 20]
        
        // Segment 4: Barb 2 Step (20 to 20) - Instantaneous drop
        // r goes 9.5 -> 7.5
        // Point E: [7.5, 20]
        
        // Segment 5: Collar (20 to 25)
        // r stays 12
        // Point F: [12, 25]
        
        // Segment 6: Barb 3 Taper (25 to 33)
        // r goes 6.5 -> 5.0
        // Point G: [5.0, 33]
        
        // Segment 7: Barb 3 Step (33 to 33) - Instantaneous drop
        // r goes 5.0 -> 6.5
        // Point H: [6.5, 33]
        
        // Segment 8: Barb 4 Taper (33 to 41)
        // r goes 6.5 -> 5.0
        // Point I: [5.0, 41]
        
        // Segment 9: Close loop at bottom
        // Point J: [5.0, 0] (Wait, the bottom of the part is at z=0, r=7.5)
        // Actually, the profile must be closed.
        // The bottom of the part is at z=0. The radius there is 7.5.
        // The top of the part is at z=41. The radius there is 5.0.
        // We need to connect the top (5.0, 41) back to the bottom (7.5, 0) via the internal bore?
        // No, rotate_extrude creates a solid. The "hole" is created by the difference operation.
        // So the outer profile must be a closed loop.
        // We go from (7.5, 0) up to (5.0, 41) and then back down to (7.5, 0) along the Z axis?
        // No, that would create a solid cylinder at the bottom.
        // The profile for rotate_extrude is (radius, height).
        // We start at (7.5, 0).
        // We go up to (9.5, 10).
        // We go down to (7.5, 10).
        // We go up to (9.5, 20).
        // We go down to (7.5, 20).
        // We go up to (12, 25).
        // We go down to (5.0, 33).
        // We go up to (6.5, 33).
        // We go down to (5.0, 41).
        // Now we are at (5.0, 41). We need to close the loop back to (7.5, 0).
        // But the part is not a solid cylinder from 0 to 41. It has a bore.
        // The outer surface is defined by the path above.
        // To close the loop for rotate_extrude, we must go from (5.0, 41) back to (7.5, 0) along the Z axis?
        // No, that would imply the radius changes linearly from 5.0 to 7.5 between z=41 and z=0.
        // That is not what we want.
        // We want the part to exist only between z=0 and z=41.
        // The "bottom" of the part is at z=0. The radius is 7.5.
        // The "top" of the part is at z=41. The radius is