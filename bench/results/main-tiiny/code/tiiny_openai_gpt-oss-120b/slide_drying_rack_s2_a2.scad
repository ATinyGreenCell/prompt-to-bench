// ---------- Parameters ----------
base_len   = 90;    // X dimension of base block (mm)
base_wid   = 45;    // Y dimension of base block (mm)
base_h     = 20;    // Z dimension of base block (mm)

slot_len   = 77;    // Length of each slot along X (mm)
slot_wid   = 1.6;   // Width of each slot along Y (mm)
slot_depth = 10;    // Depth of each slot down from top surface (mm)

slot_count = 10;    // Number of slots
slot_spacing = 3.5; // Centre‑to‑centre spacing between slots (mm)

extra = 0.1;        // Over‑extension for cutting shapes (mm)

$fn = 64;           // Resolution for curved features (not needed here)

// ---------- Model ----------
module drying_rack() {
    difference() {
        // Solid base block, centred on origin
        cube([base_len, base_wid, base_h], center = true);

        // Slots cut from the top face
        union() {
            for (i = [0:slot_count-1]) {
                // Y centre of the i‑th slot
                y_center = -((slot_count - 1) * slot_spacing) / 2 + i * slot_spacing;

                // Cutting cube (extends slightly beyond the intended faces)
                translate([
                    -slot_len/2,                     // centre slot in X
                    y_center - slot_wid/2,           // lower Y bound of slot
                    base_h - slot_depth - extra       // lower Z bound (just below intended depth)
                ])
                    cube([
                        slot_len,
                        slot_wid,
                        slot_depth + 2*extra           // height includes over‑extension
                    ]);
            }
        }
    }
}

// ---------- Render ----------
drying_rack();