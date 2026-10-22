// Cable bridge - lets cables cross under a bench mat
// Print orientation: flat on bed, tunnel opening at floor level

$fn = 96;               // resolution for curved surfaces

// --- Block dimensions ---
block_len   = 60;       // length along X (mm)
block_wid   = 50;       // width along Y (mm)
block_h     = 12;       // height along Z (mm)

// --- Tunnel dimensions ---
tunnel_d    = 8;        // tunnel cylinder diameter (mm)
tunnel_x    = 0;        // tunnel axis X position (mm)
tunnel_z    = 0;        // tunnel axis Z position (floor level) (mm)

// --- Cutting clearance ---
eps         = 0.5;      // overshoot past cut faces (mm)

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Semicircular tunnel: cylinder along Y with axis at floor level.
    // The lower half lies below z = 0, leaving a half-round channel.
    translate([tunnel_x, 0, tunnel_z])
        rotate([90, 0, 0])
            cylinder(d = tunnel_d, h = block_wid + 2*eps, center = true);
}
