// Lab Funnel Design - Corrected
// Units: millimetres
// Orientation: Upright, wide opening at top, resting on XY plane at z=0.

// Dimensions
$fn = 128; // High resolution for smooth curves

// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8; // 10 - 2*1.6
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel Body)
cone_bottom_diameter = 10; // Matches spout outer diameter
cone_top_diameter = 60;
cone_total_height = 50;     // Total height from z=0 to z=50
cone_wall_thickness = 1.6;

// Helper function to create a hollow cylinder (spout)
module hollow_cylinder(outer_d, inner_d, height) {
    difference() {
        cylinder(h = height, d = outer_d, $fn = $fn);
        cylinder(h = height, d = inner_d, $fn = $fn);
    }
}

// Helper function to create a hollow cone using linear_extrude and polygon
// bottom_d: diameter at the bottom of the cone section
// top_d: diameter at the top of the cone section
// height: height of the cone section
module hollow_cone(bottom_d, top_d, height) {
    difference() {
        // Outer Cone
        // Profile is a triangle defined by points: 
        // (-bottom_d/2, 0), (0, height), (bottom_d/2, 0)
        // We extrude this profile along Z.
        linear_extrude(height = height, center = true) {
            polygon(points = [
                [-bottom_d/2, 0],
                [0, height],
                [bottom_d/2, 0]
            ]);
        }
        
        // Inner Cone (Cutout)
        inner_bottom_d = bottom_d - 2 * cone_wall_thickness;
        inner_top_d = top_d - 2 * cone_wall_thickness;
        
        linear_extrude(height = height, center = true) {
            polygon(points = [
                [-inner_bottom_d/2, 0],
                [0, height],
                [inner_bottom_d/2, 0]
            ]);
        }
    }
}

// Main Assembly
module lab_funnel() {
    union() {
        // 1. The Spout (Tube)
        // Positioned at z=0 to z=20
        translate([0, 0, 0]) {
            hollow_cylinder(
                outer_d = spout_outer_diameter,
                inner_d = spout_inner_diameter,
                height = spout_length
            );
        }
        
        // 2. The Cone
        // Positioned at z=20 to z=50
        // Height of the cone section is 30mm (50 - 20)
        translate([0, 0, 20]) {
            hollow_cone(
                bottom_d = cone_bottom_diameter,
                top_d = cone_top_diameter,
                height = cone_total_height - spout_length
            );
        }
    }
}

// Render the part
lab_funnel();