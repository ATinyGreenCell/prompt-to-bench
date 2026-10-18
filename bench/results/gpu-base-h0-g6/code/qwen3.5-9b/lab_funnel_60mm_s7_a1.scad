// Lab Funnel Design - Corrected
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0

$fn = 128; // High resolution for smooth curves

// --- Dimensions ---
// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8; // 10 - 2*1.6
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel)
cone_bottom_outer_diameter = 10; // Matches spout outer
cone_top_outer_diameter = 60;
cone_bottom_z = 20; // Start of cone
cone_top_z = 50;    // End of cone
cone_wall_thickness = 1.6;

// --- Derived Calculations ---
// Cone Geometry
cone_height = cone_top_z - cone_bottom_z;
cone_bottom_outer_radius = cone_bottom_outer_diameter / 2;
cone_top_outer_radius = cone_top_outer_diameter / 2;

// Inner Cone Geometry
// At z=20, inner diameter matches spout inner (6.8)
// At z=50, inner diameter = 60 - 2*1.6 = 56.8
cone_bottom_inner_radius = spout_inner_diameter / 2;
cone_top_inner_radius = (cone_top_outer_diameter / 2) - cone_wall_thickness;

// --- Main Construction ---
// We build the Outer Shell and Inner Void separately to ensure a clean boolean difference.
// This prevents the "separate bodies" error and ensures correct wall thickness.

difference() {
    // 1. Outer Shell
    union() {
        // Spout Outer Cylinder
        translate([0, 0, 0])
            cylinder(
                h = spout_length,
                d = spout_outer_diameter,
                center = false
            );
        
        // Cone Outer Frustum
        // Defined by points: Bottom(-r, 0), Bottom(r, 0), Top(r, h), Top(-r, h)
        translate([0, 0, cone_bottom_z])
            linear_extrude(height = cone_height, center = false)
                polygon(
                    points = [
                        [-cone_bottom_outer_radius, 0],
                        [cone_bottom_outer_radius, 0],
                        [cone_top_outer_radius, cone_height],
                        [-cone_top_outer_radius, cone_height]
                    ]
                );
    }
    
    // 2. Inner Void (The hole for liquid)
    union() {
        // Spout Inner Cylinder
        translate([0, 0, 0])
            cylinder(
                h = spout_length,
                d = spout_inner_diameter,
                center = false
            );
        
        // Cone Inner Frustum
        // Defined by points: Bottom(-r, 0), Bottom(r, 0), Top(r, h), Top(-r, h)
        translate([0, 0, cone_bottom_z])
            linear_extrude(height = cone_height, center = false)
                polygon(
                    points = [
                        [-cone_bottom_inner_radius, 0],
                        [cone_bottom_inner_radius, 0],
                        [cone_top_inner_radius, cone_height],
                        [-cone_top_inner_radius, cone_height]
                    ]
                );
    }
}