// --- Dimensions (mm) ---

// Block dimensions
block_length = 60;   // X dimension
block_width = 24;    // Y dimension
block_height = 16;   // Z dimension

// Tubing/Channel dimensions
tube_diameter = 3.0;  // Diameter of internal channels
inlet_socket_dia = 4.2; // Inlet socket diameter
outlet_socket_dia = 4.2; // Outlet socket diameter
inlet_depth = 8.0;    // Depth of inlet socket
outlet_depth = 6.0;   // Depth of outlet sockets

// Screw hole dimensions
screw_hole_diameter = 3.4; // Diameter for M3 screws
screw_hole_offset_x1 = -25; // X position of first screw hole (relative to center)
screw_hole_offset_x2 = 25;  // X position of second screw hole (relative to center)
screw_hole_y_pos = -6.0;    // Y position of both screw holes

// Channel positions and lengths
main_channel_stop_x = 15; // Where the main channel stops internally
outlet_branch_x1 = -15;  // X position for first outlet branch
outlet_branch_x2 = 0;    // X position for second outlet branch
outlet_branch_x3 = 15;   // X position for third outlet branch

// --- Constants ---
$fn = 64; // High resolution for curves

// --- Base Block ---
module block() {
    cube([block_length, block_width, block_height], center = true);
}

// --- Features ---

// 1. Inlet Socket (on -X face, y=0)
module inlet_socket() {
    translate([-block_length/2 + (inlet_socket_dia / 2), 0, 0]) {
        cylinder(h = inlet_depth, r = inlet_socket_dia / 2, center = true);
    }
}

// 2. Outlet Sockets (on +Y face)
module outlet_socket() {
    // Socket centered at the branch X position, on the Y face (+block_width/2)
    translate([0, block_width/2 - (outlet_socket_dia / 2), 0]) {
        cylinder(h = outlet_depth, r = outlet_socket_dia / 2, center = true);
    }
}

// 3. Internal Channels (Hollowed out)
module internal_channels() {
    difference() {
        // Start with the solid block shape for subtraction reference
        block();

        // A. Main Channel (Runs from inlet area towards X=15, closed inside)
        // The main channel starts near the inlet and runs along X until x = 15.
        // We model this as a cylinder centered on Y=0, Z=8.
        translate([-(block_length/2 - (inlet_socket_dia / 2)), 0, block_height/2]) {
            cylinder(h = main_channel_stop_x + (block_length/2 - (inlet_socket_dia / 2)) , r = tube_diameter / 2);
        }

        // B. Outlet Channels (Branching from X=-15, 0, 15 towards +Y face)
        // These channels run along Y direction until they exit the block boundary at Y=block_width/2.
        for (i = [outlet_branch_x1, outlet_branch_x2, outlet_branch_x3]) {
            translate([i, 0, block_height/2]) {
                // Length needed: from center line (Y=0) to exit face (Y=block_width/2)
                cylinder(h = block_width / 2 + tube_diameter/2 , r = tube_diameter / 2);
            }
        }

        // C. Closing the Main Channel at X=15 (to ensure it's closed inside)
        // This cuts a cap at x = main_channel_stop_x, centered on Y=0, Z=8.
        translate([main_channel_stop_x + block_length/2, 0, block_height/2]) {
            cylinder(h = tube_diameter * 2, r = tube_diameter / 2);
        }

        // D. Inlet Connection Cutout (To allow tubing entry)
        // This removes material where the inlet socket is located, ensuring the main channel starts correctly.
        translate([-block_length/2 + (inlet_socket_dia / 2), 0, block_height/2]) {
            cylinder(h = block_height * 2, r = inlet_socket_dia / 2);
        }

    }
}


// 4. Screw Holes (Vertical through-holes)
module screw_holes() {
    for (i = [screw_hole_offset_x1, screw_hole_offset_x2]) {
        translate([i, screw_hole_y_pos, -block_height/2 - 0.01]) { // Extend slightly past bottom face
            cylinder(h = block_height + 0.02, r = screw_hole_diameter / 2);
        }
    }
}


// --- Final Assembly ---

difference() {
    // Start with the solid block
    block();

    // Subtract all features (channels and holes)
    union() {
        internal_channels();
        screw_holes();
    }

    // Add sockets back in, as they are external fittings that need to be cut into the surface
    // We use a union of the block and the sockets, then subtract the internal channels from this combined shape.
    // However, since we modeled the main body first, we just add the sockets on top of the subtraction result.

    // Re-unioning the base block with the external fittings (sockets) to ensure they are solid features
    union() {
        block();
        inlet_socket();
        // Outlet sockets need to be placed correctly relative to the center origin for the final union
        translate([0, 0, 0]) {
            for (i = [outlet_branch_x1, outlet_branch_x2, outlet_branch_x3]) {
                translate([i, block_width/2 - (outlet_socket_dia / 2), 0]) {
                    cylinder(h = outlet_depth, r = outlet_socket_dia / 2);
                }
            }
        }
    }
}

// Note on the final structure: The difference operation above is complex because sockets are additions to the surface.
// A simpler approach for FDM printing is usually: Solid Block - Internal Cuts + External Features (if they protrude).
// Since the sockets are cut *into* the faces, we must ensure the subtraction process correctly leaves them as holes/sockets.

/*
Revised Final Structure Logic:
1. Start with the solid block.
2. Subtract all internal channels and screw holes from this block.
3. Add the external socket volumes back onto the resulting shape (Union). This ensures the sockets are present on the surface while maintaining the internal cuts.
*/

difference() {
    // 1. Base Block
    block();

    // 2. Subtract Internal Features (Channels and Screw Holes)
    union() {
        internal_channels();
        screw_holes();
    }
}
union() {
    // 3. Add External Sockets back onto the resulting shape
    inlet_socket();

    // Outlet sockets
    for (i = [outlet_branch_x1, outlet_branch_x2, outlet_branch_x3]) {
        translate([i, block_width/2 - (outlet_socket_dia / 2), 0]) {
            cylinder(h = outlet_depth, r = outlet_socket_dia / 2);
        }
    }
}