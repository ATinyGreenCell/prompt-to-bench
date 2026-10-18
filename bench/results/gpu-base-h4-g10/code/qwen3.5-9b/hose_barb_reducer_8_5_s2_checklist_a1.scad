// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints upright along Z, centred on origin in X and Y.

$fn = 128;

// Dimensions
z_start      = 0;
z_8mm_end    = 20;
z_collar_end = 25;
z_5mm_end    = 41;

// 8mm tubing section (z = 0 to 20)
// Two stacked barbs, each 10mm tall.
// Barb OD: 7.5mm at bottom, 9.5mm at top, then steps back to 7.5mm.
h_8mm_barb   = 10;
od_8mm_bot   = 7.5;
od_8mm_top   = 9.5;
od_8mm_step  = 7.5;

// 5mm tubing section (z = 25 to 41)
// Two stacked barbs, each 8mm tall.
// Barb OD: 6.5mm at bottom, 5.0mm at top, then steps back to 6.5mm.
h_5mm_barb   = 8;
od_5mm_bot   = 6.5;
od_5mm_top   = 5.0;
od_5mm_step  = 6.5;

// Common collar (z = 20 to 25)
d_collar     = 12;

// Bore
d_bore       = 3;

// Total height calculation
h_total = z_5mm_end + h_5mm_barb; // 41 + 8 = 49mm

// Define the profile points for rotate_extrude.
// Format: [radius, z]
// We trace the outer surface from z=0 to z=49.
// 
// 8mm Section (0 to 20):
// Barb 1: 0 to 10. r: 3.75 -> 4.75. Step: 10 to 10. r: 4.75 -> 3.75.
// Barb 2: 10 to 20. r: 3.75 -> 4.75. Step: 20 to 20. r: 4.75 -> 3.75.
// Collar: 20 to 25. r: 3.75 -> 6.
//
// 5mm Section (25 to 41):
// Barb 1: 25 to 33. r: 3.25 -> 2.5. Step: 33 to 33. r: 2.5 -> 3.25.
// Barb 2: 33 to 41. r: 3.25 -> 2.5. Step: 41 to 41. r: 2.5 -> 3.25.
// Bottom extension: 41 to 49. r: 3.25 -> 6.
// Final bottom: 49 to 57? No, the user said "From z = 25 to z = 41...".
// The part ends at z=49 based on the description "From z = 25 to z = 41...".
// Wait, the user said "From z = 25 to z = 41: two identical barbs...".
// Barb 1: 25 to 33. Barb 2: 33 to 41.
// So the part ends at z=41?
// Let's re-read: "From z = 25 to z = 41: two identical barbs...".
// This implies the section exists from 25 to 41.
// Does the part end at 41? Or is there a bottom?
// "From z = 0 to z = 20... From z = 20 to z = 25... From z = 25 to z = 41..."
// This covers 0 to 41.
// However, the barbs have a "step back" feature.
// Barb 1 (25-33): grows 6.5->5.0, steps back to 6.5.
// Barb 2 (33-41): grows 6.5->5.0, steps back to 6.5.
// So at z=41, the radius is 3.25 (half of 6.5).
// The part likely ends at z=41 with the stepped profile, or extends to a flat bottom.
// Given "straight hose-barb reducer", it usually has a flat bottom.
// But the prompt doesn't specify a bottom extension.
// Let's assume the part ends at z=41 with the stepped profile, or perhaps the "step back" creates the bottom.
// Actually, if the barb steps back to 6.5 at the top, then the bottom of the barb is 6.5.
// So at z=33, r=3.25. At z=33 (step), r=3.25.
// Wait, "steps straight back to 6.5". This means the diameter becomes 6.5. Radius 3.25.
// So at z=33, r=2.5 (top of barb). Then step to r=3.25.
// Then Barb 2: 33 to 41. r: 3.25 -> 2.5. Step: 41 to 41. r: 2.5 -> 3.25.
// So at z=41, r=3.25.
// The part ends at z=41.

// Let's construct the polygon points.
// Points: [radius, z]
// 0: 3.75
// 10: 4.75
// 10: 3.75 (step)
// 20: 4.75
// 20: 3.75 (step)
// 20: 6 (start of collar)
// 25: 6 (end of collar)
// 25: 3.25 (start of 5mm barb)
// 33: 2.5 (top of 5mm barb)
// 33: 3.25 (step)
// 41: 2.5 (top of 5mm barb)
// 41: 3.25 (step)
// End at 41.

// Wait, the user said "From z = 25 to z = 41: two identical barbs...".
// This implies the section is 25 to 41.
// So the total height is 41mm.

// Let's verify the "step back" logic.
// "grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm"
// Bottom of barb 1 (z=0): OD=7.5, r=3.75.
// Top of barb 1 (z=10): OD=9.5, r=4.75.
// Step: OD=7.5, r=3.75.
// Bottom of barb 2 (z=10): OD=7.5, r=3.75.
// Top of barb 2 (z=20): OD=9.5, r=4.75.
// Step: OD=7.5, r=3.75.
// Collar (z=20 to 25): OD=12, r=6.
// Bottom of 5mm barb 1 (z=25): OD=6.5, r=3.25.
// Top of 5mm barb 1 (z=33): OD=5.0, r=2.5.
// Step: OD=6.5, r=3.25.
// Bottom of 5mm barb 2 (z=33): OD=6.5, r=3.25.
// Top of 5mm barb 2 (z=41): OD=5.0, r=2.5.
// Step: OD=6.5, r=3.25.
// End at z=41.

// Polygon points:
// [3.75, 0]
// [4.75, 10]
// [3.75, 10]
// [4.75, 20]
// [3.75, 20]
// [6, 20]
// [6, 25]
// [3.25, 25]
// [2.5,