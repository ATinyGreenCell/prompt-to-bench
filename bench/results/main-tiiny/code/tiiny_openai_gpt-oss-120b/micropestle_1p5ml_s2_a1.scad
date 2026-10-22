// Parameters (all in mm)
handle_diameter = 8;               // Diameter of cylindrical handle
handle_radius   = handle_diameter/2;
handle_height  = 45;                // Height of cylindrical handle (z = 0 → 45)

cone_start_z   = handle_height;    // z at start of cone
cone_height    = 62 - cone_start_z; // Height of cone (45 → 62)
cone_top_radius = 1.5;              // Radius at tip of cone (z = 62)

sphere_center_z = 62;               // Center of tip sphere
sphere_radius   = 1.5;               // Radius of tip sphere

groove_z_centers = [10, 15, 20, 25]; // Z‑positions of circumferential grooves
groove_width = 2;                    // Groove width in Z (mm)
groove_depth = 1;                    // Groove depth radially (mm)

// $fn for smooth circles and spheres
$fn = 64;

// Main solid (handle + cone + tip)
module pestle_body() {
    // cylindrical handle
    cylinder(r = handle_radius, h = handle_height, center = false);
    
    // tapered cone
    translate([0, 0, cone_start_z])
        cylinder(r1 = handle_radius, r2 = cone_top_radius,
                h = cone_height, center = false);
    
    // rounded tip sphere
    translate([0, 0, sphere_center_z])
        sphere(r = sphere_radius);
}

// Groove cut (a cylindrical ring)
module groove(z_center) {
    // Height extended 0.01 mm beyond each face
    groove_h = groove_width + 0.02;
    // Bottom position of the groove cut
    bottom_z = z_center - groove_width/2 - 0.01;
    
    translate([0, 0, bottom_z])
        difference() {
            // Outer cylinder (full radius)
            cylinder(r = handle_radius, h = groove_h, center = false);
            // Inner cylinder (radius reduced by groove depth)
            cylinder(r = handle_radius - groove_depth,
                     h = groove_h, center = false);
        }
}

// Final part: body minus all grooves
difference() {
    pestle_body();
    // subtract each groove
    for (z = groove_z_centers)
        groove(z);
}