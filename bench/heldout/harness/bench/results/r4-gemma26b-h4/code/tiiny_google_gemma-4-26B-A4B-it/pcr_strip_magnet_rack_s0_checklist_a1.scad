// Magnetic bead rack for 8-tube strip
// Corrected version: Fixed tube seat geometry and magnet pocket dimensions

// --- Dimensions ---
L = 80.0;            // Total length (X)
W = 24.0;            // Total width (Y)
H = 20.0;            // Total height (Z)

tube_count = 8;      // Number of tubes
tube_spacing = 9.0;  // Center-to-center spacing of tubes
tube_top_d = 6.4;    // Diameter of tube at top
tube_bot_d = 3.0;    // Diameter of tube at bottom
tube_z_top = 20.0;   // Top face of block
tube_z_mid = 12.0;   // Height where cone starts
tube_z_bot = 2.0;    // Height where cone ends

mag_len = 60.0;      // Length of pocket (X)
mag_wid = 10.0;      // Width of pocket (Y)
mag_h   = 3.0;       // Height of pocket (Z)
mag_y_offset = 6.0;  // Y offset for magnet centers

$fn = 64;

// --- Geometry Construction ---

// The tube seat (conical hole)
// Cylinder from top (20) to mid (12), then cone from mid (12) to bot (2)
module tube_seat_shape() {
    union() {
        // Cylinder part: from Z=12 to Z=20
        cylinder(h = tube_z_top - tube_z_mid, d = tube_top_d);
        // Cone part: from Z=2 to Z=12
        translate([0, 0, tube_z_bot])
            cylinder(h = tube_z_mid - tube_z_bot, d1 = tube_bot_d, d2 = tube_top_d);
    }
}

// The magnet pocket shape
module magnet_pocket_shape() {
    cube([mag_len, mag_wid, mag_h], center = true);
}

// --- Final Assembly ---

difference() {
    // Base block: sits on Z=0, centered on XY
    translate([0, 0, H/2]) 
        cube([L, W, H], center = true);

    // 1. Subtract Tube Seats
    // Spacing logic: (i - (n-1)/2) * spacing
    for (i = [0 : tube_count - 1]) {
        x_pos = (i - (tube_count - 1) / 2) * tube_spacing;
        // Position the seat so it starts at the top face (Z=20)
        // We translate the shape so its bottom is at tube_z_bot
        translate([x_pos, 0, tube_z_bot]) 
            tube_seat_shape();
    }

    // 2. Subtract Magnet Pockets
    // Pockets are 60x10x3, open at bottom (Z=0).
    // They are centered at y = 6 and y = -6.
    // To make them open at Z=0, we translate them so the bottom of the pocket is at Z=0.
    for (sy = [-mag_y_offset, mag_y_offset]) {
        translate([0, sy, mag_h/2]) 
            magnet_pocket_shape();
    }
}