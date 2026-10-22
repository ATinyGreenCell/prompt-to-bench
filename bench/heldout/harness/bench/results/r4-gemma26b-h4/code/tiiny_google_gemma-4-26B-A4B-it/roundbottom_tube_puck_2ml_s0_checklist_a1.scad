// Round tube holder for 2 mL round-bottom tubes
// Designed for FDM printing, sitting on the XY plane.

// --- Dimensions ---
puck_diameter = 80.0;      // Diameter of the main puck
puck_height   = 26.0;      // Total height of the puck
label_cut_x   = 34.0;     // Everything beyond x = 34 is removed
seat_circle_d  = 50.0;     // Diameter of the circle where tube seats are centered
tube_diameter  = 11.2;     // Diameter of the tube hole
seat_depth     = 20.0;     // Depth from top face to the lowest point of the sphere

$fn = 128;

// --- Calculations ---
puck_radius = puck_diameter / 2;
seat_radius = tube_diameter / 2;
// The lowest point of the sphere is at z = puck_height - seat_depth
// The center of the sphere is at z = (puck_height - seat_depth) + seat_radius
sphere_z_center = (puck_height - seat_depth) + seat_radius;

// The cylinder part of the seat goes from the top face down to the sphere center
// However, to ensure the sphere is the bottom, the cylinder should meet the sphere.
// We'll use a cylinder from the top down to the sphere center.
cylinder_h = puck_height - sphere_z_center;

module tube_seat() {
    // The seat is a combination of a cylinder and a sphere
    // We use a union to create the shape, then subtract it from the puck
    union() {
        // Cylinder part: from top face down to the sphere center
        translate([0, 0, sphere_z_center])
            cylinder(h = puck_height - sphere_z_center, d = tube_diameter);
        
        // Sphere part: centered at sphere_z_center
        translate([0, 0, sphere_z_center])
            sphere(d = tube_diameter);
    }
}

// --- Main Assembly ---
difference() {
    // 1. The main puck body (centered on XY)
    cylinder(h = puck_height, d = puck_diameter);

    // 2. The label cut (removes everything beyond x = 34)
    // We use a large cube to ensure it cuts through the entire puck
    // The cube starts at x = 34 and extends to the edge of the puck
    translate([label_cut_x, -puck_radius - 1, -1])
        cube([puck_radius + 2, puck_radius * 2 + 2, puck_height + 2]);

    // 3. The eight tube seats
    for (i = [0 : 7]) {
        // First seat on +X axis (0 degrees), then every 45 degrees
        angle = i * 45;
        
        // Calculate position on the 50mm diameter circle
        pos_x = (seat_circle_d / 2) * cos(angle);
        pos_y = (seat_circle_d / 2) * sin(angle);
        
        translate([pos_x, pos_y, 0]) {
            // We subtract the seat from the top.
            // The seat is defined such that its top is at puck_height.
            // We translate the seat module so its top is at puck_height.
            // Since the module's cylinder ends at puck_height, we translate it.
            // Wait, the module's cylinder is defined from sphere_z_center to puck_height.
            // Let's adjust the module to be relative to its own bottom (z=0)
            // and then translate it to the correct position.
            
            // Let's redefine the seat locally for the loop to avoid translation confusion
            union() {
                // Cylinder from sphere_z_center to puck_height
                translate([0, 0, sphere_z_center])
                    cylinder(h = puck_height - sphere_z_center, d = tube_diameter);
                // Sphere at sphere_z_center
                translate([0, 0, sphere_z_center])
                    sphere(d = tube_diameter);
            }
        }
    }
}

// Note: The seat logic in the difference() block above is actually 
// adding to the subtraction. I will rewrite the loop to be clean.