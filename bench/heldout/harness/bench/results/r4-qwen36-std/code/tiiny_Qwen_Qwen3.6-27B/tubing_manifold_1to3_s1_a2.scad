// Manifold Block: 1-inlet to 3-outlets
// Dimensions measured in mm

// Block dimensions
block_len = 60;
block_wid = 24;
block_hgt = 16;

// Channel geometry
chan_dia = 3;
chan_r = chan_dia / 2;
chan_z = block_hgt / 2; // mid-plane z = 8

// Inlet socket
inlet_dia = 4.2;
inlet_r = inlet_dia / 2;
inlet_depth = 8;
inlet_y = 0;

// Outlet sockets
outlet_dia = 4.2;
outlet_r = outlet_dia / 2;
outlet_depth = 6;

// Branch positions (x-coordinates where outlets branch off main channel)
branch_x = [-15, 0, 15];

// Main channel end position
main_end_x = 15;

// Mounting holes
mount_dia = 3.4;
mount_r = mount_dia / 2;
mount_x = [-25, 25];
mount_y = -6;

// Rendering quality
$fn = 64;

// Build the solid block
difference() {
    // Main block
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_hgt]);

    // --- Channels ---
    
    // Main channel: runs from inlet at x=-block_len/2 to x=main_end_x along X-axis at y=inlet_y, z=chan_z
    // Inlet is at -X face, so main channel starts at x = -block_len/2 and goes to x = main_end_x
    translate([-block_len/2, inlet_y, chan_z])
        rotate([0, 90, 0])
        cylinder(h = main_end_x - (-block_len/2), r = chan_r, center = false);

    // Three outlet channels: branch off main channel at each branch_x, run in +Y direction to +Y face
    for (bx = branch_x) {
        // Channel from branch point to +Y face
        // Branch point is at (bx, inlet_y, chan_z)
        // +Y face is at y = block_wid/2
        // Channel runs from y = inlet_y to y = block_wid/2
        translate([bx, inlet_y, chan_z])
            rotate([90, 0, 0])
            cylinder(h = block_wid/2 - inlet_y, r = chan_r, center = false);
    }

    // --- Sockets ---
    
    // Inlet socket: on -X end face at y=inlet_y, depth=inlet_depth
    // Socket is a cylinder extending into the block from the -X face
    translate([-block_len/2, inlet_y, chan_z])
        rotate([0, 90, 0])
        cylinder(h = inlet_depth + 0.5, r = inlet_r, center = false);

    // Outlet sockets: on +Y face at each branch_x, depth=outlet_depth
    for (bx = branch_x) {
        translate([bx, block_wid/2, chan_z])
            rotate([90, 0, 0])
            cylinder(h = outlet_depth + 0.5, r = outlet_r, center = false);
    }

    // --- Mounting holes ---
    
    // Two M3 through-holes at specified positions
    for (mx = mount_x) {
        translate([mx, mount_y, 0])
            cylinder(h = block_hgt + 1, r = mount_r, center = true);
    }
}