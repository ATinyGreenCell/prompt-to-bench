// Stiffened cover panel
// Print orientation: plate flat on bed, ribs pointing up (+Z)

// ---------------- Parameters ----------------
plate_len   = 100;  // plate length along X (mm)
plate_wid   = 50;   // plate width along Y (mm)
plate_thk   = 3;    // plate thickness, z = 0..3 (mm)

rib_count   = 4;    // number of ribs
rib_thk     = 2;    // rib thickness along X (mm)
rib_h       = 6;    // rib height above plate, z = 3..9 (mm)
rib_pitch   = plate_len / (rib_count + 1); // 20 mm centre spacing
rib_overlap = 0.01; // small overlap into plate for a clean union (mm)

// ---------------- Model ----------------
union() {
    // Base plate
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_thk]);

    // Ribs: centres at x = -30, -10, 10, 30
    for (i = [0 : rib_count - 1]) {
        x_c = -plate_len/2 + rib_pitch * (i + 1);
        translate([x_c - rib_thk/2, -plate_wid/2, plate_thk - rib_overlap])
            cube([rib_thk, plate_wid, rib_h + rib_overlap]);
    }
}
