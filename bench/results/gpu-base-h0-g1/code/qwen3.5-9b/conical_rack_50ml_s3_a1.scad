// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0), walls rise up.
// After printing, flip over so walls stand on the bed and tubes hang down.

// --- Dimensions ---
// Plate dimensions
$plate_length = 130; // X dimension
$plate_width = 90;   // Y dimension
$plate_thickness = 4; // Z thickness

// Hole specifications
$hole_diameter = 30.5;
$hole_count = 6;
$hole_rows = 2;
$hole_cols = 3;
$hole_spacing_x = 40; // Centre-to-centre along X
$hole_spacing_y = 40; // Centre-to-centre along Y

// Wall specifications
$wall_length = 130;   // X dimension (matches plate length)
$wall_thickness = 4;  // Y dimension (matches plate thickness)
$wall_height = 70;    // Z height from top of plate

// Global resolution for curved surfaces
$fn = 64;

// --- Main Module ---
module tube_rack() {
    // Define hole positions
    $hole_x_positions = [-40, 0, 40];
    $hole_y_positions = [-40, 0, 40];

    // Start with the solid block (Plate + Walls)
    positive_geom = union(
        // Base Plate
        cube([
            $plate_length,
            $plate_width,
            $plate_thickness
        ]),
        // Left Wall
        translate([0, 0, $plate_thickness]) 
            cube([
                $wall_length,
                $wall_thickness,
                $wall_height
            ]),
        // Right Wall
        translate([0, $plate_width - $wall_thickness, $plate_thickness]) 
            cube([
                $wall_length,
                $wall_thickness,
                $wall_height
            ])
    );

    // Subtract holes
    // We extend the cutting cylinder slightly past the top of the walls to ensure clean cut
    $cut_height = $wall_height + 2; 
    $r = $hole_diameter / 2;

    difference() {
        positive_geom;
        for (x_pos = $hole_x_positions, y_pos = $hole_y_positions) {
            translate([x_pos, y_pos, $plate_thickness]) 
                cylinder(
                    h = $cut_height,
                    r1 = $r,
                    r2 = $r,
                    $fn = 64
                );
        }
    }
}

// Generate the part
tube_rack();