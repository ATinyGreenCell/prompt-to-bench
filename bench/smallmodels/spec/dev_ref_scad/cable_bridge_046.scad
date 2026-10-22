// Cable bridge - lets cables cross under a bench mat
// Print orientation: flat on bed, tunnel opening at floor level

block_len    = 60;    // block length along X (mm)
block_wid    = 30;    // block width along Y (mm)
block_h      = 15;    // block height along Z (mm)
tunnel_d     = 10;    // tunnel cylinder diameter (mm)
tunnel_x     = 0;     // tunnel axis X position (mm)
tunnel_z     = 0;     // tunnel axis Z position (floor level) (mm)
cut_extra    = 1;     // overshoot of cutting shapes past faces (mm)

$fn = 96;

difference() {
    // Main block, centred in X and Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Semicircular tunnel: full cylinder along Y with axis at z = 0;
    // the lower half falls below the bed, leaving a half-round channel
    translate([tunnel_x, 0, tunnel_z])
        rotate([90, 0, 0])
            cylinder(d = tunnel_d, h = block_wid + 2*cut_extra, center = true);
}
