// Cable bridge for routing cables under a bench mat
// Print orientation: flat on bed, tunnels open at floor level

// ---- Block dimensions ----
block_length = 60;   // X length (mm)
block_width  = 30;   // Y width (mm)
block_height = 12;   // Z height (mm)

// ---- Tunnel dimensions ----
tunnel_count   = 3;   // number of semicircular tunnels
tunnel_dia     = 8;   // tunnel cylinder diameter (mm)
tunnel_pitch   = 16;  // centre-to-centre spacing along X (mm)
cut_extra      = 1;   // overshoot of cutters past faces (mm)

$fn = 96;

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-block_length/2, -block_width/2, 0])
        cube([block_length, block_width, block_height]);

    // Semicircular tunnels: full cylinders with axis at z = 0 along Y;
    // the lower half lies below the bed, leaving a half-round channel.
    for (i = [0 : tunnel_count - 1]) {
        x = (i - (tunnel_count - 1) / 2) * tunnel_pitch;
        translate([x, 0, 0])
            rotate([90, 0, 0])
                cylinder(d = tunnel_dia,
                         h = block_width + 2*cut_extra,
                         center = true);
    }
}
