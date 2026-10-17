// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel)
$cone_bottom_diameter = 10; // Matches spout outer diameter
$cone_top_diameter = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for curved surfaces
$fn = 64;

// --- Helper Functions ---

// Function to create a hollow cylinder (tube)
// Arguments: outer_d, inner_d, height, position (x,y,z)
module hollow_cylinder(outer_d, inner_d, height, pos = [0,0,0]) {
    translate(pos) {
        difference() {
            cylinder(h = height, d = outer_d, $fn = $fn);
            cylinder(h = height, d = inner_d, $fn = $fn);
        }
    }
}

// Function to create a hollow cone using rotate_extrude
// Arguments: bottom_d, top_d, height, position (x,y,z)
// bottom_d is at z=pos[2], top_d is at z=pos[2]+height
module hollow_cone(bottom_d, top_d, height, pos = [0,0,0]) {
    translate(pos) {
        // Calculate radii for the profile
        r_bottom = bottom_d / 2;
        r_top = top_d / 2;
        
        // Calculate inner radii for the hole
        r_inner_bottom = bottom_d / 2 - $wall_thickness;
        r_inner_top = top_d / 2 - $wall_thickness;
        
        // We will extrude a profile in the XZ plane (rotated 90 deg around Y)
        // The profile consists of two lines:
        // 1. Outer wall: from (r_bottom, 0) to (r_top, height)
        // 2. Inner wall: from (r_inner_bottom, 0) to (r_inner_top, height)
        // We use a polygon to define the area between these lines.
        
        // Points for the profile polygon [x, z]
        // Start at bottom outer edge, go to top outer edge, then back to top inner edge, then bottom inner edge.
        // Note: rotate_extrude rotates around the Y axis (0,0,0) by default, but we are defining a profile in XZ.
        // Actually, rotate_extrude rotates around the Y axis. If we define points in XZ, we need to be careful.
        // Standard rotate_extrude takes a 2D profile in the XZ plane (if we consider Y as the axis of rotation? No).
        // rotate_extrude rotates around the Y axis. The profile must be in the XZ plane? 
        // No, rotate_extrude rotates the 2D profile around the Y axis. The profile is defined in the XZ plane? 
        // Wait, rotate_extrude rotates around the Y axis. The profile is usually defined in the XZ plane? 
        // Let's re-verify: rotate_extrude rotates around the Y axis. The profile is in the XZ plane? 
        // Actually, the profile is in the XZ plane relative to the rotation axis Y. 
        // So points are [x, z].
        
        // Let's construct the profile polygon for the wall thickness.
        // We need to close the loop.
        // Path: Bottom Outer -> Top Outer -> Top Inner -> Bottom Inner -> Bottom Outer
        
        profile_points = [
            [r_bottom, 0],           // Bottom Outer Edge
            [r_top, height],         // Top Outer Edge
            [r_inner_top, height],   // Top Inner Edge
            [r_inner_bottom, 0]      // Bottom Inner Edge
        ];
        
        // Add the closing segment from Bottom Inner to Bottom Outer to close the polygon
        // The list above is not closed. We need to explicitly close it or rely on the last point connecting to the first.
        // OpenSCAD polygon requires a closed loop.
        profile_points = [
            [r_bottom, 0],
            [r_top, height],
            [r_inner_top, height],
            [r_inner_bottom, 0],
            [r_bottom, 0] // Close the loop
        ];
        
        rotate_extrude(angle = 360, $fn = $fn) {
            polygon(points = profile_points);
        }
    }
}

// --- Main Assembly ---

// 1. Build the Spout (Tube)
// Position: z=0 to z=20
hollow_cylinder(
    outer_d = $spout_outer_diameter,
    inner_d = $spout_inner_diameter,
    height = $spout_length,
    pos = [0, 0, 0]
);

// 2. Build the Cone (Funnel)
// Position: z=20 to z=50
hollow_cone(
    bottom_d = $cone_bottom_diameter,
    top_d = $cone_top_diameter,
    height = $cone_height,
    pos = [0, 0, 20]
);