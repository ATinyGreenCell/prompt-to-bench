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

// Function to create a hollow cone
// Arguments: bottom_d, top_d, height, position (x,y,z)
// bottom_d is at z=pos[2], top_d is at z=pos[2]+height
module hollow_cone(bottom_d, top_d, height, pos = [0,0,0]) {
    translate(pos) {
        difference() {
            // Outer Cone
            // Using linear_extrude with a triangle profile for the outer shell
            // The profile is drawn in the XZ plane, extruded along Y
            // To make it hollow, we extrude the outer profile and subtract the inner profile
            // However, a simpler way in OpenSCAD for a hollow cone is to use two cones and subtract.
            
            // Outer Cone
            cone(h = height, d1 = bottom_d, d2 = top_d, $fn = $fn);
            
            // Inner Cone (Hole)
            // The inner diameter at the bottom matches the spout inner diameter
            // The inner diameter at the top is (top_d - 2*wall_thickness)
            inner_bottom_d = bottom_d - 2 * $wall_thickness;
            inner_top_d = top_d - 2 * $wall_thickness;
            
            cone(h = height, d1 = inner_bottom_d, d2 = inner_top_d, $fn = $fn);
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