// Lab Funnel Design - Corrected
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

$fn = 128; // High resolution for smooth curves

// Dimensions
spout_outer_diameter = 10;
spout_inner_diameter = 6.8; // 10 - 2*1.6
spout_length = 20;
spout_wall_thickness = 1.6;

cone_bottom_outer_diameter = 10;
cone_top_outer_diameter = 60;
cone_height = 30; // From z=20 to z=50
wall_thickness = 1.6;

// Calculate inner diameters for the cone
cone_bottom_inner_diameter = cone_bottom_outer_diameter - 2 * wall_thickness;
cone_top_inner_diameter = cone_top_outer_diameter - 2 * wall_thickness;

// Main Assembly
// The funnel rests on the XY plane at z=0.
// The spout runs from z=0 to z=20.
// The cone runs from z=20 to z=50.

translate([0, 0, 0]) {
    // 1. Spout (Tube)
    // Centered at z = spout_length / 2 to sit on z=0
    difference() {
        cylinder(h = spout_length, d = spout_outer_diameter, $fn = $fn);
        cylinder(h = spout_length, d = spout_inner_diameter, $fn = $fn);
    }

    // 2. Cone
    // Starts at z = spout_length, ends at z = spout_length + cone_height
    translate([0, 0, spout_length]) {
        difference() {
            // Outer Cone
            rotate_extrude(convexity = 3) {
                // Profile: line from (0, 0) to (radius, height)
                // We define the profile relative to the base of the cone (z=0 in local coords)
                // Base radius = cone_bottom_outer_diameter / 2
                // Top radius = cone_top_outer_diameter / 2
                // Since rotate_extrude extrudes along Z, we define the line in XZ plane
                // Point 1: (0, 0) -> Center of base
                // Point 2: (cone_bottom_outer_diameter/2, 0) -> Edge of base
                // Point 3: (cone_top_outer_diameter/2, cone_height) -> Edge of top
                // Point 4: (0, cone_height) -> Center of top
                polygon(points = [
                    [0, 0],
                    [cone_bottom_outer_diameter / 2, 0],
                    [cone_top_outer_diameter / 2, cone_height],
                    [0, cone_height]
                ]);
            }
            
            // Inner Cone (Hole)
            rotate_extrude(convexity = 3) {
                // Inner profile
                inner_base_radius = cone_bottom_inner_diameter / 2;
                inner_top_radius = cone_top_inner_diameter / 2;
                polygon(points = [
                    [0, 0],
                    [inner_base_radius, 0],
                    [inner_top_radius, cone_height],
                    [0, cone_height]
                ]);
            }
        }
    }
}