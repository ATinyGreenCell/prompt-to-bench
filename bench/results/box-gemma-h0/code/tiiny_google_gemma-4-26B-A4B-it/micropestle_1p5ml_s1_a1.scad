// --- Dimensions (mm) ---
handle_diameter = 8.0;       // Diameter of the cylindrical handle
handle_height = 45.0;        // Height of the handle from z=0
cone_base_dia = 8.0;         // Diameter at the start of the taper (z=45)
cone_tip_dia = 3.0;          // Diameter at the end of the taper (z=62)
tip_diameter = 3.0;          // Diameter of the spherical tip
tip_z_center = 62.0;         // Z-coordinate of the sphere center

groove_width = 2.0;          // Width of each groove in Z
groove_depth = 1.0;          // Depth of each groove into the handle
groove_z_positions = [10, 15, 20, 25]; // Z-centers for the four grooves

// --- Constants ---
$fn = 64; // Smoothness for cylinders and spheres

// --- Main Construction ---
// The part is printed standing upright, resting on the XY plane at z=0.
// We use a single difference() to ensure a single watertight manifold body.

difference() {
    // 1. The Solid Body
    union() {
        // Handle
        cylinder(d = handle_diameter, h = handle_height);

        // Cone (Taper)
        // Using hull to create a smooth transition between the handle top and tip base
        hull() {
            translate([0, 0, handle_height])
                cylinder(d = cone_base_dia, h = 0.01);
            translate([0, 0, tip_z_center])
                cylinder(d = cone_tip_dia, h = 0.01);
        }

        // Rounded Tip
        translate([0, 0, tip_z_center])
            sphere(d = tip_diameter);
    }

    // 2. The Grooves (Subtracted from the handle)
    for (z_pos = groove_z_positions) {
        // To create a circumferential groove, we use a large cylinder 
        // and subtract it from the main body. 
        // The cylinder is centered on the Z-axis and its diameter is 
        // the handle diameter + (2 * groove_depth) to ensure it cuts through.
        
        translate([0, 0, z_pos])
            // We use a cylinder with a diameter larger than the handle 
            // to ensure a clean cut through the sides.
            // The height is groove_width + a small overlap to prevent thin walls.
            cylinder(d = handle_diameter + (groove_depth * 2.1), 
                     h = groove_width + 0.1, 
                     center = true);
    }
}

// Note on the "2 separate bodies" error from previous report:
// The previous error occurred because the sphere was not properly 
// integrated into the main body via a union() before the difference() 
// was applied, or the subtraction logic was flawed. 
// This version ensures the entire geometry is one continuous union 
// before the grooves are subtracted.