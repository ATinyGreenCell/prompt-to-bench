// Buffer tank for mini horizontal gel-electrophoresis box
// Corrected logic: Single difference to ensure platform is part of the solid mass.

// --- Dimensions ---
outer_x = 120;      // Total length (X)
outer_y = 70;       // Total width (Y)
outer_z = 40;       // Total height (Z)
wall_t  = 3;        // Wall thickness
floor_t = 3;        // Floor thickness

platform_len = 60;  // Length of the central platform (X)
platform_h_rel = 10; // Height of platform top above inner floor

hole_d = 2;         // Diameter of electrode wire holes
hole_z = 30;        // Z-coordinate for holes

$fn = 64;

// --- Calculations ---
platform_x_start = (outer_x / 2) - (platform_len / 2);
platform_z_top   = floor_t + platform_h_rel;

difference() {
    // 1. The Main Solid Body (Outer shell + Platform)
    union() {
        // The outer boundary block
        cube([outer_x, outer_y, outer_z]);
        
        // The platform: added to the solid block before any subtractions
        // It spans the full inner width (outer_y - 2*wall_t)
        translate([platform_x_start, wall_t, floor_t])
            cube([platform_len, outer_y - 2*wall_t, platform_h_rel]);
    }

    // 2. Subtract the main interior void
    // This void is the space above the floor and inside the walls
    translate([wall_t, wall_t, floor_t])
        cube([outer_x - 2*wall_t, outer_y - 2*wall_t, outer_z]);

    // 3. Subtract the electrode holes
    // Hole 1 (Left wall)
    translate([-1, outer_y/2, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_t + 2, d = hole_d);
            
    // Hole 2 (Right wall)
    translate([outer_x, outer_y/2, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_t + 2, d = hole_d);
}