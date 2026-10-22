// Round tube holder for 2 mL round-bottom tubes
// Designed for FDM printing, resting on the XY plane.

// --- Dimensions ---
puck_diameter = 80.0;    // Diameter of the main puck
puck_height   = 26.0;    // Total height of the puck
flat_cut_x    = 34.0;    // The plane x = 34 is the boundary; everything > 34 is removed

tube_diameter  = 11.2;   // Diameter of the tube hole
tube_radius    = tube_diameter / 2;
seat_depth_z   = 20.0;   // Depth from the top face to the bottom of the hemispherical seat

seat_circle_d  = 50.0;   // Diameter of the circle on which tube seats are centered
num_seats      = 8;      // Number of tubes to hold

$fn = 128;               // High resolution for smooth curves

// --- Calculations ---
puck_radius = puck_diameter / 2;
seat_circle_r = seat_circle_d / 2;
// The bottom of the hemispherical part is at z = puck_height - seat_depth_z
// The center of the sphere that forms the bottom must be at z = (puck_height - seat_depth_z) + tube_radius
sphere_center_z = (puck_height - seat_depth_z) + tube_radius;

// --- Geometry Construction ---

module tube_seat() {
    // The seat consists of a cylinder (the hole) and a sphere (the bottom)
    // We use a union to create the shape, then subtract it from the puck.
    // However, to make the math easier for the subtraction, we define the "negative" shape.
    union() {
        // The cylindrical part of the hole
        // It starts from the top face and goes down to the sphere center
        translate([0, 0, puck_height - seat_depth_z + tube_radius - 0.01])
            cylinder(h = seat_depth_z - tube_radius + 0.01, d = tube_diameter);
        
        // The hemispherical bottom
        // We place the sphere so its bottom is at the correct Z
        translate([0, 0, sphere_center_z - tube_radius])
            sphere(d = tube_diameter);
    }
}

// Main Assembly
difference() {
    // 1. The Base Puck
    // We use a cylinder and then cut it with a cube to create the flat label side.
    difference() {
        cylinder(h = puck_height, d = puck_diameter);
        
        // Cut off everything beyond x = 34
        // We translate the cube so its face is at x = 34
        translate([flat_cut_x, -puck_diameter/2, -1])
            cube([puck_diameter, puck_diameter, puck_height + 2]);
    }

    // 2. The Tube Seats
    // We place 8 seats on a circle of diameter 50mm, starting at +X axis (0 degrees)
    for (i = [0 : num_seats - 1]) {
        angle = i * (360 / num_seats);
        
        // Calculate position on the circle
        // Using polar to cartesian: x = r*cos(a), y = r*sin(a)
        pos_x = seat_circle_r * cos(angle);
        pos_y = seat_circle_r * sin(angle);
        
        translate([pos_x, pos_y, 0])
            tube_seat();
    }
}