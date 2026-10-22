// Tube holder for 2 mL round-bottom tubes
// Designed for FDM printing, resting on the XY plane.

// --- Dimensions ---
puck_diameter = 80.0;      // Diameter of the main puck
puck_height   = 26.0;      // Total height of the puck
flat_cut_x    = 34.0;      // The plane x = 34 is the boundary; everything > 34 is removed
seat_circle_d  = 50.0;     // Diameter of the circle where tube seats are centered
seat_hole_d    = 11.2;     // Diameter of the tube hole
seat_depth_z   = 20.0;     // Depth from top face to the lowest point of the sphere
num_seats      = 8;        // Number of tubes to hold

$fn = 128;

// --- Calculations ---
puck_radius = puck_diameter / 2;
seat_radius = seat_circle_d / 2;
sphere_r    = seat_hole_d / 2;
// The lowest point is at Z = puck_height - seat_depth_z
// The sphere center must be at Z = (puck_height - seat_depth_z) + sphere_r
// The cylinder height must reach from the top face down to the sphere center.
cylinder_h = seat_depth_z - sphere_r;

// --- Geometry ---

module hole_shape() {
    // The hole is a cylinder with a hemisphere at the bottom.
    // We define it such that it is easy to subtract.
    union() {
        // The cylindrical part
        cylinder(h = cylinder_h, d = seat_hole_d);
        // The hemispherical bottom
        // We translate it so the bottom of the sphere is at the bottom of the cylinder
        translate([0, 0, cylinder_h])
        sphere(d = seat_hole_d);
    }
}

// --- Final Assembly ---

difference() {
    // 1. The main puck
    cylinder(h = puck_height, d = puck_diameter);

    // 2. The flat cut for the label (everything beyond x = 34 is removed)
    // We use a large cube to ensure it cuts through the whole puck
    translate([flat_cut_x, -puck_diameter, -1])
    cube([puck_diameter, puck_diameter * 2, puck_height + 2]);

    // 3. The eight tube seats
    for (i = [0 : num_seats - 1]) {
        // Calculate angle: first on +X axis (0 degrees)
        angle = i * (360 / num_seats);
        
        // Position on the circle
        x_pos = seat_radius * cos(angle);
        y_pos = seat_radius * sin(angle);
        
        // The hole is cut from the top face (Z = puck_height) downwards.
        // We translate the hole shape so its top is at Z = puck_height.
        // The hole_shape starts at Z=0, so we translate it to Z = puck_height - seat_depth_z.
        translate([x_pos, y_pos, puck_height - seat_depth_z])
        hole_shape();
    }
}