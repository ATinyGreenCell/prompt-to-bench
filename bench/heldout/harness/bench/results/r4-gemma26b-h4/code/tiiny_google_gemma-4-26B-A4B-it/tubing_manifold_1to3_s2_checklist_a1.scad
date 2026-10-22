// Manifold block for splitting one tubing line into three.
// Corrected to ensure all channels and sockets are at z = 8.

// --- Dimensions ---
L_block = 60.0;      // Length (X)
W_block = 24.0;      // Width (Y)
H_block = 16.0;      // Height (Z)

d_channel = 3.0;     // Diameter of internal channels
d_socket = 4.2;      // Diameter of tubing sockets
depth_inlet = 8.0;   // Depth of inlet socket
depth_outlet = 6.0;  // Depth of outlet sockets
x_stop = 15.0;       // X-coordinate where main channel stops

x_outlets = [-15, 0, 15]; // X-positions of the three outlet channels
d_screw = 3.4;       // Diameter of M3 screw through-holes
y_screw = -6.0;      // Y-position of screw holes
x_screws = [-25, 25]; // X-positions of screw holes

$fn = 64;

// --- Geometry Construction ---

module block_body() {
    // The main block centered on XY, resting on Z=0
    translate([-L_block/2, -W_block/2, 0])
        cube([L_block, W_block, H_block]);
}

module channels_and_sockets() {
    // 1. Inlet Socket (at -X face, y=0, z=8)
    // The socket is a cylinder centered on the face.
    // Since it's at the -X face (x=-30), we translate to -30 and rotate.
    translate([-L_block/2, 0, H_block/2])
        rotate([0, 90, 0])
        cylinder(h = depth_inlet + 0.1, d = d_socket);

    // 2. Main Channel (along X, from inlet to x = 15)
    // The inlet socket is at x = -30. The channel goes from -30 to 15.
    // Total length = 15 - (-30) = 45.
    translate([-L_block/2 + 0.01, -d_channel/2, H_block/2 - d_channel/2])
        cube([x_stop + 0.01, d_channel, d_channel]); 
    // Note: Using a cube for the main channel to ensure it's a solid volume 
    // that meets the sockets, but the user asked for 3mm diameter channels.
    // Let's use a cylinder for the main channel to be precise.
    // The cylinder starts at the face and goes to x = 15.
    // To avoid gaps, we use a cylinder from -30 to 15.
    // However, the socket is 4.2mm, so we must ensure the 3mm channel 
    // is contained within the socket's volume.
    
    // Re-defining main channel as cylinder:
    // It starts at the face (-30) and ends at x = 15.
    // We use a slightly longer cylinder to ensure it intersects the socket.
    // We use a difference later, so we just need to define the volume.
    // The main channel is a cylinder along X.
    // To make it along X, we translate and rotate.
    // We'll use a cylinder from x = -30 to x = 15.
    // But the cylinder is oriented along Z by default.
    
    // Let's use a more robust way:
    // We will define the channels as cylinders.
    
    // Main channel (X-axis)
    // We'll place it from x = -30 to x = 15.
    // To make it a cylinder along X:
    translate([-L_block/2, -d_channel/2, H_block/2])
        rotate([0, 90, 0])
        cylinder(h = x_stop + L_block/2, d = d_channel);

    // 3. Three outlet channels (Y-axis)
    // They run from the main channel to the +Y face.
    // The main channel is at z=8. The outlet channels are at z=8.
    // They run from the center (y=0) to the +Y face (y=12).
    for (x_pos = x_outlets) {
        translate([x_pos, -0.01, H_block/2])
            rotate([0, 90, 0])
            cylinder(h = W_block + 0.02, d = d_channel);
            
        // 4. Outlet Sockets (at +Y face)
        translate([x_pos, W_block/2 - depth_outlet, H_block/2])
            cylinder(h = depth_outlet + 0.1, d = d_socket);
    }
}

module screw_holes() {
    // Vertical through-holes for M3 screws
    for (x_pos = x_screws) {
        translate([x_pos, y_screw, -0.01])
            cylinder(h = H_block + 0.02, d = d_screw);
    }
}

// --- Final Assembly ---

difference() {
    block_body();
    
    // We use a union for the internal voids to ensure they are one continuous subtraction
    union() {
        // Main channel cylinder
        translate([-L_block/2, -d_channel/2, H_block/2])
            rotate([0, 90, 0])
            cylinder(h = x_stop + L_block/2, d = d_channel);
            
        // Inlet socket
        translate([-L_block/2, -d_socket/2, H_block/2 - d_socket/2])
            cube([depth_inlet + 0.1, d_socket, d_socket]);
        // Wait, the socket is a cylinder. Let's use cylinder.
        // The socket is at the -X face, centered at y=0, z=8.
        // The cylinder should be oriented along X.
        // But the user said "at the -X end face at y=0". 
        // This implies the axis of the socket is the X axis.
        // Let's re-read: "inlet... is a 4.2mm socket 8mm deep... from it the main channel runs along X".
        // This means the socket is a hole drilled into the -X face.
        // So the socket axis is the X axis.
        
        // Let's redefine the inlet socket:
        // It is a cylinder along X, starting at x = -30, ending at x = -30 + 8.
        // But it is centered at y=0, z=8.
        // The cylinder's axis is X.
        // In OpenSCAD, cylinder is along Z. So rotate([0