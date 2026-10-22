// Magnetic bead rack for 8-tube strip
// Corrected version: Precise tube seat geometry and magnet pocket dimensions.

// --- Dimensions ---
L = 80.0;            // Block length (X)
W = 24.0;            // Block width (Y)
H = 20.0;            // Block height (Z)

num_tubes = 8;       // Number of tubes
tube_spacing = 9.0;  // Center-to-center spacing of tubes
tube_top_d = 6.4;    // Diameter of tube at top
tube_bot_d = 3.0;    // Diameter of tube at bottom
tube_z_top = 20.0;   // Top face Z
tube_z_mid = 12.0;   // Z where diameter changes
tube_z_bot = 2.0;    // Z where cone ends (2mm floor)

mag_l = 60.4;        // Magnet length (X)
mag_w = 3.3;         // Magnet width (Y)
mag_h = 10.2;        // Magnet height (Z)
mag_y_offset = 6.0;  // Y offset for magnet centers

$fn = 64;

// --- Geometry Construction ---

difference() {
    // Main solid block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // 1. Tube Seats
    // Located at Y = 0. 
    // Spacing is 9mm. Total span = (8-1)*9 = 63mm.
    // Centered on X: start at -31.5
    for (i = [0 : num_tubes - 1]) {
        x_pos = (i - (num_tubes - 1) / 2) * tube_spacing;
        
        translate([x_pos, 0, 0]) {
            // Part 1: Cylinder from top (20) down to 12
            // We extend slightly above and below to ensure clean cut
            translate([0, -0.1, tube_z_mid])
                cylinder(h = (tube_z_top - tube_z_mid) + 0.2, d = tube_top_d);
            
            // Part 2: Cone from 12 down to 2
            translate([0, -0.1, tube_z_bot - 0.1])
                cylinder(h = (tube_z_mid - tube_z_bot) + 0.2, d1 = tube_top_d, d2 = tube_bot_d);
        }
    }

    // 2. Magnet Pockets
    // Centered at y = -6 and y = 6.
    // Dimensions: 60.4 (X) x 3.3 (Y) x 10.2 (Z)
    // Open at bottom face (z=0 to 10.2)
    for (sy = [-mag_y_offset, mag_y_offset]) {
        translate([-mag_l/2, sy - mag_w/2, -0.1])
            cube([mag_l, mag_w, mag_h + 0.2]);
    }
}