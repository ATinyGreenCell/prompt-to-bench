// Stiffened cover panel
// Flat plate with 4 transverse ribs dividing the length into 5 equal bays

// ---- Plate ----
plate_len   = 120;   // plate length along X (mm)
plate_wid   = 50;    // plate width along Y (mm)
plate_t     = 2;     // plate thickness (mm), z = 0 to 2

// ---- Ribs ----
rib_count   = 4;     // number of ribs
rib_t       = 3;     // rib thickness along X (mm)
rib_h       = 5;     // rib height above plate (mm), z = 2 to 7
rib_pitch   = plate_len / (rib_count + 1);  // centre spacing = 24 mm
overlap     = 0.01;  // small overlap into plate so the union fuses cleanly

$fn = 64;

union() {
    // Base plate, centred in X and Y, resting on z = 0
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_t]);

    // Ribs: centres at -36, -12, 12, 36 mm (24 mm from each end, 24 mm apart)
    for (i = [1 : rib_count]) {
        x_c = -plate_len/2 + i * rib_pitch;
        translate([x_c - rib_t/2, -plate_wid/2, plate_t - overlap])
            cube([rib_t, plate_wid, rib_h + overlap]);
    }
}
