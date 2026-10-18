// Slide drying rack - holds 10 microscope slides (75 x 25 x 1 mm) upright on their long edge
// Print orientation: base block on the bed, slots open upward (+Z)

// ---------- Parameters ----------
base_len      = 90;    // base block length along X
base_wid      = 45;    // base block width along Y
base_ht       = 20;    // base block height along Z

slot_len      = 77;    // slot length along X
slot_w        = 1.6;   // slot width along Y
slot_depth    = 10;    // slot depth into the block (from top face)
slot_count    = 10;    // number of slots
slot_pitch    = 3.5;   // centre-to-centre slot spacing along Y

eps           = 0.5;   // cutter overshoot past the top face

$fn = 96;

// ---------- Model ----------
difference() {
    // Solid base block, centred in X and Y, resting on z = 0
    translate([-base_len/2, -base_wid/2, 0])
        cube([base_len, base_wid, base_ht]);

    // Row of parallel slots, centred on the block in X and Y
    for (i = [0 : slot_count - 1]) {
        y_c = (i - (slot_count - 1)/2) * slot_pitch;
        translate([-slot_len/2, y_c, base_ht - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}