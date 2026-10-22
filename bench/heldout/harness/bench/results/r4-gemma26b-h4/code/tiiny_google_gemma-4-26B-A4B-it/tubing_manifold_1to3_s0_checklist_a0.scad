// Manifold block for splitting one tubing line into three.
// Designed for FDM printing, resting on the XY plane.

// --- Dimensions ---
L_block = 60.0;      // Length (X)
W_block = 24.0;      // Width (Y)
H_block = 16.0;      // Height (Z)

chan_d  = 3.0;       // Diameter of internal channels
inlet_d = 4.2;       // Diameter of inlet socket
inlet_h = 8.0;       // Depth of inlet socket
outlet_d = 4.2;      // Diameter of outlet socket
outlet_h = 6.0;      // Depth of outlet socket

screw_d = 3.4;       // Diameter of M3 screw holes
screw_x = 25.0;      // X position of screw holes
screw_y = -6.0;      // Y position of screw holes

$fn = 64;

// --- Calculations ---
z_mid = H_block / 2; // Mid-plane Z = 8

// --- Geometry Construction ---

module block_body() {
    // The main block centered on X and Y, sitting on Z=0
    translate([-L_block/2, -W_block/2, 0])
        cube([L_block, W_block, H_block]);
}

module channels() {
    // 1. Inlet Channel: runs from -X face (y=0) to x = -L/2 + 15
    // Note: User said "from it the main channel runs along X to x = 15, where it stops".
    // Given block is 60mm long (-30 to +30), x=15 is a valid internal point.
    // The inlet is at the -X end face (x = -30).
    
    // Inlet socket (at x = -30, y = 0)
    // Since the block is centered on Y, y=0 is the center line.
    // The user says "at the -X end face at y = 0". This implies the socket is centered on the face.
    translate([-L_block/2, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = inlet_h + 1, d = inlet_d);

    // Main channel (along X)
    // Starts from the end of the inlet socket and goes to x = 15.
    // Inlet socket is at x = -30, depth 8 -> channel starts at x = -22.
    translate([-L_block/2 + inlet_h, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = 15 - (-L_block/2 + inlet_h) + 1, d = chan_d);

    // 2. Outlet Channels (along Y)
    // Branching at x = -15, 0, 15.
    // They run in +Y direction to the +Y face.
    // The +Y face is at y = W_block/2 = 12.
    // The outlet socket is 6mm deep at the face.
    
    outlet_x_coords = [-15, 0, 15];
    for (cx = outlet_x_coords) {
        // The main channel ends at x=15. To ensure connection, we extend the 
        // branch logic to meet the main channel.
        // The main channel is at y=0. The outlet socket is at y=12.
        // The socket depth is 6, so the channel must reach y = 12 - 6 = 6.
        
        // Branch from main channel (y=0) to the start of the socket (y=6)
        translate([cx, 0, z_mid])
            cylinder(h = 6 + 1, d = chan_d);
            
        // Outlet socket at the +Y face (y = 12)
        translate([cx, W_block/2 - outlet_h, z_mid])
            rotate([0, 90, 0])
                cylinder(h = outlet_h + 1, d = outlet_d);
    }
}

module screw_holes() {
    // Two 3.4 mm vertical through-holes at x = -25 and 25, y = -6
    for (sx = [-screw_x, screw_x]) {
        translate([sx, screw_y, -1])
            cylinder(h = H_block + 2, d = screw_d);
    }
}

// --- Final Assembly ---

difference() {
    block_body();
    channels();
    screw_holes();
}