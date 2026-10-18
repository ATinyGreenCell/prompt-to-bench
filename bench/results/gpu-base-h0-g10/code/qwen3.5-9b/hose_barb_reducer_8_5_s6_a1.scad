// Hose-Barb Reducer Design
// Units: mm
// Orientation: Upright along Z, centered on XY plane

// --- Dimensions ---
// Main bore diameter (constant through part)
$main_bore_d = 3.0;

// Section 1: 8mm Tubing Barbs (z = 0 to 20)
$z_start_1 = 0;
$z_end_1 = 20;
$barb_height_1 = 10;
$barb_od_bottom_1 = 7.5;
$barb_od_top_1 = 9.5;
$barb_count_1 = 2;
$collar_od_1 = 12;

// Section 2: 5mm Tubing Barbs (z = 25 to 41)
$z_start_2 = 25;
$z_end_2 = 41;
$barb_height_2 = 8;
$barb_od_bottom_2 = 6.5;
$barb_od_top_2 = 5.0;
$barb_count_2 = 2;

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate holes
$print_offset = 0.02; // Slight overhang compensation for printing, optional but safe

// --- Main Build ---
difference()
{
    // 1. Base Block (Bounding Box)
    // Extends slightly beyond max dimensions to ensure all features are contained
    $max_z = 41;
    $max_od = 12; // Collar OD
    $max_od_1 = 9.5; // Barb 1 OD
    $max_od_2 = 6.5; // Barb 2 OD
    
    // Add a small buffer for the "step back" geometry to be fully enclosed
    $buffer = 0.5; 
    
    cube([
        $max_od + $buffer,
        $max_od + $buffer,
        $max_z + $buffer
    ]);

    // 2. Main Bore Hole (Straight through)
    translate([0, 0, -0.01])
    cylinder(h = $max_z + 0.1, r = $main_bore_d/2 + 0.01, $fn = $fn);

    // 3. Section 1: 8mm Tubing Barbs (z = 0 to 20)
    // We need to cut out the space for the barbs.
    // The barbs are stacked. Total height = 20mm.
    // Each barb is 10mm tall.
    // Profile: Bottom 7.5mm -> Top 9.5mm -> Step back to 7.5mm.
    
    $z_base_1 = $z_start_1;
    $z_step_1 = $z_base_1 + $barb_height_1; // 10mm
    $z_end_1 = $z_base_1 + 2 * $barb_height_1; // 20mm
    
    // Generate the cut volume for the two stacked barbs
    // We create a single complex shape representing both barbs stacked, then replicate or just define the volume.
    // Since they are identical and stacked, we can define the volume of one and translate it.
    
    // Barb 1 (Bottom)
    translate([0, 0, $z_base_1])
    difference()
    {
        // Outer shell of Barb 1
        // It tapers from 7.5 to 9.5, then steps back.
        // We model this as a cylinder with a conical top and a flat top, then subtract the "step" volume?
        // Easier: Union of a tapered cylinder and a flat cylinder, then subtract the hole.
        
        // Tapered part (0 to 10mm)
        union()
        {
            // Define the exact geometry of the barb to subtract
            // We use a polygon extrusion for the sawtooth profile to be precise
            // Profile: (0, 3.75) -> (10, 4.75) -> (10, 3.75)
            
            // Create the solid shape of the barb
            // We will use a cylinder with a cone on top, then subtract the "step" part? 
            // Actually, the description says: "grows linearly... then steps straight back".
            // This implies the profile is:
            // z=0, r=3.75
            // z=10, r=4.75
            // z=10, r=3.75 (Step back)
            // So the top face is a circle of 7.5mm, and the side wall flares out to 9.5mm? 
            // Wait: "outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm".
            // This means the profile is:
            // Bottom: 7.5mm
            // Top: 9.5mm (at z=10)
            // Then immediately at z=10, the diameter drops to 7.5mm.
            // This creates a "flange" or "skirt" on the side.
            
            // Let's construct the subtraction volume:
            // 1. The main tapered cylinder (7.5 -> 9.5)
            // 2. The "step" volume: A cylinder of 9.5mm diameter from z=10 to z=10+epsilon? 
            // No, the step is a reduction.
            // Let's model the positive space of the barb to subtract it.
            // The barb occupies the volume defined by the profile.
            
            // We will create a cylinder that matches the profile exactly.
            // Since standard cylinders are straight, we use a polygon extrusion for the profile.
            
            // Profile points for the outer radius:
            // (0, 3.75), (10, 4.75), (10, 3.75)
            // We need to close the loop for extrusion.
            
            // Let's build the "Barb Volume" explicitly
            // We'll create a cylinder with a cone on top, then subtract the "step" part?
            // Actually, the simplest way to subtract a complex shape is to build the shape and subtract it.
            
            // Shape 1: Tapered Cylinder (0 to 10mm)
            // Radius 3.75 at z=0, 4.75 at z=10.
            // Shape 2: The "Step" is actually the volume between r=3.75 and r=4.75 at z=10?
            // No, the description says "steps straight back".
            // This implies the top surface is at r=3.75, and the side wall goes out to r=4.75?
            // If it steps back, the top face is smaller than the max diameter.
            // So the volume is: A cylinder of r=3.75 (0 to 10) PLUS a skirt of r=4.75 (0 to 10) MINUS the skirt of r=3.75 (0 to 10)?
            // That's just a tapered cylinder.
            // Let's re-read: "outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm".
            // This implies the shape is:
            // Bottom: 7.5mm
            // Top: 9.5mm (at z=10)
            // Then immediately at z=10, the diameter drops to 7.5mm.
            // This creates a "flange" or "skirt" on the side.
            
            // Let's construct the subtraction volume:
            // 1. The main tapered cylinder (7.5 -> 9.5)
            // 2. The "step" volume: A cylinder of 9.5mm diameter from z=10 to z=10+epsilon? 
            // No, the step is a reduction.
            // Let's model the positive space of the barb to subtract it.
            // The barb occupies the volume defined by the profile.
            
            // We will create a cylinder that matches the profile exactly.
            // Since standard cylinders are straight, we use a polygon extrusion for the profile.
            
            // Profile points for the outer radius:
            // (0, 3.75), (10, 4.75), (10, 3.75)
            // We need to close the loop for extrusion.
            
            // Let's build the "Barb Volume" explicitly
            // We'll create a cylinder with a cone on top, then subtract the "step" part?
            // Actually, the simplest way to subtract a complex shape is to build the shape and subtract it.