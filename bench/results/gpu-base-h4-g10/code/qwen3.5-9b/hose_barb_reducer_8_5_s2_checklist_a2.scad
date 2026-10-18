// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints upright along Z, centred on origin in X and Y.

$fn = 128;

// Dimensions
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

// Total height
h_total      = z_5mm_end;

// Define the profile points for rotate_extrude.
// Format: [radius, z]
// We trace the outer surface from z=0 to z=41.
// 
// 8mm Section (0 to 20):
// Barb 1: 0 to 10. r: 3.75 -> 4.75. Step: 10 to 10. r: 4.75 -> 3.75.
// Barb 2: 10 to 20. r: 3.75 -> 4.75. Step: 20 to 20. r: 4.75 -> 3.75.
// Collar: 20 to 25. r: 3.75 -> 6.
//
// 5mm Section (25 to 41):
// Barb 1: 25 to 33. r: 3.25 -> 2.5. Step: 33 to 33. r: 2.5 -> 3.25.
// Barb 2: 33 to 41. r: 3.25 -> 2.5. Step: 41 to 41. r: 2.5 -> 3.25.

// Construct the list of points explicitly
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

// Note: rotate_extrude expects the profile to be closed or handled by the union/difference context.
// Since we are rotating a 2D profile around Z, the profile must be a closed loop or we use linear_extrude.
// However, rotate_extrude creates a solid of revolution from a 2D shape.
// The shape must be closed. We will close the loop by connecting the last point to the first.
// But wait, rotate_extrude creates a solid from a 2D polygon rotated around an axis.
// The polygon must be closed.
// Let's define the polygon points and close the loop.

// Points:
// [3.75, 0]
// [4.75, 10]
// [3.75, 10]
// [4.75, 20]
// [3.75, 20]
// [6, 20]
// [6, 25]
// [3.25, 25]
// [2.5, 33]
// [3.25, 33]
// [2.5, 41]
// [3.25, 41]
// [3.25, 0] // Close the loop back to start? No, the start is at z=0, r=3.75.
// The end is at z=41, r=3.25.
// To close the loop for rotate_extrude, we need to connect the last point to the first point.
// But the first point is at z=0. The last point is at z=41.
// This creates a solid that goes from z=0 to z=41.
// The "closing" line would be from [3.25, 41] to [3.75, 0].
// This is a diagonal line in the r-z plane, which is fine for a solid of revolution.
// However, usually, we want the bottom to be flat or the top to be flat.
// The user description implies the part ends at z=41 with the stepped profile.
// So the bottom is at z=0 with r=3.75.
// The top is at z=41 with r=3.25.
// The "closing" line from [3.25, 41] to [3.75, 0] creates a slanted bottom surface.
// Is this intended?
// "From z = 0 to z = 20...". This implies the part starts at z=0.
// "From z = 25 to z = 41...". This implies the part ends at z=41.
// The bottom surface is defined by the first segment of the profile.
// The profile starts at [3.75, 0] and goes to [4.75, 10].
// The "closing" line connects the last point [3.25, 41] to the first point [3.75, 0].
// This creates a slanted bottom face.
// If a flat bottom is required, we would need to add a segment from [3.25, 41] to [3.25, 0] and then [3.25, 0] to [3.75, 0].
// But the user didn't specify a flat bottom. They specified the profile from z=0.
// Let's assume the slanted bottom is acceptable or the user implies the profile defines the entire shape including the bottom transition.
// Actually, looking at the profile:
// z=0, r=3.75.
// z=41, r=3.25.
// If we close the loop directly, we get a slanted bottom.
// If we want a flat bottom at z=0, we need to extend the profile to include a flat section or adjust the closing.
// Given the strict description, I will close the loop directly.
// However, to ensure a printable part with a flat bottom (common for hose barbs),
// I will add a segment from [3.25, 41] to [3.25, 0] and then [3.25, 0] to [3.75, 0].
// Wait, the user said "From z = 0 to z = 20...".
// This implies the geometry is defined starting from z=0.
// If I add a flat bottom at z=0 with r=3.25, then the part would have a flat bottom of 6.5mm diameter.
// But the 8mm barb starts at 7.5mm diameter (r=3.75).
// So there is a step at the bottom?
// "From z = 0 to z = 20: two identical barbs...".
// This implies the barbs start at z=0.
// So the bottom of the part is the bottom of the first barb.
// The first barb has OD 7.5mm at its bottom.
// So the bottom of the part is a flat circle of 7.5mm diameter?
// No, the barb profile is "grows linearly from 7.5 mm at its bottom".
// So at z=0, the diameter is