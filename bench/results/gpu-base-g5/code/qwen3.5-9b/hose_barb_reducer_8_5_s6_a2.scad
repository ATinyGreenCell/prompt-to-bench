// Hose-Barb Reducer Design
// Units: mm
// Orientation: Upright along Z, centered on XY plane

// --- Dimensions ---
// Main bore diameter (constant through part)
$main_bore_d = 3.0;

// Upper Section (8mm tubing)
$z_start_upper = 0;
$z_end_upper = 20;
$barb_count_upper = 2;
$barb_height_upper = 10;
$barb_od_bottom_upper = 7.5;
$barb_od_top_upper = 9.5;
$barb_od_step_upper = 7.5; // Step back to this OD after the taper

// Collar Section
$z_start_collar = 20;
$z_end_collar = 25;
$collar_od = 12.0;

// Lower Section (5mm tubing)
$z_start_lower = 25;
$z_end_lower = 41;
$barb_count_lower = 2;
$barb_height_lower = 8;
$barb_od_bottom_lower = 6.5;
$barb_od_top_lower = 5.0;
$barb_od_step_lower = 6.5; // Step back to this OD after the taper

// --- Helper Functions ---

// Function to create a single stepped tapered barb
// z_min: Bottom Z of the barb
// z_max: Top Z of the barb
// od_bottom: Outer diameter at z_min
// od_top: Outer diameter at z_max (peak of taper)
// od_step: Outer diameter of the flat top surface (after step back)
// od_bore: Diameter of the central hole
function stepped_barb(z_min, z_max, od_bottom, od_top, od_step, od_bore) =
    union() {
        // Part 1: The main body (Cylinder from bottom to top of taper)
        // This creates the shape from od_bottom to od_top
        $r_bot = od_bottom / 2;
        $r_top = od_top / 2;
        $h = z_max - z_min;
        
        $body = cylinder(
            h = $h,
            r1 = $r_bot,
            r2 = $r_top,
            center = [0, 0, z_min + $h/2],
            $fn = 64
        );
        
        // Part 2: The "Step Back"
        // We need a flat top surface of diameter od_step.
        // The body above ends at radius r_top (od_top/2).
        // We need to add a cylinder of radius od_step/2 that sits on top of the body?
        // No, that would make it taller.
        // We need to add a cylinder of radius od_step/2 that sits on top of the body, 
        // but the body already exists up to z_max.
        // The "step back" implies a vertical wall going down from the peak.
        // So we need a cylinder of radius od_step/2 that starts at z_max and goes up? No.
        // We need a cylinder of radius od_step/2 that starts at z_max and goes... where?
        // Actually, the simplest way to model "Taper up to X, then step back to Y" is:
        // 1. Cylinder of radius Y (od_step/2) from z_min to z_max.
        // 2. Frustum from z_min to z_max, radius Y to radius X (od_top/2).
        // Union these two.
        // The result is: Bottom radius Y, expands to X at z_max.
        // The top face is radius X.
        // This does NOT create a step back. It creates a mushroom cap.
        
        // Re-evaluating "steps straight back":
        // Profile: Z=0 (r=3.75) -> Z=10 (r=4.75) -> Z=10+ (r=3.75).
        // This means at Z=10, there is a vertical face going from r=4.75 down to r=3.75.
        // This creates a flat top surface at Z=10 with radius 3.75.
        // How to build this?
        // 1. Cylinder r=3.75 from Z=0 to Z=10.
        // 2. Frustum r=3.75 to r=4.75 from Z=0 to Z=10.
        // Union these? No, that makes the top r=4.75.
        // We need the top to be r=3.75.
        // So:
        // 1. Cylinder r=3.75 from Z=0 to Z=10.
        // 2. Frustum r=3.75 to r=4.75 from Z=0 to Z=10.
        // Wait, if I union a cylinder (r=3.75) and a frustum (r=3.75->4.75), the union is just the frustum because the frustum contains the cylinder?
        // No, the frustum is wider at the top.
        // The union of a cylinder (r=3.75) and a frustum (r=3.75->4.75) is the frustum.
        // The top face is r=4.75.
        
        // Correct construction for "Step Back":
        // We need the shape to be:
        // - From Z=0 to Z=10: Radius expands from 3.75 to 4.75.
        // - At Z=10: Radius drops instantly to 3.75.
        // - From Z=10 upwards: Radius is 3.75.
        // This implies the object continues upwards with radius 3.75?
        // The prompt says "steps straight back to 7.5 mm". It doesn't say it stops.
        // But the next section starts at Z=20.
        // So between Z=10 and Z=20, what is there?
        // "From z = 0 to z = 20: two identical barbs... stacked".
        // Barb 1: Z=0 to Z=10.
        // Barb 2: Z=10 to Z=20.
        // So Barb 1 ends at Z=10. Barb 2 starts at Z=10.
        // Barb 1 profile: 7.5 -> 9.5 -> 7.5.
        // Barb 2 profile: 7.5 -> 9.5 -> 7.5.
        // So at Z=10, Barb 1 has a top face of 7.5. Barb 2 has a bottom face of 7.5.
        // They mate perfectly.
        
        // So the shape of Barb 1 is:
        // 1. Taper from r=3.75 to r=4.75 (Z=0 to Z=10).
        // 2. Step down to r=3.75 at Z=10.
        // 3. Continue with r=3.75? No, the barb is only 10mm tall.
        // So the barb is just the tapered part + the step.
        // The "step back" creates the top surface.
        // So the solid is:
        // - Cylinder r=3.75 from Z=0 to Z=10.
        // - Frustum r=3.75 to r=4.75 from Z=0 to Z=10.
        // Union these? No, that's just the frustum.
        // We need the top to be r=3.75.
        // So we need to ADD a cylinder of r=3.75 on top of the frustum?
        // If we add a cylinder of r=3.75 from Z=10 to Z=10 (height 0), it's a disk.
        // If we add a cylinder of r=3.75 from Z=10 to Z=10+epsilon, it extends the part.
        // But the part is only 10mm tall.
        // So the "step back" is just the top face of the part.
        // The part is defined by the profile.
        // Profile: Line from (0, 3.75) to (10, 4.75). Then a vertical line from (10, 4.75) to (10, 3.75).
        // This encloses the area.
        // How to model this in OpenSCAD?
        // 1. Cylinder r=3.75, h=10.
        // 2. Frustum r=3.75->4.75, h=10.
        // Union? No.
        // 1. Cylinder r=3.75, h=10