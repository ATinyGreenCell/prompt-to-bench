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

// --- Helper Function for Sawtooth Barb ---
// Generates a cylinder with a sawtooth profile: linear taper then step back
module sawtooth_barb(z_start, z_end, od_bottom, od_top, od_step, $fn_val = 64) {
    // Calculate the step height (where the diameter jumps back)
    // The profile goes: bottom -> top -> step -> bottom
    // We split the cylinder into two parts: the tapered part and the stepped part
    
    // Part 1: Tapered section (bottom to top)
    // Linear interpolation of radius
    h1 = z_end - z_start;
    r_bottom = od_bottom / 2;
    r_top = od_top / 2;
    
    // Create a cylinder with a linearly varying radius
    // We use a polygon rotated around Z, or a cylinder with a custom path?
    // Easiest way in OpenSCAD for a tapered cylinder with a flat top is to use a cylinder
    // but we need the top to be smaller than the bottom, then a flat rim.
    // Actually, the prompt says: "grows linearly... then steps straight back".
    // This implies a shape like a funnel that suddenly widens at the top.
    
    // Let's construct this using a cylinder with a specific radius profile.
    // Since standard cylinder has constant radius, we use linear_extrude with a polygon.
    
    // Define the polygon points for the cross-section (radius vs height)
    // We need to extrude a shape that represents the radius at each Z.
    // However, linear_extrude extrudes a 2D shape along Z.
    // Let's define the 2D shape as a line from (0, r_bottom) to (h1, r_top).
    // Then we need to add the "step" part.
    
    // Alternative approach: Union of a tapered cylinder and a flat cylinder on top?
    // No, the step is at the very top of the taper.
    // Shape: Cone frustum (bottom to top) + Cylinder (top to step_height).
    // Wait, the prompt says "steps straight back to 7.5".
    // So at z = z_end, the OD jumps from 9.5 to 7.5.
    // Then it stays at 7.5 until z = z_end + step_height?
    // The prompt doesn't specify the step height, just that it steps back.
    // Usually, this implies a small flat rim or just the transition.
    // "steps straight back to 7.5 mm" implies the profile goes 9.5 -> 7.5 instantly.
    // Let's assume the step happens at the very top of the 10mm height, and the 7.5mm diameter
    // continues to the next section.
    // So the shape is: Frustum (7.5->9.5) + Cylinder (9.5->7.5 transition? No, instant step).
    // If it's an instant step, it's a Frustum (7.5->9.5) connected to a Cylinder (7.5).
    // But there is a discontinuity at the top.
    // Let's model it as: Frustum (bottom to top) UNION Cylinder (top to top+epsilon)?
    // No, let's look at the geometry:
    // Bottom (z=0): OD=7.5
    // Top (z=10): OD=9.5
    // Immediately above z=10: OD=7.5
    
    // We can model this as a Frustum (0 to 10) and a Cylinder (10 to 10+delta) where delta is small?
    // Or simply a Frustum (0 to 10) and a Cylinder (0 to 10) with OD=7.5?
    // If we union a Frustum (7.5->9.5) and a Cylinder (7.5) of height 10, the result is:
    // Bottom 7.5, Top 9.5, and the sides of the cylinder (7.5) are inside the frustum?
    // No, the frustum gets wider. The cylinder (7.5) is narrower than the frustum (which goes up to 9.5).
    // So the union would just be the Frustum.
    // We need the "step back". This means at the top, the diameter shrinks.
    // So we need a Frustum (7.5->9.5) and then a Cylinder (9.5->7.5)? No, that's a taper.
    // We need a Frustum (7.5->9.5) and then a Cylinder (7.5) that sticks out? No.
    // The shape must be: Start 7.5, grow to 9.5, then immediately become 7.5.
    // This creates a "shoulder" or a "lip" at the top.
    // To model this, we can create a Frustum (7.5->9.5) and a Cylinder (7.5) of height 10.
    // The union of these two is just the Frustum because the cylinder is entirely inside the frustum's volume?
    // Wait. Frustum radius at z: r(z) = r_bot + (r_top - r_bot)*(z/h).
    // Cylinder radius: r_cyl = r_bot.
    // Since r(z) >= r_bot for all z in [0, h], the cylinder is inside the frustum.
    // Union = Frustum.
    // We need the reverse: The part should be WIDER at the top, then narrow.
    // So the volume is the Frustum PLUS a small cylinder on top? No.
    // The volume is the Frustum, but we need to cut it? No.
    // Let's re-read: "outer diameter grows linearly from 7.5... to 9.5... then steps straight back to 7.5".
    // This describes the profile line.
    // If we extrude a shape that goes 7.5 -> 9.5 -> 7.5, we get a shape that widens then narrows.
    // But the "step" implies no taper on the way back.
    // So the profile is: Line up, Vertical drop.
    // This creates a shape that looks like a funnel with a flat top rim?
    // No, if it steps back to 7.5, the top surface is at 9.5, and the side wall drops vertically to 7.5.
    // So we need a Frustum (7.5->9.5) and a Cylinder (9.5->7.5)? No.
    // We need a Frustum (7.5->9.5) and a Cylinder (7.5) that is OFFSET?
    // Let's try this:
    // 1. Frustum from 0 to 10 (7.5 -> 9.5).
    // 2. Cylinder from 0 to 10 (7.5).
    // Union = Frustum.
    // We need the cylinder to be ON TOP of the frustum?
    // If we put a cylinder of OD 7.5 on top of the frustum (at z=10), it will be smaller than the frustum top (9.5).
    // So it will be inside.
    // We need the cylinder to be LARGER than the frustum top? No.
    // We need the shape to be: Bottom 7.5, Middle 9.5, Top 7.5.
    // This requires a "neck" at the top.
    // So: Frustum (7.5->9.5) + Cylinder (9.5->7.5)? No, that's a taper.
    // We need a Frustum