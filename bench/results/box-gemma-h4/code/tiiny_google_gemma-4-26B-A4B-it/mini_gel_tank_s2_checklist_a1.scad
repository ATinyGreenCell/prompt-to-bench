// Buffer tank for mini horizontal gel-electrophoresis box
// Corrected to ensure the platform is a solid feature within the tank.

// --- Dimensions ---
outer_x = 120;      // Total length (X)
outer_y = 70;       // Total width (Y)
outer_z = 40;       // Total height (Z)
wall_t  = 3;        // Wall thickness
floor_t = 3;        // Floor thickness

platform_len = 60;  // Length of the central platform (X)
platform_h_rel = 10; // Height of platform top above inner floor

hole_d = 2;         // Diameter of electrode wire holes
hole_y_offset = 0;  // Y-coordinate for holes (relative to center)
hole_z = 30;        // Z-coordinate for holes

$fn = 64;

// --- Calculations ---
inner_x_start = wall_t;
inner_x_end   = outer_x - wall_t;
inner_y_start = wall_t;
inner_y_end   = outer_y - wall_t;
inner_z_start = floor_t;

platform_x_start = (outer_x / 2) - (platform_len / 2);
platform_x_end   = (outer_x / 2) + (platform_len / 2);
platform_z_top   = floor_t + platform_h_rel;

module tank_shell() {
    difference() {
        // Main outer block
        cube([outer_x, outer_y, outer_z]);
        
        // Hollow out the interior
        translate([wall_t, wall_t, floor_t])
            cube([outer_x - 2*wall_t, outer_y - 2*wall_t, outer_z]);
    }
}

module platform() {
    // The platform is a solid block placed inside the tank
    translate([platform_x_start, wall_t, floor_t])
        cube([platform_len, outer_y - 2*wall_t, platform_h_rel]);
}

module electrode_holes() {
    // Holes through the X-end walls
    // Center of Y is outer_y / 2
    // Hole 1 (Left wall)
    translate([-1, outer_y/2, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_t + 2, d = hole_d);
            
    // Hole 2 (Right wall)
    translate([outer_x, outer_y/2, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_t + 2, d = hole_d);
}

// --- Final Assembly ---
// We use union to combine the shell and the platform, 
// then subtract the holes from the combined solid.
difference() {
    union() {
        tank_shell();
        platform();
    }
    electrode_holes();
}