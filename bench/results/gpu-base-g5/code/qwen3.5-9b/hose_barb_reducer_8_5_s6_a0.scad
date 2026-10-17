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

// Function to create a stepped tapered cylinder (Sawtooth profile)
// z_min, z_max: Z range of the feature
// od_bottom, od_top: Outer diameters at bottom and top of the taper
// od_step: Outer diameter after the taper (for the "step back")
// height: Height of the tapered section
// count: Number of identical features to stack
// offset_z: Z offset for the stack
// od_bore: Diameter of the central hole
function stepped_barb(z_min, z_max, od_bottom, od_top, od_step, height, count, offset_z, od_bore) =
    union() {
        // Main body: Tapered cylinder + Step cylinder
        // We construct the profile as a polygon rotated around Z
        // However, since the step happens at the top of the taper, we model the taper
        // and then the step as a separate cylinder on top, or one complex shape.
        // To ensure clean printing and correct geometry, we build the taper and the step separately.
        
        // 1. The Tapered Barb
        // Radius at bottom = od_bottom / 2
        // Radius at top = od_top / 2
        // Height = height
        $r_bot = od_bottom / 2;
        $r_top = od_top / 2;
        
        // 2. The Step (the flat part at the top)
        // Radius = od_step / 2
        // Height = 0 (it's just the top surface of the taper? No, the prompt says "steps straight back")
        // Interpretation: The barb tapers up, then there is a flat shoulder at the top OD of the step.
        // Actually, "steps straight back to 7.5 mm" implies the OD reduces from 9.5 to 7.5 at the very top.
        // This creates a flat top surface of diameter 7.5.
        // So the shape is: Taper from 7.5 to 9.5, then immediately a flat top of 7.5.
        // Effectively, the max OD is 9.5, but the top face is 7.5.
        
        // Let's build the profile for rotation.
        // We need to subtract the bore.
        
        // Create the solid barb
        $barb_solid = cylinder(
            h = height,
            r1 = $r_bot,
            r2 = $r_top,
            center = [0, 0, z_min + height/2],
            $fn = 64
        );
        
        // Create the top step (flat surface)
        // This is a cylinder of radius od_step/2 and height 0? No, it's a flat face.
        // In OpenSCAD, a flat face is just the top of the tapered cylinder if we don't add height.
        // But we need to ensure the top face is exactly od_step.
        // The tapered cylinder ends at r_top (9.5). We need to cut it or cap it?
        // "Steps straight back" usually means a vertical wall going down from the top of the taper.
        // So: Taper up to 9.5, then vertical wall down to 7.5.
        // This means the top face is 7.5.
        
        // Let's construct the full profile using a polygon for precision, or union of parts.
        // Union of parts is safer for boolean operations later.
        
        // Part A: The Taper
        $part_taper = cylinder(
            h = height,
            r1 = $r_bot,
            r2 = $r_top,
            center = [0, 0, z_min + height/2],
            $fn = 64
        );
        
        // Part B: The Step (Vertical wall down from top of taper)
        // This is a cylinder of radius od_step/2, height 0? No.
        // It's a cylinder of radius od_step/2, height = 0? No, that's a disk.
        // It's a cylinder of radius od_step/2, height = 0? 
        // Wait, if I have a cylinder of r=9.5 and I want a top face of r=7.5, I need to subtract a cylinder of r=9.5 from z=top to z=top+epsilon? No.
        // I need to add a cylinder of r=7.5 that sits on top of the taper? No, that would make it taller.
        // I need to modify the top of the taper.
        // Correct approach: The shape is a cylinder of r=7.5 (the step) PLUS a frustum on top?
        // No, the prompt says: "OD grows linearly from 7.5 to 9.5, then steps straight back to 7.5".
        // This implies the profile goes: 7.5 (bottom) -> 9.5 (top of taper) -> 7.5 (top face).
        // So the object has a max radius of 9.5, but the top surface is at radius 7.5.
        // This is achieved by taking a cylinder of r=9.5 and cutting the top? No.
        // It is achieved by taking a cylinder of r=7.5 and adding a frustum on top?
        // If I add a frustum on top of a r=7.5 cylinder, the frustum starts at r=7.5 and goes to r=9.5.
        // Then the top of the frustum is r=9.5. That's not "stepping back".
        // "Steps back" means the diameter reduces.
        // So: Base (r=7.5) -> Taper Up (to r=9.5) -> Vertical Wall Down (to r=7.5).
        // This creates a shape where the top face is r=7.5.
        // How to model this?
        // 1. Cylinder r=7.5, height = height.
        // 2. Frustum on top: r1=7.5, r2=9.5, height = height.
        // Union these? No, that makes a mushroom cap (r=9.5 at top).
        // We want the top to be r=7.5.
        // So: Cylinder r=7.5, height = height.
        // PLUS Frustum: r1=7.5, r2=9.5, height = height.
        // This union creates a shape that is r=7.5 at bottom, expands to 9.5 at top.
        // The top face is r=9.5.
        // This contradicts "steps straight back".
        
        // Re-reading: "OD grows linearly from 7.5 ... to 9.5 ... then steps straight back to 7.5".
        // This describes the profile line.
        // Z=0: OD=7.5.
        // Z=10: OD=9.5.
        // Z=10+: OD=7.5.
        // So the shape is:
        // 1. A cylinder of OD=7.5 (radius 3.75) from Z=0 to Z=10.
        // 2. A frustum from Z=0 to Z=10, OD 7.5 to 9.5.
        // 3. A cylinder of OD=7.5 (radius 3.75) from Z=10 to Z=10? No.
        // The "step back" implies a vertical face at the top.
        // So at Z=10, the radius jumps from 9.5 down to 7.5.
        // This means the top surface is at Z=1