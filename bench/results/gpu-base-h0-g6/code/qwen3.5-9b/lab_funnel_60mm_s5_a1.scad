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
        // Calculate inner diameters at bottom and top to maintain wall thickness
        inner_bottom_d = bottom_d - 2 * $wall_thickness;
        inner_top_d = top_d - 2 * $wall_thickness;

        // Create the outer profile polygon in the XZ plane
        // Points: Bottom-Left, Top-Left, Top-Right, Bottom-Right
        // We use linear_extrude along Y to create the 3D shape
        difference() {
            // Outer Shell
            linear_extrude(height = height, center = true, convexity = 1) {
                polygon(points = [
                    [-bottom_d/2, 0],
                    [bottom_d/2, 0],
                    [top_d/2, height],
                    [-top_d/2, height]
                ]);
            }
            
            // Inner Hole (Negative space)
            linear_extrude(height = height, center = true, convexity = 1) {
                polygon(points = [
                    [-inner_bottom_d/2, 0],
                    [inner_bottom_d/2, 0],
                    [inner_top_d/2, height],
                    [-inner_top_d/2, height]
                ]);
            }
        }
    }
}

// --- Main Assembly ---

// 1. Build the Spout (Tube)
// Starts at z=0, ends at z=20
hollow_cylinder(
    outer_d = $spout_outer_diameter,
    inner_d = $spout_inner_diameter,
    height = $spout_length,
    pos = [0, 0, 0]
);

// 2. Build the Cone
// Starts at z=20, ends at z=50
hollow_cone(
    bottom_d = $cone_bottom_diameter,
    top_d = $cone_top_diameter,
    height = $cone_height,
    pos = [0, 0, 20]
);