// Cable bridge - lets cables cross under a bench mat
// Print orientation: flat on bed, tunnels open at floor level

// ---------- Parameters ----------
block_len   = 80;   // block length along X (mm)
block_wid   = 30;   // block width along Y (mm)
block_ht    = 15;   // block height along Z (mm)

tunnel_d    = 12;   // tunnel cylinder diameter (mm)
tunnel_n    = 2;    // number of tunnels
tunnel_pitch = 16;  // centre-to-centre spacing of tunnel axes along X (mm)

eps         = 0.5;  // cutter overshoot past faces (mm)
$fn         = 96;   // facet count for round features

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Semicircular tunnels: cylinders with axis along Y at z = 0.
    // The lower half lies below the bed, leaving a half-round channel.
    for (i = [0 : tunnel_n - 1]) {
        x = (i - (tunnel_n - 1) / 2) * tunnel_pitch;
        translate([x, 0, 0])
            rotate([90, 0, 0])
                cylinder(d = tunnel_d, h = block_wid + 2*eps, center = true);
    }
}
