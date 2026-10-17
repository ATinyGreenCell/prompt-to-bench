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

// Creates a hollow cone (frustum)
// bottom_d: diameter at the smaller end (attached to spout)
// top_d: diameter at the larger end (rim)
// height: vertical height of the cone
module hollow_cone(bottom_d, top_d, height) {
    difference() {
        // Outer Cone
        rotate_extrude(angle = 360) {
            // Profile in XY plane:
            // X = radius, Y = height (which becomes Z in the extruded object)
            // Start at (radius_bottom, 0), end at (radius_top, height)
            polygon(points = [
                [bottom_d/2, 0],
                [top_d/2, height]
            ]);
        }
        
        // Inner Cone (Hole)
        rotate_extrude(angle = 360) {
            inner_bottom = bottom_d - $wall_thickness * 2;
            inner_top = top_d - $wall_thickness * 2;
            
            polygon(points = [
                [inner_bottom/2, 0],
                [inner_top/2, height]
            ]);
        }
    }
}

// --- Main Assembly ---
// The funnel rests on the XY plane at z=0.
// The spout runs from z=0 to z=20.
// The cone sits on top of the spout, from z=20 to z=50.

translate([0, 0, 0]) {
    // 1. Build the Spout (Tube)
    hollow_cylinder(outer_d = $spout_outer_diameter, 
                    inner_d = $spout_inner_diameter, 
                    height = $spout_length);

    // 2. Build the Cone (Funnel Body)