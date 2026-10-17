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

// Function to create a hollow cone using linear_extrude
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
        
        // Define the outer profile points (X, Z)
        // Start at bottom center (0,0), go to bottom edge, up to top edge, back to top center
        // We extrude along Y.
        // Points: [x, z]
        outer_profile = [
            [0, 0],
            [r_bottom, 0],
            [r_top, height],
            [0, height]
        ];
        
        // Define the inner profile points
        inner_profile = [
            [0, 0],
            [r_inner_bottom, 0],
            [r_inner_top, height],
            [0, height]
        ];
        
        difference() {
            // Extrude outer profile
            linear_extrude(height = height, center = true, twist = 0, convexity = 3) {
                polygon(points = outer_profile);
            }
            
            // Extrude inner profile (the hole)
            linear_extrude(height = height, center = true, twist = 0, convexity = 3) {
                polygon(points = inner_profile);
            }
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