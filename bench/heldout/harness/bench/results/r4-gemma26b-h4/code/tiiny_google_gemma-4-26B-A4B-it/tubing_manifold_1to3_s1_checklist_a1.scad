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
outlet_d = 4.2;      // Diameter of outlet socket
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
    // Main channel: runs from -X end face to x = 15
    // The -X end face is at x = -30.
    // We use a cylinder oriented along X.
    translate([-L/2 - 0.1, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = 15 - (-L/2) + 0.2, d = channel_d);

    // Outlet 1: at x = -15, runs in +Y
    translate([-15, -W/2 - 0.1, z_mid])
        rotate([0, 90, 0])
            cylinder(h = W + 0.2, d = channel_d);

    // Outlet 2: at x = 0, runs in +Y
    translate([0, -W/2 - 0.1, z_mid])
        rotate([0, 90, 0])
            cylinder(h = W + 0.2, d = channel_d);

    // Outlet 3: at x = 15, runs in +Y
    translate([15, -W/2 - 0.1, z_mid])
        rotate([0, 90, 0])
            cylinder(h = W + 0.2, d = channel_d);
}

module sockets() {
    // Inlet socket at -X end face (x = -30), centered on Y (y = 0)
    translate([-L/2 - 0.1, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = inlet_depth + 0.1, d = inlet_d);

    // Outlet sockets at +Y face (y = 12)
    // Outlet 1 (x=-15), Outlet 2 (x=0), Outlet 3 (x=15)
    for (sx = [-15, 0, 15]) {
        translate([sx, W/2, z_mid])
            rotate([0, 90, 0])
                cylinder(h = outlet_depth + 0.1, d = outlet_d);
    }
}

module screw_holes() {
    // Two 3.4mm vertical through-holes at x = -25 and 25, y = -6
    for (sx = [-screw_x_pos, screw_x_pos]) {
        translate([sx, screw_y_pos, -0.1])
            cylinder(h = H + 0.2, d = screw_d);
    }
}

// --- Final Assembly ---

difference() {
    block();
    manifold_channels();
    sockets();
    screw_holes();
}