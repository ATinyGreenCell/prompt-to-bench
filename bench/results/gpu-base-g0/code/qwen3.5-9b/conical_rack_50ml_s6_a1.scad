// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over to stand on the two side walls.

// --- Dimensions ---
// Plate dimensions
$plate_length = 130; // X
$plate_width = 90;   // Y
$plate_thickness = 4; // Z

// Hole specifications
$hole_count = 6;
$hole_diameter = 30.5;
$hole_spacing_x = 40; // Centre-to-centre along X
$hole_spacing_y = 40; // Centre-to-centre along Y

// Wall specifications
$wall_length = 130;   // X
$wall_thickness = 4;  // Y
$wall_height = 70;    // Z (total height from bed)

// --- Configuration ---
$fn = 64; // Smooth curves for holes

// --- Calculations ---
// Plate center
$plate_center_x = $plate_length / 2;
$plate_center_y = $plate_width / 2;

// Hole positions (3 rows along X, 2 rows along Y)
// X positions: 3 holes, 40mm spacing. Total span = 80mm.
// Plate width = 130mm. Margin = (130 - 80) / 2 = 25mm.
// Positions: 25, 65, 105.
$hole_x_positions = [25, 65, 105];

// Y positions: 2 holes, 40mm spacing. Total span = 40mm.
// Plate height = 90mm. Margin = (90 - 40) / 2 = 25mm.
// Positions: 25, 65.
$hole_y_positions = [25, 65];

// Wall positions (along long edges, Y = 0 and Y = 90)
// Walls are 4mm thick.
// Wall 1: Y 0 to 4.
// Wall 2: Y 86 to 90.
$wall_y_positions = [0, $plate_width - $wall_thickness];

// --- Main Module ---
module tube_rack() {
    union() {
        // 1. The Base Plate
        // Dimensions: 130 x 90 x 4
        translate([0, 0, 0])
            cube([$plate_length, $plate_width, $plate_thickness]);

        // 2.