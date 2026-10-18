// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed for FDM printing. Rests on XY plane at Z=0.

// Block Dimensions
$block_length = 106; // X
$block_width = 72;   // Y
$block_height = 30;  // Z

// Grid Configuration
$hole_count_x = 6;   // Holes along X
$hole_count_y = 4;   // Holes along Y
$hole_spacing_x = 16; // Centre-to-centre X
$hole_spacing_y = 16; // Centre-to-centre Y

// Hole Dimensions
$hole_diameter = 11.2;
$hole_depth = 25;    // Open at top, closed at bottom
$floor_thickness = 5; // Solid floor at bottom (30 - 25 = 5)

// Quality Settings
$fn = 64;

// --- Main Block ---
block = cube([
    $block_length,
    $block_width,
    $block_height
], center = true);

// --- Hole Generator ---
// Calculate grid origin to center the grid on the block
// Total span X = (count_x - 1) * spacing_x
// Total span Y = (count_y - 1) * spacing_y
// Origin X = -Total_span_X / 2
// Origin Y = -Total_span_Y / 2

$grid_origin_x = -(($hole_count_x - 1) * $hole_spacing_x) / 2;
$grid_origin_y = -(($hole_count_y - 1) * $hole_spacing_y) / 2;

// Create holes using difference
// Holes are cylinders. To ensure clean cuts, we extend them slightly past the intended depth.
// The block is 30mm tall (centered at Z=0, so top is Z=15).
// Holes are 25mm deep. We cut from Z=15 down to Z=-10 (15 - 25 = -10).
// The floor is 5mm thick, so it ends at Z=-5.
// We cut from Z=15 down to Z=-10.01 to ensure the cut clears the Z=-5 plane completely.

holes = for (i = 0 : $hole_count_x - 1) {
    for (j = 0 : $hole_count_y - 1) {
        translate([
            $grid_origin_x + i * $hole_spacing_x,
            $grid_origin_y + j * $hole_spacing_y,
            0 // Z position relative to block center will be handled by the block centering
        ])
        cylinder(
            h = $hole_depth + 0.1, // Extend slightly past the floor to ensure clean cut
            r = $hole_diameter / 2,
            center = true
        )
    }
};

// --- Final Assembly ---
difference() {
    union() {
        block;
    }
    holes;
}