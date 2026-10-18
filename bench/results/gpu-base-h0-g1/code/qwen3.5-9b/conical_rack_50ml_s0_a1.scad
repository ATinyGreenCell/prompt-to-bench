// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over so walls stand on bed and tubes insert from top.

// --- Dimensions ---
// Plate dimensions
$plate_length_X = 130; // mm
$plate_width_Y = 90;   // mm
$plate_thickness = 4;  // mm

// Hole specifications
$hole_diameter = 30.5; // mm
$hole_count = 6;
$hole_rows_Y = 2;
$hole_cols_X = 3;
$hole_spacing_X = 40; // mm centre-to-centre
$hole_spacing_Y = 40; // mm centre-to-centre

// Wall specifications
$wall_length_X = 130;  // mm
$wall_thickness_Y = 4; // mm
$wall_height = 70;     // mm (total height from bed)

// --- Main Module ---
module tube_rack() {
    // Set global resolution for curved holes
    $fn = 64;

    // 1. Create the base plate
    // Dimensions: X=$plate_length_X, Y=$plate_width_Y, Z=$plate_thickness
    plate = cube([
        $plate_length_X,
        $plate_width_Y,
        $plate_thickness
    ]);

    // 2. Create the two side walls
    // Each wall is 130mm long (X), 4mm thick (Y), and rises to Z=70.
    // They are attached to the long edges (Y = +/- 45mm).
    // We create them as separate blocks and union them with the plate.
    // Wall base is at Z=0, top at Z=70.
    
    // Left Wall (at Y = -45 + 2 = -43? No, flush with edge means Y = -45 to -41)
    // Actually, "flush with the plate's long edge" means the wall sits on the edge.
    // Plate Y range: -45 to +45.
    // Wall Y range: -45 to -41 (thickness 4) and +41 to +45 (thickness 4).
    
    wall_left = translate([0, -$plate_width_Y/2 - $wall_thickness_Y/2, 0], 
                           cube([$wall_length_X, $wall_thickness_Y, $wall_height]));
    
    wall_right = translate([0, $plate_width_Y/2 - $wall_thickness_Y/2, 0], 
                            cube([$wall_length_X, $wall_thickness_Y, $wall_height]));

    // Combine Plate and Walls
    base_structure = union(
        plate,
        wall_left,
        wall_right
    );

    // 3. Cut the holes
    // We use difference to cut the holes through the entire assembly.
    // To ensure clean cuts, we extend the cutting cylinders slightly past the faces.
    
    difference() {
        base_structure;
        
        // Define hole positions manually to avoid array syntax errors in older OpenSCAD versions
        // X positions: -40, 0, 40
        // Y positions: -20, 20
        // Total 6 holes
        
        // Row 1 (Y = -20)
        translate([-40, -20, -($wall_height + 1)/2], cylinder(h = $wall_height + 1, r = $hole_diameter / 2));
        translate[0, -20, -($wall_height + 1)/2], cylinder(h = $wall_height + 1, r = $hole_diameter / 2));
        translate[40, -20, -($wall_height + 1)/2], cylinder(h = $wall_height + 1, r = $hole_diameter / 2));
        
        // Row 2 (Y = 20)
        translate([-40, 20, -($wall_height + 1)/2], cylinder(h = $wall_height + 1, r = $hole_diameter / 2));
        translate[0, 20, -($wall_height + 1)/2], cylinder(h = $wall_height + 1, r = $hole_diameter / 2));
        translate[40, 20, -($wall_height + 1)/2], cylinder(h = $wall_height + 1, r = $hole_diameter / 2));
    }
}

// Instantiate the rack
tube_rack();