// Drying Rack for 10 Microscope Slides
// Units: Millimeters

// Base Block Dimensions
base_len = 90;      // Length of the base block (X-axis)
base_wid = 45;       // Width of the base block (Y-axis)
base_hgt = 20;       // Height of the base block (Z-axis)

// Slot Dimensions
slot_count = 10;     // Number of slots to cut
slot_len = 77;       // Length of each slot (X-axis)
slot_wid = 1.6;      // Width of each slot (Y-axis)
slot_depth = 10;   // Depth of each slot (Z-axis)

// Slot Spacing
slot_spacing = 3.5;  // Center-to-center spacing between slots (Y-axis)

// Safety Margin for Cutting
cut_margin = 0.05;   // Margin to extend cutter past cut faces (mm)

// Main Module
module drying_rack() {
    // Base Block
    base_block = cube([base_len, base_wid, base_hgt]);

    // Slots
    slots = [];
    for (i = [0 : slot_count - 1]) {
        // Calculate Y position for each slot to center the group
        // Total span = (count - 1) * spacing. Center is at 0.
        // i=0 -> -4.5 * spacing, i=9 -> +4.5 * spacing
        slot_y = (i - (slot_count - 1) / 2) * slot_spacing;
        
        // Calculate Z position for the cutter
        // Slot goes from (base_hgt - slot_depth) to base_hgt
        // Cutter must extend past these faces
        slot_cut_z = base_hgt - slot_depth;
        cutter_z = slot_cut_z + slot_depth / 2;
        
        // Create cutter cube
        cutter = cube([
            slot_len,
            slot_wid,
            slot_depth + (cut_margin * 2)
        ]);
        
        // Translate cutter to position
        slots += [translate([0, slot_y, cutter_z]) * cutter];
    }

    // Combine base and slots
    union() {
        base_block;
        for (s = slots) {
            s;
        }
    }
}

// Difference operation to cut slots into base
difference() {
    // Base block
    cube([base_len, base_wid, base_hgt]);
    
    // Cutters
    for (i = [0 : slot_count - 1]) {
        slot_y = (i - (slot_count - 1) / 2) * slot_spacing;
        slot_cut_z = base_hgt - slot_depth;
        cutter_z = slot_cut_z + slot_depth / 2;
        
        translate([0, slot_y, cutter_z]) {
            cube([
                slot_len,
                slot_wid,
                slot_depth + (cut_margin * 2)
            ]);
        }
    }
}