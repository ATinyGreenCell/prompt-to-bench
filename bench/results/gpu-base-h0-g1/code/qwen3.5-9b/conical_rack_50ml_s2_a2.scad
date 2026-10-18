// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over to stand on the two walls.

// --- Dimensions ---
// Plate dimensions
$plate_length = 130; // X dimension
$plate_width = 90;   // Y dimension
$plate_thickness = 4; // Z thickness

// Hole specifications
$hole_count = 6;
$hole_diameter = 30.5;
$hole_spacing_x = 40; // Centre-to-centre along X
$hole_spacing_y = 40; // Centre-to-centre along Y

// Wall specifications
$wall_length = 130;   // X dimension (matches plate length)
$wall_thickness = 4;  // Y dimension (matches plate width)
$wall_height = 70;    // Height from top of plate (Z = 4 to Z = 74)

// --- Configuration ---
$fn = 128; // High resolution for smooth holes and walls

// --- Main Module ---
module tube_rack() {
    union() {
        // 1. The Flat Plate
        // Lies on Z=0 to Z=4
        translate([0, 0, 0])
            cube([
                $plate_length,
                $plate_width,
                $plate_thickness
            ]);

        // 2. The Two Walls
        // Rise from Z=4 to Z=4+$wall_height
        // Located at the two long edges (Y = +/- plate_width/2)
        // We define the wall block to start at Z=0 to encompass the plate thickness
        // and then cut the holes through the entire height.
        
        // Wall positions: Along the two long edges (Y = +/- 45)
        $wall_y_positions = [-($plate_width/2), ($plate_width/2)];
        
        // Hole positions: 3 columns (X) x 2 rows (Y)
        $hole_x_positions = [-($hole_spacing_x/2), 0, ($hole_spacing_x/2)];
        $hole_y_positions = [-($hole_spacing_y/2), ($hole_spacing_y/2)];

        for (y_pos = $wall_y_positions) {
            translate([0, y_pos, 0])
                difference() {
                    // The wall block (including the part inside the plate)
                    translate([0, 0, 0])
                        cube([
                            $wall_length,
                            $wall_thickness,
                            $wall_height + $plate_thickness
                        ]);
                    
                    // Cut out the holes through the walls
                    // We extend the cut slightly to ensure clean removal
                    for (x_pos = $hole_x_positions) {
                        for (y_pos_h = $hole_y_positions) {
                            translate([x_pos, y_pos_h, 0])
                                cylinder(
                                    h = $wall_height + $plate_thickness + 0.1,
                                    d = $hole_diameter,
                                    $fn = $fn
                                );
                        }
                    }
                }
        }
    }
}

// Generate the part
tube_rack();