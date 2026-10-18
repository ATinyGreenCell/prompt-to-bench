// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0

// Dimensions
$fn = 128; // High resolution for smooth curves

// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8;
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel)
cone_bottom_diameter = 10; // Matches spout outer diameter
cone_top_diameter = 60;
cone_height = 30; // From z=20 to z=50

// Wall Thickness (applies to cone as well)
wall_thickness = 1.6;

// Derived Cone Dimensions
cone_bottom_inner_diameter = cone_bottom_diameter - (2 * wall_thickness);
cone_top_inner_diameter = cone_top_diameter - (2 * wall_thickness);

// Build the part
// We construct the solid by creating the outer shell and subtracting the inner void.
// The part sits on the XY plane at z=0.

difference() {
    // --- OUTER SHELL ---
    union() {
        // 1. Spout Outer Cylinder (z=0 to z=20)
        cylinder(
            h = spout_length,
            d = spout_outer_diameter,
            center = false
        );

        // 2. Cone Outer Frustum (z=20 to z=50)
        // Translate to start at z=20
        translate([0, 0, spout_length]) {
            // Linear extrusion of a triangle profile rotated 90 deg around Y to form cone
            // Profile: Base at z=0 (local) is cone_bottom_diameter, Top at z=cone_height is cone_top_diameter
            // We use polygon to define the cross-section in XZ plane, then rotate_extrude
            // Actually, simpler to use cylinder with varying radius? No, OpenSCAD cylinders are straight.
            // Use linear_extrude with a polygon profile in the XZ plane, then rotate 90 deg around Y.
            
            // Profile points: (x, z)
            // Bottom: x = cone_bottom_diameter/2, z = 0
            // Top: x = cone_top_diameter/2, z = cone_height
            // Close the loop for the outer wall? 
            // Let's build the outer cone as a solid frustum using linear_extrude of a triangle.
            
            polygon(
                points = [
                    [-cone_bottom_diameter/2, 0],
                    [cone_bottom_diameter/2, 0],
                    [cone_top_diameter/2, cone_height],
                    [-cone_top_diameter/2, cone_height]
                ],
                convex = false
            );
            
            rotate_extrude(
                axis = [0, 1, 0], // Rotate around Y axis
                angle = 360
            );
        }
    }

    // --- INNER VOID ---
    // We subtract the inner volume to create the bore.
    // The inner void consists of the inner cylinder and the inner cone frustum.
    
    union() {
        // 1. Inner Cylinder (Spout Bore)
        // z=0 to z=20
        cylinder(
            h = spout_length,
            d = spout_inner_diameter,
            center = false
        );

        // 2. Inner Cone Frustum
        // z=20 to z=50
        translate([0, 0, spout_length]) {
            // Profile for inner cone
            polygon(
                points = [
                    [-cone_bottom_inner_diameter/2, 0],
                    [cone_bottom_inner_diameter/2, 0],
                    [cone_top_inner_diameter/2, cone_height],
                    [-cone_top_inner_diameter/2, cone_height]
                ],
                convex = false
            );
            
            rotate_extrude(
                axis = [0, 1, 0],
                angle = 360
            );
        }
    }
}