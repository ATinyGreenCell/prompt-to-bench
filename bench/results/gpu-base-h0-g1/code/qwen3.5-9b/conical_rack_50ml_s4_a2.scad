// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down (walls up, holes in plate).
// After printing, flip over to stand on walls.

// --- Dimensions ---
// Plate dimensions
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

// --- Main Build ---
difference() {
    // 1. The Base Plate
    // Lies on Z=0 to Z=4
    translate([0, 0, 0])
    cube([
        $plate_length,
        $plate_width,
        $plate_thickness
    ]);

    // 2. The Two Side Walls
    // They rise from the plate (Z=4) to Z=70.
    // They are flush with the long edges (Y = +/- $plate_width/2).
    // Wall thickness is in Y direction.
    
    // Left Wall (at Y = -45)
    // Position: Centered on the left edge of the plate.
    // Plate left edge is at Y = -45.
    // Wall extends from Y = -49 to Y = -45.
    translate([0, -$plate_width/2 - $wall_thickness/2, 0])
    cube([
        $wall_length,
        $wall_thickness,
        $wall_height
    ]);

    // Right Wall (at Y = +45)
    // Position: Centered on the right edge of the plate.
    // Plate right edge is at Y = +45.
    // Wall extends from Y = +45 to Y = +49.
    translate([0, $plate_width/2 - $wall_thickness/2, 0])
    cube([
        $wall_length,
        $wall_thickness,
        $wall_height
    ]);

    // 3. Cut the Holes
    // We cut through the entire assembly (plate + walls) to ensure tubes pass through.
    // We extend the cut slightly past the top of the walls to ensure clean removal.
    $cut_extension = 1; 
    
    // Calculate hole positions
    // X positions: -65, 0, 65 (since length is 130 and spacing is 40)
    // Y positions: -45, 45 (since width is 90 and spacing is 40)
    for (x = [-65, 0, 65]) {
        for (y = [-45, 45]) {
            translate([x, y])
            cylinder(
                h = $wall_height + $cut_extension,
                d = $hole_diameter,
                $fn = $fn
            );
        }
    }
}