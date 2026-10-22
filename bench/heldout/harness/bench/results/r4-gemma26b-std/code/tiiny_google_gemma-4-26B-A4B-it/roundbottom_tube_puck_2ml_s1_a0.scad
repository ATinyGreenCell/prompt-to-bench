// --- Dimensions ---
puck_diameter = 80;          // Diameter of the main puck
puck_height = 26;            // Total height of the puck
label_cut_x = 34;            // The plane X = 34 is the cutting plane (removes everything > 34)

tube_hole_diameter = 11.2;   // Diameter of the tube hole
tube_radius = tube_hole_diameter / 2;
tube_depth_to_bottom = 20;   // Depth from top face to the lowest point of the sphere
tube_center_circle_dia = 50; // Diameter of the circle where tubes are placed
num_tubes = 8;               // Number of tube seats

// --- Constants ---
$fn = 64;

// --- Implementation ---

// The part is built in the print orientation: rests on XY plane at Z=0
module tube_holder() {
    difference() {
        // Main Body: The Puck
        cylinder(h = puck_height, d = puck_diameter, center = false);

        // Label Cut: Removes everything beyond X = 34
        // We use a large cube to ensure a clean cut
        translate([label_cut_x, -puck_diameter, -1])
            cube([puck_diameter, puck_diameter * 2, puck_height + 2]);

        // Tube Seats
        // The seats are cut into the top face.
        // The top face is at Z = puck_height.
        // The lowest point is 20mm below the top face, so Z_bottom = puck_height - 20.
        // The hole is a cylinder + a half-sphere at the bottom.
        
        for (i = [0 : num_tubes - 1]) {
            // Calculate angle: first on +X axis (0 degrees), then evenly spaced
            angle = i * (360 / num_tubes);
            
            // Position on the 50mm diameter circle
            pos_x = (tube_center_circle_dia / 2) * cos(angle);
            pos_y = (tube_center_circle_dia / 2) * sin(angle);
            
            // The seat geometry:
            // A cylinder for the main hole
            // A sphere at the bottom to create the rounded seat
            translate([pos_x, pos_y, puck_height - tube_depth_to_bottom]) {
                union() {
                    // The cylindrical part of the hole
                    // We extend it slightly above the top face to ensure a clean cut
                    translate([0, 0, -tube_depth_to_bottom + tube_radius])
                        cylinder(h = tube_depth_to_bottom, d = tube_hole_diameter);
                    
                    // The hemispherical bottom
                    // The sphere center is at the bottom of the cylinder
                    // To make it a half-sphere at the bottom, we place the sphere center 
                    // at the bottom-most point of the cylinder.
                    translate([0, 0, -tube_radius])
                        sphere(d = tube_hole_diameter);
                }
            }
        }
    }
}

// Render the part
tube_holder();