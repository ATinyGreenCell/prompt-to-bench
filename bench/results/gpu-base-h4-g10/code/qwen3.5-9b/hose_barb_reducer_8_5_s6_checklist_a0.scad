// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints upright along Z, centered on origin in X and Y.

$fn = 128;

// Dimensions
z_start_8mm = 0;
z_end_8mm   = 20;
z_start_coll = 20;
z_end_coll  = 25;
z_start_5mm = 25;
z_end_5mm   = 41;

bore_d = 3;

// Barb 8mm specs
barb_8_height = 10;
barb_8_bottom_d = 7.5;
barb_8_top_d    = 9.5;
barb_8_step_d   = 7.5;

// Barb 5mm specs
barb_5_height = 8;
barb_5_bottom_d = 6.5;
barb_5_top_d    = 5.0;
barb_5_step_d   = 6.5;

// Collar specs
collar_d = 12;
collar_h = z_end_coll - z_start_coll;

// Generate the profile points for the 8mm section (z=0 to 20)
// Two barbs stacked: bottom (0-10), top (10-20)
// Each barb: linear growth then step back.
// Bottom barb: 0->7.5 (0->10), 7.5->9.5 (10->10), 9.5->7.5 (10->20)
// Top barb: 0->7.5 (0->10), 7.5->9.5 (10->10), 9.5->7.5 (10->20)
// Note: The prompt says "stacked". Usually this means one on top of the other.
// Let's assume they share the central axis and are adjacent vertically.
// Bottom barb: z=0 to 10. Top barb: z=10 to 20.
// Profile:
// z=0, r=3.75 (half of 7.5)
// z=10, r=4.75 (half of 9.5) - peak of bottom barb
// z=10, r=3.75 (half of 7.5) - step back
// z=20, r=4.75 (half of 9.5) - peak of top barb
// Wait, the prompt says "steps straight back to 7.5".
// Let's re-read carefully: "outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm".
// This implies a single barb shape.
// If stacked, we have two of these shapes.
// Shape 1 (Bottom): z=0 to 10. r goes 3.75 -> 4.75. Then at z=10, it steps back to 3.75?
// But the next barb starts at z=10.
// If they are stacked, the top of the bottom barb meets the bottom of the top barb.
// Let's assume the "step back" happens at the interface or just after.
// Interpretation:
// Barb 1 (0-10): r grows 3.75 -> 4.75. At z=10, r drops to 3.75.
// Barb 2 (10-20): r grows 3.75 -> 4.75. At z=20, r drops to 3.75.
// This creates a "sawtooth" profile where the peaks touch the valleys of the next segment?
// Or does the step happen inside the barb height?
// "each barb is 10 mm tall... grows... to 9.5... then steps straight back to 7.5".
// This implies the step is at the top of the barb.
// So:
// z=0, r=3.75
// z=10, r=4.75 (top of barb 1)
// z=10, r=3.75 (step down) -> Start of Barb 2?
// If Barb 2 starts at z=10 with r=3.75 and grows to 4.75 at z=20.
// This creates a continuous profile: 3.75 -> 4.75 -> 3.75 -> 4.75 -> 3.75.
// Let's construct the polygon for this.

// 8mm Section Profile (Radius vs Z)
// Points: [r, z]
p8 = [
    [3.75, 0],
    [4.75, 10],
    [3.75, 10],
    [4.75, 20],
    [3.75, 20]
];

// 5mm Section Profile (z=25 to 41)
// Two barbs stacked. Height 8mm each.
// Bottom barb: z=25 to 33. Top barb: z=33 to 41.
// Shape: r grows from half(bottom) to half(top), then steps back.
// Bottom: 3.25 -> 3.25 (wait, bottom is 6.5, top is 5.0).
// "shrinks linearly from 6.5 mm at its bottom to 5.0 mm at its top".
// So r goes 3.25 -> 2.5.
// Then "steps straight back out to 6.5". So r goes 2.5 -> 3.25.
// Barb 1 (25-33): r 3.25 -> 2.5. Step to 3.25.
// Barb 2 (33-41): r 3.25 -> 2.5. Step to 3.25.
// Profile:
// z=25, r=3.25
// z=33, r=2.5 (top of barb 1)
// z=33, r=3.25 (step out)
// z=41, r=2.5 (top of barb 2)
// z=41, r=3.25 (step out)

p5 = [
    [3.25, 25],
    [2.5, 33],
    [3.25, 33],
    [2.5, 41],
    [3.25, 41]
];

// Collar Section (z=20 to 25)
// Cylinder d=12. r=6.
// Profile:
// z=20, r=6
// z=25, r=6

pCollar = [
    [6, 20],
    [6, 25]
];

// Combine profiles
// We need to merge the 8mm section, the collar, and the 5mm section.
// 8mm ends at z=20. Collar starts at z=20. 5mm starts at z=25.
// There is a gap between z=25 and z=20? No, collar is 20-25.
// So the sequence is 0-20 (8mm), 20-25 (Collar), 25-41 (5mm).

// Construct full profile list
fullProfile = [
    // 8mm section
    [3.75, 0],
    [4.75, 10],
    [3.75, 10],
    [4.75, 20],
    [3.75, 20],
    // Collar section
    [6, 20],
    [6, 25],
    // 5mm section
    [3.25, 25],
    [2.5, 33],
    [3.25, 33],
    [2.5, 41],
    [3.25, 41]
];

// Create the main body using rotate_extrude
difference() {
    // Main body
    rotate_extrude($fn = 128) 
        polygon(fullProfile);
    
    // Bore
    translate([0, 0, -1]) 
        cylinder(h = 42, d = bore_d);
}