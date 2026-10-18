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

// Helper to create a hollow cone using rotate_extrude for watertightness
// base_z: z-coordinate of the base (smaller diameter)
// top_z: z-coordinate of the top (larger diameter)
// base_d: diameter at base_z
// top_d: diameter at top_z
module hollow_cone(base_z, top_z, base_d, top_d) {
    // Outer Cone
    outer_cone = rotate_extrude(convexity = 3) {
        // Profile: line from (0, base_z) to