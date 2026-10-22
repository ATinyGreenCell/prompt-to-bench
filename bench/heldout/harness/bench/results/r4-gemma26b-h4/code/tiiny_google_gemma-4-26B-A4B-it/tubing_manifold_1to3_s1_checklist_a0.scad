// Manifold block: Splits one tubing line into three.
// Dimensions: 60mm (X) x 24mm (Y) x 16mm (Z)
// Features: 1 inlet, 3 outlets, 1 main internal channel, 2 screw holes.

// --- Dimensions ---
L = 60.0;            // Length (X)
W = 24.0;            // Width (Y)
H = 16.0;            // Height (Z)

channel_d = 3.0;     // Diameter of internal channels
inlet_d = 4.2;       // Diameter of inlet socket
inlet_depth = 8.0;   // Depth of inlet socket
outlet_d = 4.2;     // Diameter of outlet socket
outlet_depth = 6.0;  // Depth of outlet socket

screw_d = 3.4;       // Diameter of M3 screw holes
screw_x_pos = 25.0;  // X position of screw holes
screw_y_pos = -6.0;  // Y position of screw holes

// --- Constants & Setup ---
$fn = 64;
z_mid = H / 2;       // Mid-plane Z = 8

// --- Geometry Construction ---

module block() {
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);
}

module manifold_channels() {
    // Main channel: runs from -X end to x = 15
    // The block is centered on X, so -X end is at -30.
    // The channel runs from x = -30 to x = 15.
    translate([-L/2 + 0.01, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = 15 + 30, d = channel_d); // +30 to ensure it reaches the end face

    // Outlet 1: at x = -15, runs in +Y
    translate([-15, -W/2 - 0.01, z_mid])
        rotate([0, 90, 0])
            cylinder(h = W/2 + 1, d = channel_d);

    // Outlet 2: at x = 0, runs in +Y
    translate([0, -W/2 - 0.01, z_mid])
        rotate([0, 90, 0])
            cylinder(h = W/2 + 1, d = channel_d);

    // Outlet 3: at x = 15, runs in +Y
    translate([15, -W/2 - 0.01, z_mid])
        rotate([0, 90, 0])
            cylinder(h = W/2 + 1, d = channel_d);
}

module sockets() {
    // Inlet socket at -X end face, y = 0
    // Note: User says "at the -X end face at y = 0". 
    // In a centered block, -X end is x = -30. 
    // If it's at y=0, it's centered on the Y axis.
    translate([-L/2 - 0.01, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = inlet_depth + 0.1, d = inlet_d);

    // Outlet sockets at +Y face
    // Outlet 1 (x=-15), Outlet 2 (x=0), Outlet 3 (x=15)
    for (sx = [-15, 0, 15]) {
        translate([sx, W/2 + 0.01, z_mid])
            rotate([0, 90, 0])
                cylinder(h = outlet_depth + 0.1, d = outlet_d);
    }
}

module screw_holes() {
    // Two 3.4mm vertical through-holes at x = -25 and 25, y = -6
    for (sx = [-screw_x_pos, screw_x_pos]) {
        translate([sx, screw_y_pos, -0.01])
            cylinder(h = H + 0.02, d = screw_d);
    }
}

// --- Final Assembly ---

difference() {
    block();
    manifold_channels();
    sockets();
    screw_holes();
}