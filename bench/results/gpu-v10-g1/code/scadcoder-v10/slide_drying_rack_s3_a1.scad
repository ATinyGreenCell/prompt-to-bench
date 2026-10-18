// Microscope slide drying rack
// Print orientation: base on XY plane, slots open upward (+Z)

$fn = 64;

// ---- Block dimensions ----
block_len   = 90;   // X length (mm)
block_wid   = 45;   // Y width (mm)
block_h     = 20;   // Z height (mm)

// ---- Slot dimensions ----
slot_count  = 10;   // number of slide slots
slot_len    = 77;   // slot length along X (mm)
slot_w      = 1.6;  // slot width along Y (mm)
slot_d      = 10;   // slot depth from top face (mm)
slot_pitch  = 3.5;  // centre-to-centre spacing along Y (mm)

// ---- Cutting overlap ----
eps         = 0.5;  // extension past cut faces (mm)

difference() {
    // Base block
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Slot group, centred in X and Y
    for (i = [0 : slot_count - 1]) {
        y = (i - (slot_count - 1)/2) * slot_pitch;
        translate([0, y, block_h - slot_d])
            cube([slot_len, slot_w, slot_d + eps]);
    }
}