// Magnetic bead rack for 8-tube strip
// Designed for 0.2 mL PCR tubes with magnet pockets

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

mag_len = 60.4;      // Length of magnet (X)
mag_wid = 3.3;       // Width of magnet (Y)
mag_h   = 10.2;      // Height of magnet (Z)
mag_y_offset = 6.0;  // Y offset for magnet centers

$fn = 64;

// --- Geometry Construction ---

// The main block
module block() {
    cube([L, W, H], center = true);
}

// The tube seat (conical hole)
module tube_seat() {
    // We use a difference approach to cut the hole out of the block
    // The hole is a cylinder from top to mid, and a cone from mid to bottom
    union() {
        // Cylinder part
        cylinder(h = tube_z_top - tube_z_mid, d = tube_top_d);
        // Cone part
        cylinder(h = tube_z_mid - tube_z_bot, d1 = tube_top_d, d2 = tube_bot_d);
    }
}

// The magnet pocket
module magnet_pocket() {
    cube([mag_len, mag_wid, mag_h], center = true);
}

// --- Final Assembly ---

difference() {
    // Base block
    // Translate to sit on Z=0 and centered on XY
    translate([0, 0, H/2]) cube([L, W, H], center = true);

    // 1. Subtract Tube Seats
    // Spacing logic: (i - (n-1)/2) * spacing
    for (i = [0 : tube_count - 1]) {
        x_pos = (i - (tube_count - 1) / 2) * tube_spacing;
        // The tube seat is defined relative to the top face (Z=20)
        // We translate it so the top of the cylinder is at Z=20
        translate([x_pos, 0, tube_z_bot]) 
            tube_seat();
    }

    // 2. Subtract Magnet Pockets
    // Pockets are open at the bottom (z=0). 
    // They are centered at y = 6 and y = -6.
    // They are 10.2mm tall, so they go from z=0 to z=10.2.
    // In the difference, we place them so they intersect the bottom face.
    for (sy = [-mag_y_offset, mag_y_offset]) {
        translate([0, sy, mag_h/2]) 
            magnet_pocket();
    }
}

// Note on orientation: 
// The block is centered on X and Y. 
// The block sits on the XY plane (Z=0 to Z=20).
// The tube seats are along Y=0.
// The magnet pockets are at Y=6 and Y=-6.