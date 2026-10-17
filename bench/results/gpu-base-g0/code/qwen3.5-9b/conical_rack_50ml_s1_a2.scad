// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over so walls stand on bed and tubes hang down.

// --- Dimensions ---
// Plate size
$plate_x = 130;
$plate_y = 90;
$plate_z = 4;

// Hole specifications
$hole_diameter = 30.5;
$hole_spacing_x = 40;
$hole_spacing_y = 40;

// Wall specifications
$wall_length = 130;
$wall_thickness = 4;
$wall_height = 70; // Total height from plate top (Z=4) to top of wall

// --- Configuration ---
$fn = 64; // Smoothness for holes

// --- Main Body ---
difference() {
    // 1. The Base Plate
    // Dimensions: X=$plate_x, Y=$plate_y, Z=$plate_z
    // Centered at (0,0, $plate_z/2)
    translate([0, 0, $plate_z/2])
    cube([
        $plate_x,
        $plate_y,
        $plate_z
    ]);

    // 2. The Walls
    // Two walls along the long edges (Y direction).
    // They sit on top of the plate (Z starts at $plate_z).
    // Length = $plate_x, Thickness = $wall_thickness, Height = $wall_height.
    
    // Left Wall
    translate([
        -$plate_x/2, 
        -$wall_thickness/2, 
        $plate_z
    ])
    cube([
        $wall_length,
        $wall_thickness,
        $wall_height
    ]);
    
    // Right Wall
    translate([
        $plate_x/2, 
        -$wall_thickness/2, 
        $plate_z
    ])
    cube([
        $wall_length,
        $wall_thickness,
        $wall_height
    ]);

    // 3. The Holes (Cutting shapes)
    // We need to cut cylinders through the plate.
    // To ensure clean cuts, we extend the cylinder slightly past the plate boundaries.
    // Cylinder Z range: from Z = -$0.1 (past bottom) to Z = $wall_height + $0.1 (past top of walls)
    
    hole_z_start = -$0.1;
    hole_z_end = $wall_height + $0.1;
    
    // Generate X positions: -1.5*spacing, 0, +1.5*spacing
    for (xi = [-($hole_spacing_x * 1.5), 0, ($hole_spacing_x * 1.5)]) {
        // Generate Y positions: -0.5*spacing, +0.5*spacing
        for (yi = [-($hole_spacing_y * 0.5), ($hole_spacing_y * 0.5)]) {
            translate([
                xi,
                yi,
                hole_z_start
            ])
            cylinder(
                h = hole_z_end - hole_z_start,
                r = $hole_diameter / 2,
                $fn = $fn
            );
        }
    }
}