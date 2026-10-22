// Stiffened cover panel
// Units: mm. Print orientation: plate flat on the bed, ribs pointing up (+Z).

// ---- Plate ----
plate_len   = 120;   // plate length along X
plate_wid   = 50;    // plate width along Y
plate_thk   = 3;     // plate thickness (z = 0 to 3)

// ---- Ribs ----
rib_count   = 4;     // number of ribs
rib_thk     = 2;     // rib thickness along X
rib_h       = 5;     // rib height above plate (z = 3 to 8)
rib_pitch   = plate_len / (rib_count + 1);  // 24 mm centre-to-centre spacing
rib_overlap = 0.01;  // small overlap into plate for a clean union

// ---- Model ----
union() {
    // Base plate, centred in X and Y
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_thk]);

    // Ribs: centres at -36, -12, 12, 36 (24 mm from plate ends)
    for (i = [1 : rib_count]) {
        x_c = -plate_len/2 + i * rib_pitch;
        translate([x_c - rib_thk/2, -plate_wid/2, plate_thk - rib_overlap])
            cube([rib_thk, plate_wid, rib_h + rib_overlap]);
    }
}
