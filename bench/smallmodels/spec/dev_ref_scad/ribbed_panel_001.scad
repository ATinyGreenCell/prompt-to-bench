// Stiffened cover panel
plate_len   = 100;  // plate length (X)
plate_wid   = 50;   // plate width (Y)
plate_thk   = 2;    // plate thickness (Z)

rib_count   = 3;    // number of ribs
rib_thk     = 3;    // rib thickness (X)
rib_h       = 6;    // rib height above plate (Z)
rib_pitch   = 25;   // centre-to-centre rib spacing (X)
overlap     = 0.01; // small overlap so ribs fuse with plate

union() {
    // Base plate
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_thk]);

    // Ribs
    for (i = [0 : rib_count - 1]) {
        x_c = (i - (rib_count - 1)/2) * rib_pitch;
        translate([x_c - rib_thk/2, -plate_wid/2, plate_thk - overlap])
            cube([rib_thk, plate_wid, rib_h + overlap]);
    }
}
