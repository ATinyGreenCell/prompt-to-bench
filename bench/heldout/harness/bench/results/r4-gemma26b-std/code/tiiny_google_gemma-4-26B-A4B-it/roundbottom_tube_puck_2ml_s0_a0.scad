// --- Parameters ---
puck_diameter = 80;          // Diameter of the main puck
puck_height = 26;            // Total height of the puck
label_cut_x = 34;            // The X coordinate where the side is cut flat

tube_hole_diameter = 11.2;   // Diameter of the tube hole
tube_seat_radius = tube_hole_diameter / 2;
tube_depth_total = 20;       // Depth from top face to the bottom of the hemisphere
tube_center_circle_dia = 50; // Diameter of the circle where tubes are placed
num_tubes = 8;               // Number of tube seats

// --- Constants ---
$fn = 64;

// --- Calculations ---
puck_radius = puck_diameter / 2;
tube_center_radius = tube_center_circle_dia / 2;
// The bottom of the hemisphere is at z = 6. 
// Since puck height is 26, the depth from top is 20.
// A hemisphere with diameter 11.2 has a radius of 5.6.
// If the lowest point is 20mm below the top, the cylinder part depth is 20 - 5.6 = 14.4.

// --- Main Model ---
difference() {
    // The main puck body
    cylinder(h = puck_height, d = puck_diameter, center = false);

    // The label cut (removes everything beyond x = 34)
    // We extend the cube in X, Y, and Z to ensure a clean cut
    translate([label_cut_x, -puck_radius - 1, -1])
        cube([puck_radius + 2, puck_radius * 2 + 2, puck_height + 2]);

    // The eight tube seats
    for (i = [0 : num_tubes - 1]) {
        // Calculate angle: first tube on +X axis (0 degrees)
        angle = i * (360 / num_tubes);
        
        // Position of the tube center
        tx = tube_center_radius * cos(angle);
        ty = tube_center_radius * sin(angle);
        
        // We place the seat at the top face. 
        // The top face is at z = 26.
        // The cylinder part starts at z = 26 - 14.4 = 11.6
        // The hemisphere part is centered at z = 11.6 (bottom is at 11.6 - 5.6 = 6)
        
        translate([tx, ty, 26]) {
            // 1. The cylindrical hole
            // We extend it slightly above the top face to ensure a clean cut
            cylinder(h = 15, d = tube_hole_diameter);
            
            // 2. The hemispherical bottom
            // A sphere centered at z = -5.6 (relative to top face) 
            // will have its bottom at -11.2 relative to top face.
            // Wait, user says: "lowest point is 20mm below the top face, at z=6".
            // Top is 26. 26 - 20 = 6. Correct.
            // Hemisphere radius is 11.2/2 = 5.6.
            // If bottom is at 6, center of sphere is at 6 + 5.6 = 11.6.
            // Relative to top face (z=26), center is at 11.6 - 26 = -14.4.
            
            translate([0, 0, -14.4])
                sphere(d = tube_hole_diameter);
        }
    }
}