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

module pestle_body() {
    union() {
        // 1. Cylindrical Handle
        cylinder(h = handle_h, d = handle_d);
        
        // 2. Tapered Cone
        // We use a cylinder with d1 and d2 to create the taper
        cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
        
        // 3. Rounded Tip
        // Sphere centered at z = 62. Since cylinder ends at 62, 
        // we place the sphere center at 62.
        translate([0, 0, sphere_z]) sphere(d = sphere_d);
    }
}

module grip_grooves() {
    // We use a subtraction approach in the main difference block
    // To create circumferential grooves, we use a torus-like shape
    // created by rotating a circle.
    for (z_pos = groove_z_pos) {
        translate([0, 0, z_pos])
        rotate_extrude()
        translate([(handle_d / 2) - groove_d + 0.01, 0]) // Offset to cut into the side
        circle(d = groove_w); // This is a simplified approach; 
        // Actually, a better way for "circumferential grooves" is to use a 
        // thin cylinder or a torus. Let's use a torus-like shape.
    }
}

// Corrected Groove Logic: 
// A circumferential groove is a ring. We can model it by rotating a 
// rectangle (the cross-section of the groove) around the Z axis.

difference() {
    pestle_body();
    
    // Subtracting the grooves
    for (z_pos = groove_z_pos) {
        translate([0, 0, z_pos])
        rotate_extrude()
        translate([(handle_d / 2) - groove_d, -groove_w / 2])
        square([groove_d + 0.1, groove_w]); 
        // Note: square is 2D, rotate_extrude makes it a ring.
        // We use a slightly larger width to ensure a clean cut.
    }
}

// Refined Groove implementation for OpenSCAD logic:
// The above 'square' approach is cleaner for a "cut".
// Let's rewrite the final assembly to ensure it renders perfectly.

module final_pestle() {
    difference() {
        // Main Body
        union() {
            cylinder(h = handle_h, d = handle_d);
            cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
            translate([0, 0, sphere_z]) sphere(d = sphere_d);
        }
        
        // Grooves
        for (z_pos = groove_z_pos) {
            translate([0, 0, z_pos])
            rotate_extrude()
            translate([(handle_d / 2) - groove_d, -groove_w / 2])
            square([groove_d + 0.5, groove_w + 0.5]);
        }
    }
}

// Clear the previous logic and use the clean module
// (In a real file, you'd only have one definition)
// Final Render:
final_pestle();