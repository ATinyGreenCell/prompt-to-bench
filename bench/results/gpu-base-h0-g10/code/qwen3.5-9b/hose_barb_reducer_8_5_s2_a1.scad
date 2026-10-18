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
    
    union() {
        // Section 1: Sawtooth Barbs (8mm tubing)
        // Barb 1 (Bottom): z=0 to 10. OD grows 7.5 -> 9.5 linearly.
        // Barb 2 (Top): z=10 to 20. OD grows 7.5 -> 9.5 linearly.
        // "Steps straight back" implies the tip is the max diameter, then it drops.
        // We model the taper as a frustum.
        
        // Bottom Barb (z=0 to 10)
        translate([0, 0, $sec1_start_z])
        linear_extrude(height = $barb_height_1, center = true, convexity = 3)
        circle(r = $barb_base_od_1 / 2); // Start radius
        
        // To get the linear growth, we need a polygon or two cylinders.
        // Using two cylinders for the taper is easier and robust.
        // Cylinder 1: z=0 to 5, r=3.75 to 4.75 (linear)
        // Cylinder 2: z=5 to 10, r=4.75 to 4.75 (flat top? No, prompt says linear growth over the barb)
        // "grows linearly from 7.5 mm at its bottom to 9.5 mm at its top"
        // This implies the entire 10mm height is the taper.
        // So at z=0, r=3.75. At z=10, r=4.75.
        // We can use a cone, but a cone has a point at the top if we don't specify the top radius.
        // A cone in OpenSCAD with r1 and r2 creates a frustum.
        
        // Let's use a cone for the taper.
        // Bottom Barb:
        translate([0, 0, $sec1_start_z])
        cone(h = $barb_height_1, r1 = $barb_base_od_1 / 2, r2 = $barb_tip_od_1 / 2, $fn = $fn);
        
        // Top Barb:
        translate([0, 0, $sec1_start_z + $barb_height_1])
        cone(h = $barb_height_1, r1 = $barb_base_od_1 / 2, r2 = $barb_tip_od_1 / 2, $fn = $fn);
        
        // Now the "step back".
        // The prompt says "then steps straight back to 7.5 mm".
        // This implies the tip (9.5mm) is the peak, and immediately below/around it, it is 7.5mm.
        // Since the cone ends at 9.5mm at z=20, we need to add the 7.5mm section.
        // But the cone already occupies the space from z=10 to z=20.
        // The "step back" likely refers to the geometry of the barb itself:
        // It's a protrusion. Base is 7.5. It tapers up to 9.5. Then it drops to 7.5.
        // If the barb is 10mm tall, and it tapers the whole way, the top is 9.5.
        // Where does the 7.5mm come back in?
        // Interpretation: The barb is a "mountain" on top of the 7.5mm cylinder.
        // But the prompt says "From z=0 to z=20: two identical barbs... stacked".
        // This implies the object is continuous.
        // Maybe the "barb" is the tapered part, and the "step" is the return to the base diameter *at the top*?
        // If so, the shape is: Cylinder (7.5) -> Taper (7.5 to 9.5) -> Step (9.5 to 7.5).
        // But the taper is 10mm tall. So the step happens at z=20.
        // This means the object at z=20 is 9.5mm wide, and for z>20 it is 7.5mm wide?
        // No, the next section starts at z=20.
        // Let's assume the "step back" is a small flat top or a sharp re-entrant corner at the very tip.
        // Given "steps straight back", I will model it as:
        // The cone goes from 7.5 to 9.5.
        // Then, to "step back", we need a cylinder of 7.5mm diameter sitting on top of the cone?
        // No, that would make it wider at the top.
        // It must be that the cone is the "barb", and the "step back" is the transition to the next section or the base.
        // Let's re-read carefully: "outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm".
        // This describes the profile of the barb itself.
        // Profile: Start 7.5 -> End 9.5 -> Step to 7.5.
        // If the height is 10mm, and the growth is linear over the 10mm, then at the top (z=10 relative to barb start) it is 9.5.
        // Then it steps to 7.5.
        // This implies the barb is a "tent" shape? No, a cone is a tent.
        // If it steps back, it means the diameter decreases instantly.
        // So the shape is: Cylinder (7.5) + Cone (7.5 to 9.5) + Cylinder (9.5 to 7.5)? No.
        // It's Cylinder (7.5) + Cone (7.5 to 9.5) + Cylinder (7.5, height 0)?
        // Maybe the "step back" is the return to the base diameter *before* the next section starts?
        // Let's assume the "barb" is the protrusion.
        // The object consists of a base cylinder (7.5mm) and two barbs on top.
        // Barb 1: z=0 to 10. Base 7.5. Taper to 9.5. Step to 7.5.
        // This implies the 7.5mm cylinder continues through z=10?
        // If so, the barb is just the tapered part (7.5 to 9.5) sitting on the 7.5mm cylinder.
        // But the prompt says "From z=0 to z=20: two identical barbs... stacked".
        // This suggests the *entire* volume from 0 to 20 is the barbs.
        // If the barbs are stacked, and each is 10mm tall.
        // Barb 1: z=0 to 10.
        // Barb 2: z=10 to 20.
        // If Barb 1 is a cone (7.5 to 9.5), and it "steps back" to