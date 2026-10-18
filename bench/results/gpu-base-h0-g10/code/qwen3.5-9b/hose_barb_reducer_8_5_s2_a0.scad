// Hose-barb Reducer Design
// Units: millimetres
// Orientation: Standing upright along Z, resting on XY plane at z=0

// --- Dimensions ---
// Main bore diameter (constant through part)
$main_bore_d = 3.0;

// Section 1: 8mm Tubing Barbs (z = 0 to 20)
$sec1_start_z = 0;
$sec1_end_z = 20;
$barb_count_1 = 2;
$barb_height_1 = 10;
$barb_base_od_1 = 7.5;
$barb_tip_od_1 = 9.5;
$barb_step_od_1 = 7.5; // Diameter after the tip step

// Section 2: Collar (z = 20 to 25)
$sec2_start_z = 20;
$sec2_end_z = 25;
$collar_od = 12.0;

// Section 3: 5mm Tubing Barbs (z = 25 to 41)
$sec3_start_z = 25;
$sec3_end_z = 41;
$barb_count_3 = 2;
$barb_height_3 = 8;
$barb_base_od_3 = 6.5;
$barb_tip_od_3 = 5.0;
$barb_step_od_3 = 6.5; // Diameter after the tip step

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate hole sizing

// --- Main Body Construction ---
difference() {
    // 1. Create the main solid body by stacking sections
    // We build the outer shell and subtract the central bore
    
    // Helper function to generate a stepped cylinder profile
    // This is done manually inside the loop for clarity and control
    union() {
        // Section 1: Sawtooth Barbs (8mm tubing)
        // We create a single complex shape for the two stacked barbs
        // Since they are identical and stacked, we can extrude a 2D profile or build 3D primitives.
        // Building 3D primitives is more robust for the "step back" geometry.
        
        // Base of Section 1 (z=0 to 10) - Bottom Barb
        translate([0, 0, $sec1_start_z])
        cylinder(h = $barb_height_1, r = $barb_base_od_1 / 2, $fn = $fn);
        
        // Top of Section 1 (z=10 to 20) - Top Barb
        translate([0, 0, $sec1_start_z + $barb_height_1])
        cylinder(h = $barb_height_1, r = $barb_base_od_1 / 2, $fn = $fn);
        
        // The "Sawtooth" tip: A smaller cylinder on top of the top barb
        translate([0, 0, $sec1_start_z + $barb_height_1 + $barb_height_1])
        cylinder(h = 0, r = $barb_tip_od_1 / 2, $fn = $fn); // This is just a point, we need the transition
        
        // Correct approach for Sawtooth:
        // The profile is: Base OD -> Linear Grow -> Tip OD -> Step Back -> Base OD
        // Since the prompt says "steps straight back to 7.5 mm", it implies a flat top section or a sharp step.
        // "Grows linearly... then steps straight back". This implies a pyramid tip.
        // Let's construct the two barbs explicitly.
        
        // Barb 1 (Bottom): z=0 to 10. OD 7.5.
        // Barb 2 (Top): z=10 to 20. OD 7.5.
        // Tip: z=20 to 20+delta? No, the prompt says "grows... then steps".
        // Interpretation: The barb is 10mm tall. The OD grows from 7.5 to 9.5 over the 10mm?
        // "each barb is 10 mm tall and its outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top"
        // Then "steps straight back to 7.5 mm".
        // This implies the 10mm height includes the growth. The step happens at the very top.
        // So at z=20, the OD is 9.5. Then it steps back to 7.5 immediately? That would be a sharp edge.
        // Usually, there is a small flat top. However, strictly following "steps straight back":
        // We will model the growth over the 10mm height.
        // To model a linear growth in OpenSCAD without complex CSG math, we use a cone or a scaled cylinder.
        // A cone from r=3.75 to r=4.75 over height 10.
        
        // Let's rebuild Section 1 as a union of two cones/cylinders to get the taper.
        // Actually, the prompt says "grows linearly... then steps".
        // If the barb is 10mm tall, and it grows from 7.5 to 9.5, the slope is constant.
        // At the very top (z=20), it is 9.5. Then it steps back to 7.5.
        // This creates a sharp re-entrant corner.
        
        // Re-evaluating "Stacked": Two identical barbs.
        // Barb 1: z=0 to 10.
        // Barb 2: z=10 to 20.
        // Both have the same profile: Start 7.5, End 9.5 (linear), then step to 7.5.
        
        // Let's create the profile for ONE barb and stack it.
        // Profile:
        // z=0 to 10: Radius grows from 3.75 to 4.75. (Cone)
        // z=10: Radius is 4.75.
        // Step to 3.75.
        
        // Wait, if I just extrude a cone, the top is a point or a flat circle?
        // A cone in OpenSCAD has a flat top if specified with two radii.
        // Let's define the shape of one barb:
        // It is a frustum (cone) from r=3.75 to r=4.75, height 10.
        // Then a flat top of r=4.75? No, "steps straight back".
        // So the top surface is at r=4.75, but immediately below that (or at that level) it drops to r=3.75?
        // That doesn't make sense physically for a barb.
        // Standard interpretation: The barb tapers up to a tip, then the main body continues.
        // But the prompt says "steps straight back to 7.5 mm".
        // This implies the "barb" is the protrusion.
        // So: Base (7.5) -> Taper Up to (9.5) -> Step Down to (7.5).
        // This creates a "mountain" shape on top of the 7.5mm cylinder.
        // But the prompt says "each barb is 10 mm tall".
        // So the entire 10mm height is the taper?
        // If the entire 10mm is the taper, then at z=10, r=4.75.
        // Then it steps back to r=3.75.
        // This means the "barb" is the tapered part, and the "step" is the return to the base diameter.
        // This creates a shape that looks like a cone sitting on a cylinder, but the cone is the whole 10mm height.
        // Let's assume the 10mm height is the tapered section.
        
        // Revised Plan for Section 1:
        // We need a shape that is 7.5mm OD for the first 0mm? No.
        // "From z=0 to z=20: two identical barbs... stacked".
        // This implies the object exists from 0 to 20.
        // Barb 1: z=0 to 10. Profile: 7.5 -> 9.5 (linear) -> step to 7.5.
        // Barb 2: z=10 to 20. Profile: 7.5 -> 9.5 (linear) -> step to 7.5.
        
        // How to model "7.5 -> 9.5 -> step to 7.5" in 10mm height?
        // Option A: 10mm is the taper. Top is 9.5. Then step down.
        // Option B: Taper is shorter,