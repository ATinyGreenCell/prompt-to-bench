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

// --- Derived Variables ---
// Calculate hole positions relative to plate centre (0,0)
// Since there are 2 rows and 3 cols, and spacing is 40mm:
// X positions: -40, 0, 40
// Y positions: -40, 0, 40
$hole_x_positions = [-40, 0, 40];
$hole_y_positions = [-40, 0, 40];

// Global resolution for curved surfaces
$fn = 64;

// --- Main Module ---
module tube_rack() {
    // 1. Create the base plate
    // Dimensions: X=$plate_length, Y=$plate_width, Z=$plate_thickness
    plate = cube([
        $plate_length,
        $plate_width,
        $plate_thickness
    ]);

    // 2. Create the two side walls
    // Each wall is 130mm long (X), 4mm thick (Y), and rises 70mm from the top of the plate.
    // Since the plate is 90mm wide and walls are 4mm thick, we place them at the edges.
    // Wall 1 (Left): X from 0 to 130, Y from 0 to 4
    // Wall 2 (Right): X from 0 to 130, Y from 86 to 90
    // They start at Z = $plate_thickness and go to Z = $plate_thickness + $wall_height
    
    wall_left = translate([0, 0, $plate_thickness]) 
                cube([
                    $wall_length,
                    $wall_thickness,
                    $wall_height
                ]);
    
    wall_right = translate([0, $plate_width - $wall_thickness, $plate_thickness]) 
                  cube([
                      $wall_length,
                      $wall_thickness,
                      $wall_height
                  ]);

    // 3. Create the holes
    // We need to subtract cylinders from the plate.
    // To ensure clean cuts, we extend the cutting cylinder slightly past the plate faces.
    // We also ensure the cylinder is tall enough to cut through the walls if they were solid,
    // but here we are subtracting from the union of plate and walls.
    // Actually, simpler approach: Union plate + walls, then subtract holes.
    
    // Start with the solid block (Plate + Walls)
    solid_base = union(
        plate,
        wall_left,
        wall_right
    );

    // Prepare the hole cutter
    // Radius
    $r = $hole_diameter / 2;
    // Extend slightly past the top of the walls to ensure clean cut
    $cut_height = $wall_height + 2; 
    
    // Create the hole cutter cylinder
    hole_cutter = cylinder(
        h = $cut_height,
        r1 = $r,
        r2 = $r,
        $fn = 64
    );

    // Position the hole cutters
    // We iterate through the calculated positions
    hole_cutters = for (x_pos = $hole_x_positions, y_pos = $hole_y_positions) {
        translate([x_pos, y_pos, $plate_thickness]) 
            hole_cutter
    };

    // Final assembly: Union base, then Difference with hole cutters
    result = difference() {
        solid_base;
        hole_cutters;
    };

    // Render the result
    difference() {
        // Re-create the solid base to ensure we are subtracting from the correct geometry
        // (Note: The logic above creates 'result', but to use it in a difference block 
        // we need to reconstruct the geometry or use the 'result' variable directly if allowed.
        // Standard practice: Construct the positive geometry, then subtract.
        
        // Let's rebuild the positive geometry explicitly for the difference block
        positive_geom = union(
            cube([
                $plate_length,
                $plate_width,
                $plate_thickness
            ]),
            translate([0, 0, $plate_thickness]) 
                cube([
                    $wall_length,
                    $wall_thickness,
                    $wall_height
                ]),
            translate([0, $plate_width - $wall_thickness, $plate_thickness]) 
                cube([
                    $wall_length,
                    $wall_thickness,
                    $wall_height
                ])
        );

        // Subtract holes
        for (x_pos = $hole_x_positions, y_pos = $hole_y_positions) {
            translate([x_pos, y_pos, $plate_thickness]) 
                cylinder(
                    h = $wall_height + 2,
                    r1 = $hole_diameter / 2,
                    r2 = $hole_diameter / 2,
                    $fn = 64
                );
        }
    }
}

// Generate the part
tube_rack();