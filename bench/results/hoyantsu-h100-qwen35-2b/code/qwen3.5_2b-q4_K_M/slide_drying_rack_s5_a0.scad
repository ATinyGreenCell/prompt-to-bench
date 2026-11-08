// Design a drying rack for microscope slides.
// Units: millimetres (mm)

// Define dimensions based on user measurements
block_length = 90;      // X dimension
block_width    = 45;     // Y dimension
block_height   = 20;     // Z dimension
slide_size_x   = 75;     // Slide length along X
slide_size_y   = 25;     // Slide width along Y
slide_thickness = 1;     // Slide thickness (Z)

// Define slot parameters
slot_length    = 77;      // Length of the slot along X
slot_width     = 1.6;     // Width of the slot along Y
slot_depth     = 10;      // Depth of the slot along Z
slot_spacing   = 3.5;     // Center-to-center spacing in Y

// Create the main base block
base_block = cube([block_length, block_width, block_height]);

// Create the 10 slide holes (vertical cylinders)
slide_holes = for(i=0 to 9) {
    translate([i * slot_spacing, 0, 0]) cylinder([slide_size_x, slide_thickness, 2]);
};

// Cut the slots from the top face of the base block
// Note: The user specified "open at the top", meaning we cut a hole through the Z dimension.
// We use difference to carve out the slot volume.
// To ensure no coplanar faces (Rule 5), we extend cuts slightly past the boundaries.

slot_cut = for(i=0 to 9) {
    translate([i * slot_spacing, 0, 0]) square([slide_length + 1, slot_width + 2]); // +1 and +2 for extension
};

// Combine base block with slots (Union)
drying_rack = union([base_block, slide_holes, slot_cut]);

// Final assembly: Add a small lip or thickness to the top face so it sits flat on the table.
// This ensures stability and visual completeness without adding significant volume if not needed.
// However, strictly following "open at the top", we just leave the hole there.
// Let's add a slight rim for better aesthetics and printing support.

rim = cube([block_length + 1, block_width - 2, 0]); // Top face only
drying_rack_with_rim = union([base_block, slide_holes, slot_cut, rim]);

print(drying_rack_with_rim);