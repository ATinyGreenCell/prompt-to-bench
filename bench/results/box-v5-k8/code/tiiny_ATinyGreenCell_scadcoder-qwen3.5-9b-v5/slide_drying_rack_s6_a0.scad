// Slide drying rack
// Units: mm. Print orientation: base on XY plane, slots open upward (+Z).

// ---- Block ----
block_len   = 90;    // block length along X
block_wid   = 45;    // block width along Y
block_ht    = 20;    // block height along Z

// ---- Slots ----
slot_count  = 10;    // number of slide slots
slot_len    = 77;    // slot length along X
slot_wid    = 1.6;   // slot width along Y
slot_depth  = 10;    // slot depth into block (from top face)
slot_pitch  = 3.5;   // centre-to-centre spacing in Y
slot_overcut = 0.5;  // extra cutter length past faces to avoid coplanar faces

// ---- Derived ----
x0 = -block_len/2 + slot_len/2;  // first slot start X (group centred in X)
y0 = -block_wid/2 + slot_pitch/2 * (slot_count - 1)/2;  // first slot centre Y

$fn = 64;

difference() {
    // Solid base block
    translate([0, 0, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slots, open at top
    for (i = [0 : slot_count - 1]) {
        translate([x0 + i * slot_pitch, y0 + i * slot_pitch, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + slot_overcut]);
    }
}