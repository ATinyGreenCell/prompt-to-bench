// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints standing upright along Z, centred on origin.

$fn = 128;

// Dimensions
z_start = 0;
z_8mm_end = 20;
z_collar_start = 20;
z_collar_end = 25;
z_5mm_end = 41;

// 8mm Tubing Barbs (z = 0 to 20)
// Two stacked barbs, each 10mm tall.
// Profile: OD grows 7.5 -> 9.5, then steps back to 7.5.
barb_8_height = 10;
barb_8_bottom_od = 7.5;
barb_8_top_od = 9.5;
barb_8_step_od = 7.5;

// 5mm Tubing Barbs (z = 25 to 41)
// Two stacked barbs, each 8mm tall.
// Profile: OD shrinks 6.5 -> 5.0, then steps back to 6.5.
barb_5_height = 8;
barb_5_bottom_od = 6.5;
barb_5_top_od = 5.0;
barb_5_step_od = 6.5;

// Common features
bore_diameter = 3;
collar_diameter = 12;

// Helper to create a tapered cylinder segment
// d1 = diameter at z_start, d2 = diameter at z_end
module tapered_cylinder(z_start, z_end, d1, d2) {
    translate([0, 0, z_start]) cylinder(h = z_end - z_start, d1 = d1, d2 = d2);
}

difference() {
    union() {
        // --- 8mm Tubing Barbs Section (z = 0 to 20) ---
        // Barb 1: z=0 to 10. OD grows 7.5 -> 9.5.
        tapered_cylinder(0, 10, barb_8_bottom_od, barb_8_top_od);
        // Step down to 7.5 at z=10.
        tapered_cylinder(10, 10.01, barb_8_top_od, barb_8_step_od); // Small step to avoid zero height
        // Barb 2: z=10.01 to 20. OD shrinks 7.5 -> 9.5? 
        // Spec: "OD grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm"
        // Wait, the spec says "two identical barbs... stacked".
        // Barb 1 (bottom): 7.5 -> 9.5.
        // Step: 9.5 -> 7.5.
        // Barb 2 (top): 7.5 -> 9.5.
        // Let's re-read carefully: "each barb is 10 mm tall and its outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm".
        // This implies the profile of ONE barb is: 7.5 -> 9.5 -> 7.5.
        // Since they are stacked, the sequence is:
        // 0-10: 7.5 -> 9.5
        // 10-10.01: 9.5 -> 7.5 (Step)
        // 10.01-20: 7.5 -> 9.5 (Second barb)
        
        // Corrected sequence for 8mm section:
        // 0-10: