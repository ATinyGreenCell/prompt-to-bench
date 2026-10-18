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

// Generate polygon for 8mm barb profile
// Points: [radius, z]
// Bottom of first barb: z=0, r=3.75
// Top of first barb: z=10, r=4.75
// Step down: z=10, r=3.75
// Bottom of second barb: z=20, r=3.75
// Top of second barb: z=30, r=4.75
// Step down: z=30, r=3.75
// Top of collar: z=35, r=6
// Top of 5mm barbs: z=41, r=2.5
// Step out: z=41, r=3.25
// Bottom of 5mm barbs: z=49, r=3.25
// Bottom of collar: z=49, r=6
// Bottom of 8mm barbs: z=57, r=3.75

// We will build the profile from z=0 to z=57 (total height)
// Then extrude.

// Define the profile points manually to ensure exact geometry
// Format: [radius, z]
// Note: rotate_extrude expects [radius, height] where radius >= 0.
// We define the profile from z=0 upwards.

// 8mm Section (0 to 20)
// Barb 1: 0 to 10. r: 3.75 -> 4.75. Step: 10 to 10. r: 4.75 -> 3.75.
// Barb 2: 10 to 20. r: 3.75 -> 4.75. Step: 20 to 20. r: 4.75 -> 3.75.
// Collar: 20 to 25. r: 3.75 -> 6.

// 5mm Section (25 to 41)
// Barb 1: 25 to 33. r: 3.25 -> 2.5. Step: 33 to 33. r: 2.5 -> 3.25.
// Barb 2: 33 to 41. r: 3.25 -> 2.5. Step: 41 to 41. r: 2.5 -> 3.25.
// Collar: 41 to 49. r: 3.25 -> 6.
// Bottom: 49 to 57. r: 6 -> 3.75.

// Construct the list of points for rotate_extrude
// We need to cover the full height from z=0 to z=57.
// However, the user description implies the part sits on z=0.
// Let's trace the radius at every z level.

// 0 <= z < 10: r = 3.75 + (z/10)*(4.75-3.75) = 3.75 + 0.1*z
// z = 10: r = 4.75
// 10 < z < 20: r = 3.75 + (z-10)/10*(4.75-3.75) = 3.75 + 0.1*(z-10)
// z = 20: r = 4.75
// 20 < z < 25: r = 3.75 + (z-20)/5*(6-3.75) = 3.75 + 0.45*(z-20)
// z = 25: r = 6
// 25 < z < 33: r = 3.25 + (z-25)/8*(2.5-3.25) = 3.25 - 0.09375*(z-25)
// z = 33: r = 2.5
// 33 < z < 41: r = 3.25 + (z-33)/8*(2.5-3.25) = 3.25 - 0.09375*(z-33)
// z = 41: r = 2.5
// 41 < z < 49: r = 2.5 + (z-41)/8*(6-2.5) = 2.5 + 0.4375*(z-41)
// z = 49: r = 6
// 49 < z < 57: r = 6 + (z-49)/8*(3.75-6) = 6 - 0.28125*(z-49)
// z = 57: r = 3.75

// Let's create the polygon points explicitly to avoid floating point errors in formulas.
// We will sample at the critical z-values and linearly interpolate if needed, 
// but since the profile is piecewise linear, we just need the vertices.

// Vertices:
// (3.75, 0)
// (4.75, 10)
// (3.75, 10)
// (4.75, 20)
// (3.75, 20)
// (6, 25)
// (3.25, 25)
// (2.5, 33)
// (3.25, 33)
// (2.5, 41)
// (3.25, 41)
// (6, 49)
// (3.75, 49)
// (3.75, 57)

// Wait, the user said "From z = 0 to z = 20...".
// And "From z = 25 to z = 41...".
// And "From z = 20 to z = 25: a cylindrical collar".
// So the total height is 57mm.
// The bore runs through the full length (0 to 57).

// Let's refine the points to match the "step back" description exactly.
// "grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm"
// This means at the top of the growth (z=10), the radius is 4.75. Then immediately at z=10, it steps to 3.75.
// So the profile goes:
// z=0, r=3.75
// z=10, r=4.75
// z=10, r=3.75 (step)
// z=20, r=4.75
// z=20, r=3.75 (step)
// z=20, r=6 (start of collar)
// z=25, r=6 (end of collar)
// z=25, r=3.25 (start of 5mm barb)
// z=33, r=2.5 (top of 5mm barb)
// z=3