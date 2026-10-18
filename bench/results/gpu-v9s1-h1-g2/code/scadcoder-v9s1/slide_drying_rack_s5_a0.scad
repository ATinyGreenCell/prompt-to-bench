// Slide drying rack - holds 10 microscope slides standing on their long edge
// Print orientation: base block on the bed (z = 0), slots open upward.

// ---------------- Parameters ----------------
n_slots      = 10;    // number of slide slots
slide_len    = 75;    // slide length along X (mm)
slide_wid    = 25;    // slide width along Y (mm)
slide_thk    = 1;     // slide thickness along Z (mm)

base_len     = 90;    // base block length along X (mm)
base_wid     = 45;    // base block width along Y (mm)
base_ht      = 20;    // base block height along Z (mm)

slot_len     = 77;    // slot length along X (mm)
slot_wid     = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps          = 0.5;   // overcut past faces to avoid coplanar surfaces (mm)

$fn = 64;

// ---------------- Derived ----------------
slot_x0 = -(slot_len - base_len) / 2;              // slot start X (centred on block)
slot_y0 = -(n_slots - 1) * slot_pitch / 2;          // first slot centre Y (group centred)

// ---------------- Model ----------------
difference() {
    // Base block
    translate([-base_len / 2, -base_wid / 2, 0])
        cube([base_len, base_wid, base_ht]);

    // Parallel slots, open at the top
    for (i = [0 : n_slots - 1])
        translate([slot_x0, slot_y0 + i * slot_pitch, base_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
}