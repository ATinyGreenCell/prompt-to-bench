// --- Dimensions ---
puck_diameter = 80;          // Diameter of the main puck
puck_height = 26;            // Total height of the puck
label_cut_x = 34;            // The plane X = 34 is the cutting plane

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
        // Using a large cube to ensure a clean cut through the entire puck
        translate([label_cut_x, -puck_diameter - 1, -1])
            cube([puck_diameter + 2, puck_diameter * 2 + 2, puck_height + 2]);

        // Tube Seats
        // The seats are cut into the top face (Z = puck_height).
        // The lowest point of the sphere is 20mm below the top face.
        // Z_bottom = puck_height - 20.
        // The sphere center is at Z_sphere_center = Z_bottom + tube_radius.
        
        for (i = [0 : num_tubes - 1]) {
            // Calculate angle: first on +X axis (0 degrees)
            angle = i * (360 / num_tubes);
            
            // Position on the 50mm diameter circle
            pos_x = (tube_center_circle_dia / 2) * cos(angle);
            pos_y = (tube_center_circle_dia / 2) * sin(angle);
            
            // The sphere center Z coordinate
            z_sphere_center = (puck_height - tube_depth_to_bottom) + tube_radius;
            
            // We use a union of a cylinder and a sphere to define the cutting shape
            // to ensure the geometry is a single continuous volume for the difference operation.
            translate([pos_x, pos_y, 0]) {
                union() {
                    // 1. The cylindrical part: 
                    // Starts at the sphere center and goes up to the top face.
                    // We extend it slightly above the top face to ensure a clean cut.
                    translate([0, 0, z_sphere_center])
                        cylinder(h = puck_height - z_sphere_center + 1, d = tube_hole_diameter);
                    
                    // 2. The hemispherical bottom:
                    // The sphere is centered such that its bottom is at (puck_height - 20).
                    translate([0, 0, z_sphere_center])
                        sphere(d = tube_hole_diameter);
                }
            }
        }
    }
}

// Render the part
tube_holder();