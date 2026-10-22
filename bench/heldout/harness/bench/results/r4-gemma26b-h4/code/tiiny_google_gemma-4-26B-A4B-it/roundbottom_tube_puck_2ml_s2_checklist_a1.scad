// Corrected Round tube holder for 2 mL round-bottom tubes
// Designed for FDM printing, resting on the XY plane.

// --- Dimensions ---
puck_diameter = 80.0;    // Diameter of the main puck
puck_height   = 26.0;    // Total height of the puck
flat_cut_x    = 34.0;    // The plane x = 34 is the boundary; everything > 34 is removed

tube_diameter  = 11.2;   // Diameter of the tube hole
tube_radius    = tube_diameter / 2;
seat_bottom_z  = 6.0;    // The lowest point of the seat (hemisphere) must be at z = 6

seat_circle_d  = 50.0;   // Diameter of the circle on which tube seats are centered
num_seats      = 8;      // Number of tubes to hold

$fn = 128;               // High resolution for smooth curves

// --- Calculations ---
seat_circle_r = seat_circle_d / 2;
// The sphere's lowest point is at seat_bottom_z. 
// Therefore, the center of the sphere is at seat_bottom_z + tube_radius.
sphere_center_z = seat_bottom_z + tube_radius;

// --- Geometry Construction ---

module tube_seat_subtraction() {
    // This module defines the volume to be REMOVED from the puck.
    union() {
        // 1. The cylindrical hole. 
        // It goes from the top face (puck_height) down to the sphere center.
        // We extend it slightly below the sphere center to ensure a clean cut.
        translate([0, 0, sphere_center_z - 0.1])
            cylinder(h = puck_height - sphere_center_z + 0.1, d = tube_diameter);
        
        // 2. The hemispherical bottom.
        // The sphere is centered such that its bottom is at seat_bottom_z.
        translate([0, 0, sphere_center_z])
            sphere(d = tube_diameter);
    }
}

// Main Assembly
difference() {
    // 1. The Base Puck
    difference() {
        cylinder(h = puck_height, d = puck_diameter);
        
        // Cut off everything beyond x = 34
        // We use a large cube to ensure the cut is clean.
        translate([flat_cut_x, -puck_diameter/2 - 1, -1])
            cube([puck_diameter, puck_diameter + 2, puck_height + 2]);
    }

    // 2. The Tube Seats
    // We place 8 seats on a circle of diameter 50mm, starting at +X axis (0 degrees).
    for (i = [0 : num_seats - 1]) {
        angle = i * (360 / num_seats);
        
        // Calculate position on the circle
        pos_x = seat_circle_r * cos(angle);
        pos_y = seat_circle_r * sin(angle);
        
        translate([pos_x, pos_y, 0])
            tube_seat_subtraction();
    }
}