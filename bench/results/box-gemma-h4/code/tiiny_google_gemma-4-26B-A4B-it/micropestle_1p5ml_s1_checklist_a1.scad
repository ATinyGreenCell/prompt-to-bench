// Pestle for 1.5 mL microcentrifuge tube
// Designed to be printed standing upright (Z-axis)

// --- Dimensions ---
handle_d      = 8.0;    // Diameter of the cylindrical handle
handle_h      = 45.0;   // Height of the handle (from z=0)
cone_top_d    = 3.0;    // Diameter at the top of the cone
cone_bottom_d = 8.0;    // Diameter at the base of the cone
cone_h        = 62.0 - 45.0; // Height of the cone section
sphere_d      = 3.0;    // Diameter of the rounded tip
sphere_z      = 62.0;   // Z-coordinate of the center of the sphere

// Grip settings
groove_w      = 2.0;    // Width (height in Z) of each groove
groove_d      = 1.0;    // Depth of each groove
groove_z_pos  = [10, 15, 20, 25]; // Z-centers for the four grooves

$fn = 64;

// --- Geometry Construction ---

module pestle_main_body() {
    // We union everything first to ensure it is one single solid body
    union() {
        // 1. Cylindrical Handle
        cylinder(h = handle_h, d = handle_d);
        
        // 2. Tapered Cone
        // Starts at z=45, ends at z=62
        cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
        
        // 3. Rounded Tip
        // Sphere centered at z=62. 
        // Since the cone ends at z=62, the sphere will overlap the cone tip.
        translate([0, 0, sphere_z]) sphere(d = sphere_d);
    }
}

module grip_grooves() {
    // This module defines the shapes to be subtracted
    for (z_pos = groove_z_pos) {
        translate([0, 0, z_pos])
        rotate_extrude()
        translate([(handle_d / 2) - groove_d, -groove_w / 2])
        square([groove_d + 0.1, groove_w + 0.1]); 
    }
}

// Final Assembly
// Subtract the grooves from the unified main body
difference() {
    pestle_main_body();
    grip_grooves();
}