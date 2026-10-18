// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel Body)
$cone_bottom_diameter = 10; // Matches spout outer diameter
$cone_top_diameter = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for smooth curves
$fn = 128;

// --- Helper Functions ---
// Creates a hollow cylinder (tube)
module hollow_cylinder(outer_d, inner_d, height) {
    difference() {
        cylinder(h = height, d = outer_d, $fn = $fn);
        cylinder(h = height, d = inner_d, $fn = $fn);
    }
}

// Creates a hollow cone (funnel shape)
// bottom_d: diameter at the smaller end (z=0 relative to cone)
// top_d: diameter at the larger end (z=height relative to cone)
module hollow_cone(bottom_d, top_d, height) {
    difference() {
        // Outer Cone
        linear_extrude(height = height, center = true) {
            polygon(points = [
                [-bottom_d/2, 0],
                [bottom_d/2, 0],
                [top_d/2, height],
                [-top_d/2, height]
            ]);
        }
        
        // Inner Cone (Bore)
        // Calculate inner diameters at bottom and top
        inner_bottom_d = bottom_d - 2 * $wall_thickness;
        inner_top_d = top_d - 2 * $wall_thickness;
        
        linear_extrude(height = height, center = true) {
            polygon(points = [
                [-inner_bottom_d/2, 0],
                [inner_bottom_d/2, 0],
                [inner_top_d/2, height],
                [-inner_top_d/2, height]
            ]);
        }
    }
}

// --- Main Assembly ---
// The part rests on the XY plane at z = 0.
// The spout runs from z = 0 to z = 20.
// The cone widens from z = 20 to z = 50.

translate([0, 0, 0]) {
    union() {
        // 1. The Spout (Tube)
        // Located from z=0 to z=20
        hollow_cylinder(
            outer_d = $spout_outer_diameter,
            inner_d = $spout_inner_diameter,
            height = $spout_length
        );
        
        // 2. The Cone (Funnel Body)
        // Located from z=20 to z=50
        // Bottom diameter matches spout outer diameter (10mm)
        // Top diameter is 60mm
        hollow_cone(
            bottom_d = $spout_outer_diameter,
            top_d = $cone_top_diameter,
            height = $cone_height
        );
    }
}