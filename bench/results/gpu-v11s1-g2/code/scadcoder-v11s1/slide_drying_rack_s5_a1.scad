// Microscope slide drying rack
// Print orientation: base block on XY plane, slots open upward (+Z)

// ---------- Parameters ----------
base_len    = 90;    // base block length along X (mm)
base_wid    = 45;    // base block width along Y (mm)
base_h      = 20;    // base block height along Z (mm)

slot_count  = 10;    // number of slide slots
slot_len    = 77;    // slot length along X (mm)
slot_w      = 1.6;   // slot width along Y (mm)
slot_depth  = 10;    // slot depth into block from top face (mm)
slot_pitch  = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps         = 0.5;   // overshoot of cutters past the top face (mm)

$fn = 64;

// ---------- Derived ----------
slot_start_y = -(slot_count - 1) * slot_pitch / 2;  // first slot centre Y

// ---------- Model ----------
difference() {
    // Solid base block, centred in X and Y
    translate([-base_len / 2, -base_wid / 2, 0])
        cube([base_len, base_wid, base_h]);

    // Parallel slots running along X, open at the top
    for (i = [0 : slot_count - 1])
        translate([0, slot_start_y + i * slot_pitch, base_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
}