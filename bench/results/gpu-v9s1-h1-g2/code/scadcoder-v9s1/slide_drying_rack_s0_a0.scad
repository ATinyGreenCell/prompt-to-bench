// Microscope slide drying rack
// Print orientation: base block on XY plane, slots open upward (+Z)

// ---------- Parameters ----------
slide_count     = 10;    // number of microscope slides
slide_len       = 75;    // slide length along X (mm)
slide_wid       = 25;    // slide width along Y (mm)
slide_thk       = 1;     // slide thickness along Z (mm)

base_len        = 90;    // base block length along X (mm)
base_wid        = 45;    // base block width along Y (mm)
base_hgt        = 20;    // base block height along Z (mm)

slot_len        = 77;    // slot length along X (mm)
slot_wid        = 1.6;   // slot width along Y (mm)
slot_depth      = 10;    // slot depth from top face (mm)
slot_pitch      = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps             = 0.5;   // overcut past faces to avoid coplanar surfaces (mm)

$fn = 64;

// ---------- Derived ----------
slot_y0 = -(slot_count - 1) * slot_pitch / 2;   // first slot centre Y

// ---------- Model ----------
difference() {
    // Base block, centred in X and Y, sitting on z = 0
    translate([-base_len / 2, -base_wid / 2, 0])
        cube([base_len, base_wid, base_hgt]);

    // Parallel slots running along X, open at the top
    for (i = [0 : slot_count - 1]) {
        translate([-(slot_len / 2 - eps), slot_y0 + i * slot_pitch, base_hgt - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}