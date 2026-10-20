$fn = 128; // High resolution for smooth curves

// --- Dimensions (mm) ---
// Spout dimensions
$spout_outer_d = 10;
$spout_inner_d = 6.8; // 10 - 2*1.6
$spout_height = 20;

// Cone dimensions
$cone_bottom_d = 10; // Matches spout outer diameter
$cone_top_d = 60;
$cone_height = 30;   // From z=20 to z=50

// Wall thickness
$wall_thickness = 1.6;

// Derived dimensions
$part_total_height = $spout_height + $cone_height; // 50mm
$part_radius_outer = $spout_outer_d / 2;
$part_radius_inner = $spout_inner_d / 2;

// --- Construction ---

// Module to create a hollow cylinder (spout)
module hollow_cylinder(outer_d, inner_d, h) {
    difference() {
        cylinder(h = h, r = outer_d / 2, center = [0, 0, h/2]);
        cylinder(h = h, r = inner_d / 2, center = [0, 0, h/2]);
    }
}

// Module to create the conical funnel using rotate_extrude
// Profile is defined in X-Z plane: [x, z] points
module hollow_cone(outer_bottom_d, outer_top_d, inner_bottom_d, inner_top_d, h) {
    // Calculate inner top diameter based on wall thickness
    // inner_top_d = outer_top_d - 2*wall_thickness
    // We pass calculated values to ensure precision
    
    difference() {
        // Outer Cone
        // Profile: Bottom at z=0 (radius = outer_bottom_d/2), Top at z=h (radius = outer_top_d/2)
        // We use rotate_extrude around Z axis. The profile is in the X-Z plane.
        // Points: [x, z]
        // Start at bottom center: [0, 0] -> [outer_bottom_d/2, 0] -> [outer_top_d/2, h] -> [0, h] -> close
        rotate_extrude() {
            polygon(points = [
                [0, 0],
                [outer_bottom_d / 2, 0],
                [outer_top_d / 2, h],
                [0, h]
            ], convexity = 3);
        }
        
        // Inner Cone (Hole)
        // Profile: Bottom at z=0 (radius = inner_bottom_d/2), Top at z=h (radius = inner_top_d/2)
        rotate_extrude() {
            polygon(points = [
                [0, 0],
                [inner_bottom_d / 2, 0],
                [inner_top_d / 2, h],
                [0, h]
            ], convexity = 3);
        }
    }
}

// --- Main Assembly ---
// The part is built upright. 
// Spout is from z=0 to z=20.
// Cone is from z=20 to z=50.
// We center the whole assembly on the origin for symmetry.

translate([0, 0, $part_total_height / 2]) {
    union() {
        // 1. Spout (Bottom part)
        hollow_cylinder($spout_outer_d, $spout_inner_d, $spout_height);
        
        // 2. Cone (Top part)
        // Translate up by spout height to connect
        translate([0, 0, $spout_height]) {
            hollow_cone(
                $cone_bottom_d, 
                $cone_top_d, 
                $spout_inner_d, // Inner bottom matches spout inner
                ($cone_top_d - (2 * $wall_thickness)), // Inner top calculated
                $cone_height
            );
        }
    }
}