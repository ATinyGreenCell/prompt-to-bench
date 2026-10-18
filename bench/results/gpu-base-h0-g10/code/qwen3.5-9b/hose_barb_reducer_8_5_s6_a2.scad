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

// --- Helper: Create a hollow cylinder with a specific height ---
// Returns a module that can be translated
module hollow_cylinder(h, od, id, z_pos = 0) {
    translate([0, 0, z_pos])
    difference() {
        cylinder(h = h, r = od/2, $fn = $fn);
        cylinder(h = h + 0.1, r = id/2 + 0.01, $fn = $fn); // Slight extension for clean cut
    }
}

// --- Helper: Create a complex barb shape for subtraction ---
// Profile: Linear taper from bottom_od to top_od, then step back to bottom_od
// This creates a shape that is wider at the top than the bottom, with a flat top surface at bottom_od
// We construct this by unioning a tapered cylinder and a "step" cylinder? 
// Actually, the description "steps straight back" implies the top face is smaller.
// So the volume is: A cylinder of radius r_bottom, PLUS a skirt of (r_top - r_bottom) that exists only at the top?
// No, "outer diameter grows... to 9.5... then steps back".
// This means the side wall goes out to 9.5, but the top face is at 7.5.
// So the shape is: A cylinder of r=3.75 (0 to 10) UNION a cylinder of r=4.75 (0 to 10) MINUS a cylinder of r=3.75 (0 to 10)?
// That's just a tapered cylinder.
// Let's re-read carefully: "outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm".
// This implies the profile is:
// z=0, r=3.75
// z=10, r=4.75
// z=10, r=3.75 (Step back)
// This describes a shape where the side wall flares out, but the top surface is flat at the smaller diameter.
// This is physically impossible if the side wall is continuous and the top is flat at a smaller diameter, unless there is a vertical wall going down from the flare.
// Interpretation: The barb has a tapered section (7.5 to 9.5) and then a vertical section (9.5 to 7.5)?
// No, "steps straight back" usually means the diameter reduces instantly.
// So the shape is: A tapered cylinder (7.5->9.5) capped with a flat top at 7.5?
// If the side is tapered to 9.5 at z=10, and the top is 7.5 at z=10, there must be a vertical wall from z=10 downwards?
// Or is it: Tapered from 7.5 to 9.5, then immediately at z=10, the diameter becomes 7.5?
// This implies a "shoulder" or "flange" on the side.
// Let's assume the shape is:
// 1. A cylinder of r=3.75 from z=0 to z=10.
// 2. A tapered skirt from r=3.75 (at z=0) to r=4.75 (at z=10).
// Wait, if it tapers from 7.5 to 9.5, the radius goes from 3.75 to 4.75.
// If it then steps back to 7.5, the radius goes from 4.75 to 3.75 instantly at z=10.
// This creates a shape that looks like a cone on top of a cylinder, but the top of the cone is smaller than the base of the cone?
// No, a cone tapers down.
// Let's assume the user means:
// Bottom: 7.5mm.
// Top: 9.5mm.
// Then at the top, it steps back to 7.5mm.
// This implies the top face is 7.5mm, and the side wall goes out to 9.5mm.
// This requires a vertical wall segment from z=10 down to some point?
// Or maybe the "step back" is a typo and they mean the top is 9.5 and the bottom is 7.5?
// But they explicitly say "steps straight back".
// Let's assume the shape is:
// A cylinder of r=3.75 (0 to 10).
// PLUS a tapered cylinder of r=3.75 (at z=0) to r=4.75 (at z=10).
// PLUS a cylinder of r=4.75 (0 to 10) MINUS the tapered part?
// This is getting confusing.
// Let's try the most logical interpretation for a "barb":
// It's a tapered cylinder (7.5 -> 9.5) and then a flat top at 7.5?
// If the side is tapered to 9.5 at z=10, and the top is 7.5 at z=10, there is a gap.
// Unless the "step back" happens *before* the top?
// "grows linearly... to 9.5... then steps straight back to 7.5".
// This implies the sequence: 7.5 -> 9.5 -> 7.5.
// This creates a shape with a "waist" or "shoulder".
// Let's model it as:
// 1. A cylinder of r=3.75 from z=0 to z=10.
// 2. A tapered cylinder from r=3.75 (z=0) to r=4.75 (z=10).
// 3. A cylinder of r=4.75 from z=10 to z=10? No.
// Let's assume the shape is:
// A cylinder of r=3.75 (0 to 10).
// PLUS a tapered cylinder of r=3.75 (z=0) to r=4.75 (z=10).
// PLUS a cylinder of r=4.75 (0 to 10) MINUS the tapered part?
// No, let's just build the volume defined by the profile.
// Profile: (0, 3.75) -> (10, 4.75) -> (10, 3.75).
// This is a triangle in the r-z plane.
// Extruding this triangle gives a cone.
// But the user says "steps straight back".
// This implies a vertical line from (10, 4.75) to (10, 3.75)?
// If so, the profile is: (0, 3.75) -> (10, 4.75) -> (10, 3.75) -> (0, 3.75).
// This creates a shape that is a cone (tapered) with a flat top at r=3.75?
// No, if the profile goes (0, 3.75) -> (10, 4.75) -> (10, 3.75), the top is at r=3.75.
// The side goes from r=3.75 to r=4.75.
// This means the side wall is slanted outwards.
// The top face is at r=3.75.
// This implies there is a vertical wall from z=10 down to z=0?
// No, the profile is the boundary.
// If the boundary is (0, 3.75) -> (10, 4