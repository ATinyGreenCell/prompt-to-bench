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
// Generates a cylinder with a sawtooth profile: linear taper then step back.
// To ensure printability and avoid singularities, the "step" is modeled as a 
// short vertical wall segment (step_height) at the top of the taper.
module sawtooth_barb(z_start, z_end, od_bottom, od_top, od_step, step_height = 1.0, $fn_val = 64) {
    h_taper = z_end - z_start;
    r_bottom = od_bottom / 2;
    r_top = od_top / 2;
    r_step = od_step / 2;
    
    // Part 1: Tapered Frustum
    // Constructed by unioning a cylinder (radius r_bottom) and a cone (radius r_top - r_bottom)
    // The cone is placed on top of the cylinder.
    // Cone height = h_taper.
    // Base of cone = r_bottom. Tip of cone = r_top.
    // Wait, a cone tapers to a point. We need a frustum.
    // Frustum = Cylinder(r_bottom, h_taper) UNION Cone(r_bottom, r_top, h_taper)?
    // If we put a cone with base r_bottom and tip at r_top (which is larger), it's an inverted cone.
    // Correct construction:
    // 1. Cylinder of radius r_bottom, height h_taper.
    // 2. Cone with base radius (r_top - r_bottom) at the top of the cylinder, tapering to a point? No.
    // We need the radius to grow from r_bottom to r_top.
    // So we take a Cylinder(r_bottom, h_taper) and add a Cone with base radius (r_top - r_bottom) 
    // sitting on top of the cylinder, but oriented such that it widens?
    // No, a standard cone tapers to a point.
    // We can create a frustum by taking a large cylinder and subtracting a cone?
    // Or simply: Cylinder(r_bottom, h_taper) UNION Cone(r_top, r_bottom, h_taper)?
    // If we have a cone with base r_top and tip r_bottom, and we place it on top of a cylinder r_bottom...
    // The union would be the frustum.
    // Let's verify:
    // Cylinder: z=0 to h, r=r_bottom.
    // Cone: Base at z=h, r=r_top. Tip at z=h+h_cone, r=r_bottom.
    // This creates a shape that widens as it goes up.
    // We want the frustum to end at z_end.
    // So the cone must end at z_end.
    // So the cone tip is at z_end, and base is at z_start? No, that tapers down.
    // We want it to taper up.
    // So the cone base is at z_start (r=r_bottom) and tip at z_end (r=r_top)? No, that's a cone.
    // We need a frustum.
    // Frustum = Cylinder(r_bottom, h_taper) UNION Cone(r_top, r_bottom, h_taper) placed on top?
    // If we place a cone with base r_top at z=h_taper and tip at z=h_taper + (h_taper * r_bottom / (r_top-r_bottom))? No.
    // Let's use the standard trick:
    // Frustum = Cylinder(r_bottom, h_taper) UNION Cone(r_top, r_bottom, h_taper)
    // where the cone is placed such that its base is at z=h_taper and its tip is at z=h_taper + h_taper * (r_bottom/r_top)? No.
    // Let's just use the difference method:
    // Large Cylinder (r_top, h_taper) MINUS Cone (r_top, r_bottom, h_taper) placed at bottom?
    // Let's try:
    // 1. Cylinder(r_top, h_taper).
    // 2. Cone with base r_top at z=0, tip at z=h_taper? No, that tapers to r_top.
    // We want to taper from r_bottom to r_top.
    // So we take a Cylinder(r_top, h_taper) and subtract a Cone with base r_top at z=h_taper and tip at z=0?
    // No, that would make it r_top at bottom and r_bottom at top.
    // We want r_bottom at bottom, r_top at top.
    // So we take a Cylinder(r_top, h_taper) and subtract a Cone with base r_top at z=0 and tip at z=h_taper?
    // No, that makes it r_top at bottom and r_bottom at top.
    // We want r_bottom at bottom.
    // So we take a Cylinder(r_top, h_taper) and subtract a Cone with base r_top at z=h_taper and tip at z=0?
    // No.
    // Let's try: Cylinder(r_bottom, h_taper) UNION Cone(r_top, r_bottom, h_taper) placed on top.
    // Cone: Base radius r_top, Tip radius r_bottom.
    // If we place the cone on top of the cylinder, the base of the cone is at z=h_taper.
    // The tip of the cone is at z=h_taper + h_taper * (r_top / (r_top - r_bottom))? No.
    // Let's define the cone dimensions:
    // Base radius = r_top.
    // Tip radius = r_bottom.
    // Height = h_taper * (r_top / (r_top - r_bottom))? No.
    // The slope is (r_top - r_bottom) / h_taper.
    // So the height of the cone needed to go from r_top to r_bottom is h_taper * (r_top / (r_top - r_bottom))? No.
    // The cone height is h_cone = h_taper * (r_top / (r_top - r_bottom))? No.
    // Let's just use the linear_extrude method for the frustum to be safe and simple.
    // We define a polygon that represents the radius profile.
    // Points: (0, r_bottom), (h_taper, r_top).
    // Then we extrude this polygon along Z? No, linear_extrude extrudes a 2D shape along Z.
    // If we extrude a line, we get a cylinder.
    // We need to rotate the line around Z.
    // So we use rotate_extrude.
    // Path: (0, r_bottom) to (h_taper, r_top).
    // This creates the frustum.
    
    // Part 2: Step
    // A cylinder of radius r_step, height step_height, placed on top of the frustum.
    // Since r_step = od_step / 2 = od_bottom / 2 = r_bottom, this matches the bottom of the frustum.
    // But the frustum ends at r_top.
    // So the step cylinder (r_step) is smaller than the frustum top (r_top).
    // So it will be inside the frustum if placed at the same level.
    // We need to place it ON TOP of the frustum.
    // So the step cylinder starts at z_end and goes to z_end + step_height.
    // Its radius is r_step.
    // Since r_step < r_top, there is a vertical drop (overhang) from r_top to r_step.
    // This creates the "step" profile.
    
    // Construction:
    // 1. Frustum: rotate_extrude with path from (0, r_bottom) to (h_taper, r_top).
    // 2. Step: cylinder(r_step, h=step_height) translated to z = z_start + h_taper.
    
    // Fr