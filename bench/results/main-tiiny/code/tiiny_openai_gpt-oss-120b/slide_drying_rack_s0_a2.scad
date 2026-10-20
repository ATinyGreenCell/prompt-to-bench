// ---------------
// Parameters (mm)
// ---------------
$fn = 64;               // resolution for any curved primitives

base_len   = 90;    // X length of the base block
base_wid   = 45;    // Y width of the base block
base_h     = 20;    // Z height of the base block

slot_len   = 77;    // Length of each slot along X
slot_wid   = 1.6;   // Width of each slot along Y
slot_depth = 10;    // Depth of each slot down from the top face

slot_count = 10;    // Number of slots
slot_spacing = 3.5; // Centre‑to‑centre spacing of slots in Y

extra = 0.2;        // Clearance added to each cut face (mm)

// Pre‑computed total span of the slot group (centre‑to‑centre)
total_span = (slot_count - 1) * slot_spacing;

// ---------------
// Modules
// ---------------

// Solid base block (resting on XY plane, centred in X and Y)
module base_block() {
    translate([0, 0, base_h/2])
        cube([base_len, base_wid, base_h], center = true);
}

// Cutting shape for a single slot (centered at its own origin)
module slot_cut() {
    cube([slot_len + extra,
          slot_wid + extra,
          slot_depth + extra],
         center = true);
}

// ---------------
// Model
// ---------------
difference() {
    // Solid base
    base_block();

    // Slots cut out of the top face
    for (i = [0 : slot_count-1]) {
        translate([
            0,                                   // X centre (block centred)
            -total_span/2 + i * slot_spacing,   // Y centre of this slot
            base_h - slot_depth/2                // Z centre (just above top)
        ])
            slot_cut();
    }
}