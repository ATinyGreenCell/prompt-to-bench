// ---------- Parameters ----------
block_len   = 90;    // X dimension of base block (mm)
block_wid   = 45;    // Y dimension of base block (mm)
block_hgt   = 20;    // Z dimension of base block (mm)

slot_len    = 77;    // Length of each slot along X (mm)
slot_wid    = 1.6;   // Width of each slot along Y (mm)
slot_depth  = 10;    // Depth of each slot into the block (mm)

slot_spacing = 3.5; // Centre‑to‑centre spacing of slots in Y (mm)
slot_count   = 10;  // Number of slots

cut_extra = 0.01;    // Extra amount for cutting shapes to extend beyond faces (mm)

// ---------- Derived values ----------
slot_y_start = -((slot_count-1)/2) * slot_spacing; // first centre Y position (mm)

// ---------- Modules ----------
module base_block() {
    // Block centred on the origin, resting on the XY plane (z = 0)
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_hgt]);
}

module slot_cut(i) {
    // Compute centre Y for slot i
    y_center = slot_y_start + i*slot_spacing;
    // Translate slot so that its lower corner is at the correct position
    translate([
        -slot_len/2,                     // X: centred on origin
        y_center - slot_wid/2,           // Y: centred on its centre
        block_hgt - slot_depth - cut_extra // Z: bottom just below the top face
    ])
        // Cutting prism, extended a little beyond top and bottom faces
        cube([slot_len, slot_wid, slot_depth + 2*cut_extra]);
}

// ---------- Model ----------
$fn = 64; // smoothness for cylinders/spheres (not used here)

difference() {
    base_block();
    // Create all slots
    for (i = [0 : slot_count-1])
        slot_cut(i);
}