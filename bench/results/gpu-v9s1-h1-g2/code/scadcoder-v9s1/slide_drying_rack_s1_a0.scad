// Microscope slide drying rack
// Print orientation: base on XY plane, slots open upward (+Z)

// ---------- Block ----------
block_l = 90;      // block length along X (mm)
block_w = 45;      // block width along Y (mm)
block_h = 20;      // block height along Z (mm)

// ---------- Slots ----------
slot_n     = 10;   // number of slide slots
slot_len   = 77;   // slot length along X (mm)
slot_w     = 1.6;  // slot width along Y (mm)
slot_d     = 10;   // slot depth from top face (mm)
slot_pitch = 3.5;  // centre-to-centre spacing along Y (mm)

// ---------- Misc ----------
eps = 0.5;         // overcut past faces to avoid coplanar surfaces
$fn = 64;

// Derived
slot_x0 = -(slot_len - block_l) / 2;              // first slot start X
slot_y0 = -(slot_n - 1) * slot_pitch / 2;         // first slot centre Y

difference() {
    // Base block
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Parallel slots, open at the top
    for (i = [0 : slot_n - 1]) {
        translate([slot_x0, slot_y0 + i * slot_pitch, block_h - slot_d])
            cube([slot_len, slot_w, slot_d + eps]);
    }
}