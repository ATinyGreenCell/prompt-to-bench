// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down (walls up, holes in plate).
// After printing, flip over to stand on walls.

// --- Dimensions ---
// Plate dimensions (Centered on Origin)
$plate_length = 130; // X
$plate_width = 90;   // Y
$plate_thickness = 4; // Z

// Hole specifications
$hole_diameter = 30.5;
$hole_count_x = 3;
$hole_count_y = 2;
$hole_spacing_x = 40; // Centre-to-centre
$hole_spacing_y = 40; // Centre-to-centre

// Wall specifications
$wall_length = 130;   // X
$wall_thickness = 4;  // Y
$wall_height = 70;    // Z (total height from bed)

// --- Configuration ---
$fn = 64; // Smooth curves for holes

// --- Main Module ---
module tube_rack() {
    union() {
        // 1. The Base Plate
        // Lies on Z=0 to