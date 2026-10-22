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
        // Centered on X and Y as per instructions
        cylinder(h = puck_height, d = puck_diameter, center = false);

        // Label Cut: Removes everything beyond X = 34
        // We use a large cube to ensure a clean cut. 
        // To avoid coplanar face issues, we extend the cube slightly.
        translate([label_cut_x, -puck_diameter - 1, -1])
            cube([puck_diameter + 1, puck_diameter * 2 + 2, puck_height + 2]);

        // Tube Seats
        // The seats are cut into the top face (Z = puck_height).
        // The lowest point of the sphere is 20mm below the top face.
        // Therefore, the sphere center is at Z = (puck_height - 20) + tube_radius.
        // The cylinder part must reach the top face.
        
        for (i = [0 : num_tubes - 1]) {
            // Calculate angle: first on +X axis (0 degrees)
            angle = i * (360 / num_tubes);
            
            // Position on the 50mm diameter circle
            pos_x = (tube_center_circle_dia / 2) * cos(angle);
            pos_y = (tube_center_circle_dia / 2) * sin(angle);
            
            // Geometry logic:
            // 1. The sphere center is at Z_sphere_center.
            // 2. The bottom of the sphere is at Z_sphere_center - tube_radius.
            // 3. We want Z_sphere_center - tube_radius = puck_height - 20.
            // 4. So, Z_sphere_center = puck_height - 20 + tube_radius.
            
            translate([pos_x, pos_y, 0]) {
                // The sphere part
                // We translate it so its bottom is at the correct Z
                translate([0, 0, puck_height - tube_depth_to_bottom])
                    sphere(d = tube_hole_diameter);
                
                // The cylindrical part
                // It must connect the sphere to the top face.
                // The sphere's top is at (puck_height - 20 + tube_radius) + tube_radius
                // which is puck_height - 20 + 2*tube_radius.
                // To be safe and ensure a clean cut through the top, 
                // we start the cylinder at the sphere center and go to the top.
                translate([0, 0, puck_height - tube_depth_to_bottom + tube_radius])
                    cylinder(h = tube_depth_to_bottom - tube_radius + 1, d = tube_hole_diameter);
            }
        }
    }
}

// Render the part
tube_holder();