// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0

// Dimensions
$fn = 128; // High resolution for smooth curves and accurate hole sizes

// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8; // 10 - 2*1.6
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel)
cone_bottom_diameter = 10; // Matches spout outer diameter
cone_top_diameter = 60;
cone_bottom_z = 20; // Start of cone
cone_top_z = 50;    // End of cone (rim)
cone_wall_thickness = 1.6;

// Derived Cone Dimensions
cone_bottom_radius = cone_bottom_diameter / 2;
cone_top_radius = cone_top_diameter / 2;
cone_height = cone_top_z - cone_bottom_z;

// Main Body Construction
// We build the solid from the bottom up.
// 1. The Spout: A hollow cylinder from z=0 to z=20.
// 2. The Cone: A hollow frustum from z=20 to z=50.
// We use a single difference operation to cut the inner bore through both sections.

difference() {
    union() {
        // --- Outer Shell ---
        
        // 1. Spout Outer Cylinder
        translate([0, 0, 0])
            cylinder(
                h = spout_length,
                d = spout_outer_diameter,
                center = false
            );
        
        // 2. Cone Outer Frustum
        // The cone starts at z=20. We translate it so its bottom is at z=20.
        translate([0, 0, cone_bottom_z])
            linear_extrude(height = cone_height, center = false)
                polygon(
                    points = [
                        [-cone_bottom_radius, 0],
                        [cone_bottom_radius, 0],
                        [cone_top_radius, cone_height],
                        [-cone_top_radius, cone_height]
                    ]
                );
    }
    
    // --- Inner Bore (Cutout) ---
    // We cut a single continuous path for the liquid to flow through.
    // The path consists of the spout bore (cylinder) and the cone bore (frustum).
    
    union() {
        // 1. Spout Inner Cylinder
        translate([0, 0, 0])
            cylinder(
                h = spout_length,
                d = spout_inner_diameter,
                center = false
            );
        
        // 2. Cone Inner Frustum
        // The inner cone starts at z=20.
        // Inner bottom radius = (spout_inner_diameter / 2)
        // Inner top radius = (cone_top_diameter / 2) - cone_wall_thickness
        // Note: The user specified the wall is 1.6mm everywhere.
        // So at the top rim (z=50), the inner diameter is 60 - 2*1.6 = 56.8mm.
        // At the bottom of the cone (z=20), the inner diameter matches the spout inner diameter (6.8mm).
        
        inner_cone_bottom_radius = spout_inner_diameter / 2;
        inner_cone_top_radius = (cone_top_diameter / 2) - cone_wall_thickness;
        
        translate([0, 0, cone_bottom_z])
            linear_extrude(height = cone_height, center = false)
                polygon(
                    points = [
                        [-inner_cone_bottom_radius, 0],
                        [inner_cone_bottom_radius, 0],
                        [inner_cone_top_radius, cone_height],
                        [-inner_cone_top_radius, cone_height]
                    ]
                );
    }
}