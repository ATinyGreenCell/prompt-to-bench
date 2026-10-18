// Slide drying rack - holds 10 microscope slides standing upright on their long edge
// Units: mm. Print orientation: base on XY plane, building up +Z.

// ---- Block ----
block_len   = 90;    // block length along X
block_wid   = 45;    // block width along Y
block_ht    = 20;    // block height along Z

// ---- Slots ----
slot_count  = 10;    // number of slide slots
slot_len    = 77;    // slot length along X (slide length + clearance)
slot_wid    = 1.6;   // slot width along Y
slot_depth  = 10;    // slot depth from top face along -Z
slot_pitch  = 3.5;   // centre-to-centre spacing along Y
eps         = 0.5;   // overshoot past cut faces to avoid coplanar faces

$fn = 64;

difference() {
    // Base block, centred in X and Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slot group, centred on the block in X and Y
    for (i = [0 : slot_count - 1]) {
        x = (i - (slot_count - 1)/2) * slot_pitch;
        translate([x - slot_len/2, 0, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}