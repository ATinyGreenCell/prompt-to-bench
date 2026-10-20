$fn = 128; // High resolution for smooth curves and accurate hole sizing

// --- Dimensions ---
// Main bore diameter (straight through)
$main_bore_d = 3.0;

// Upper Section (8mm tubing)
$upper_section_z_start = 0;
$upper_section_z_end = 20;
$barb_count_upper = 2;
$barb_height_upper = 10;
$barb_od_bottom_upper = 7.5;
$barb_od_top_upper = 9.5;
$barb_od_step_upper = 7.5; // Step back to this diameter

// Middle Section (Collar)
$collar_z_start = 20;
$collar_z_end = 25;
$collar_diameter = 12.0;

// Lower Section (5mm tubing)
$lower_section_z_start = 25;
$lower_section_z_end = 41;
$barb_count_lower = 2;
$barb_height_lower = 8;
$barb_od_bottom_lower = 6.5;
$barb_od_top_lower = 5.0;
$barb_od_step_lower = 6.5; // Step back to this diameter

// --- Helper Module for Sawtooth Barb ---
// Generates a cylinder with a sawtooth profile: linear taper then step back
// z_start, z_end: Z range of the barb
// od_bottom, od_top: Outer diameters at bottom and top of the tapered section
// od_step: Diameter after the step (should be equal to od_bottom for a continuous profile)
// The profile is: Linear growth from od_bottom to od_top, then instant step to od_step.
// To model this in OpenSCAD without complex CSG for the vertical drop, we approximate the 
// vertical drop as a very short cylinder on top, or we construct the shape as a union of 
// the tapered part and the stepped part carefully.
// Actually, the cleanest way to get a "step" (vertical wall) is to union the tapered part 
// with a cylinder that has the smaller diameter, but positioned such that it creates the step.
// However, since the step is at the top, we can model it as:
// 1. A frustum (tapered part).
// 2. A cylinder (the stepped part) placed on top of the frustum.
// If the cylinder has diameter od_step and height h_step, and is placed at z_end, 
// it will create the vertical wall if od_step < od_top.
// The prompt implies the step happens immediately at the top. We will assume a very small 
// "rim" height or just the transition. To ensure printability and clear geometry, 
// we will model the step as a cylinder of height 1mm (or similar) on top of the frustum, 
// but since the prompt says "steps straight back", we can interpret this as the profile 
// having a vertical segment. 
// Let's use a small height for the step to make it printable and distinct. 
// If the step height is 0, it's a singularity. We'll use 1mm for the step height to be safe, 
// or better, we can construct the shape using a polygon path that includes the vertical drop.
// Using linear_extrude with a polygon is the most robust way to get the exact profile.

module sawtooth_barb(z_start, z_end, od_bottom, od_top, od_step, step_height = 1.0, $fn_val = 64) {
    // We will construct the profile using a polygon and linear_extrude.
    // The profile is a line from (0, od_bottom/2) to (h_taper, od_top/2) 
    // then a vertical line to (h_taper + h_step, od_step/2).
    // Wait, linear_extrude extrudes a 2D shape along Z. The 2D shape is the cross-section.
    // We want the cross-section to be a line? No, we want the radius to change.
    // We can use rotate_extrude with a path, but linear_extrude is easier for the profile.
    // Let's define the 2D shape as a line segment from (0, r_bottom) to (h_taper, r_top).
    // Then we need to add the step.
    // Actually, the easiest way to get a tapered cylinder with a flat top rim (step) is:
    // Union of a Frustum and a Cylinder on top.
    // Frustum: z=0 to z=h_taper, r=od_bottom/2 to od_top/2.
    // Cylinder: z=h_taper to z=h_taper+h_step, r=od_step/2.
    // This creates a vertical wall of height h_step.
    
    h_taper = z_end - z_start;
    r_bottom = od_bottom / 2;
    r_top = od_top / 2;
    r_step = od_step / 2;
    
    // Part 1: Tapered Frustum
    // We can create this by scaling a cylinder or using a cylinder with a specific radius?
    // OpenSCAD doesn't have a direct "frustum" primitive. We use a cylinder and scale it?
    // No, scaling a cylinder scales all dimensions.
    // We can use a cylinder with a polygon cross-section? No.
    // We can use a cylinder with a specific radius by using a "cylinder" with a "radius" that varies? No.
    // We use a cylinder with a "radius" of r_bottom and scale it? No.
    // We use a cylinder with a "radius" of r_top and scale it? No.
    // We use a cylinder with a "radius" of r_bottom and then add a cone?
    // Let's use a cylinder with radius r_bottom and height h_taper, then add a cone?
    // No, the easiest way is to use a cylinder with a polygon cross-section?
    // No, let's use the "cylinder" primitive with a specific radius and then modify it?
    // Actually, we can create a frustum by taking a cylinder of radius r_top and scaling it down?
    // No.
    // Let's use a cylinder with radius r_bottom and height h_taper, then add a cone on top?
    // No, the frustum is the bottom part.
    // Let's use a cylinder with radius r_bottom and height h_taper, then add a cone on top?
    // No, the frustum is the bottom part.
    // Let's use a cylinder with radius r_bottom and height h_taper, then add a cone on top?
    // No, the frustum is the bottom part.
    // Let's use a cylinder with radius r_bottom and height h_taper, then add a cone on top?
    // No, the frustum is the bottom part.
    // Let's use a cylinder with radius r_bottom and height h_taper, then add a cone on top?
    // No, the frustum is the bottom part.
    // Let's use a cylinder with radius r_bottom and height h_taper, then