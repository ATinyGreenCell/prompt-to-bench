// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over so walls stand on bed and tubes insert from top.

// --- Dimensions (mm) ---
// Plate dimensions
$plate_length_X = 130;
$plate_width_Y = 90;
$plate_thickness = 4;

// Hole specifications
$hole_diameter = 30.5;
$hole_count = 6;
$hole_rows_Y = 2;
$hole_cols_X = 3;
$hole_spacing_X = 40;
$hole_spacing_Y = 40;

// Wall specifications
$wall_length_X = 130;
$wall_thickness_Y = 4;
$wall_height_Z = 70; // Total height from bed to top of wall

// --- Derived Variables ---
// Center of plate
$center_X = 0;
$center_Y = 0;

// Hole positions (calculated to be centered on plate)
// Row 1 (Y = -spacing/2)
$hole_y_1 = -$hole_spacing_Y / 2;
// Row 2 (Y = +spacing/2)
$hole_y_2 = $hole_spacing_Y / 2;

// Column X positions (centered on length)
// Total length 130, spacing 40. 
// Positions: -60, 0, 60 relative to center? 
// Let's verify: Center is 0. 
// If spacing is 40, and we have 3 holes.
// Hole 1: -40, Hole 2: 0, Hole 3: 40? 
// Distance between 1 and 3 is 80. 
// If centered on 130mm plate:
// Left edge = -65, Right edge = +65.
// If holes are at -40, 0, 40:
// Distance from left edge to first hole = 25mm.
// Distance from last hole to right edge = 25mm.
// This seems correct for "centred on the plate".
$hole_x_1 = -$hole_spacing_X;
$hole_x_2 = 0;
$hole_x_3 = $hole_spacing_X;

// --- Main Module ---
module tube_rack() {
    $fn = 64; // Ensure round holes

    // 1. The Base Plate
    // Lies on Z=0, extends to Z=$plate_thickness
    plate = translate([0, 0, 0]) 
        cube([$plate_length_X, $plate_width_Y, $plate_thickness]);

    // 2. The Two Side Walls
    // Rise from Z=$plate_thickness to Z=$plate_thickness + $wall_height_Z
    // Actually, the prompt says "rises from the plate to z = 70".
    // Since plate is 4mm thick, the walls start at Z=4 and go to Z=70.
    // Length is 130mm (X), Thickness is 4mm (Y).
    // They are flush with the long edges (Y = +/- 45).
    
    wall_height_total = $plate_thickness + $wall_height_Z;
    
    // Left Wall
    wall_left = translate([0, -$plate_width_Y/2 - $wall_thickness_Y/2, $plate_thickness])
        cube([$wall_length_X, $wall_thickness_Y, $wall_height_Z]);
        
    // Right Wall
    wall_right = translate([0, $plate_width_Y/2 - $wall_thickness_Y/2, $plate_thickness])
        cube([$wall_length_X, $wall_thickness_Y, $wall_height_Z]);

    // 3. The Holes
    // We need to cut holes through the plate.
    // The walls are solid, so holes only affect the plate.
    // We create cylinders that extend slightly past the plate thickness to ensure clean cut.
    
    hole_cylinders = [];
    for (i = [1 : $hole_cols_X]) {
        for (j = [1 : $hole_rows_Y]) {
            // Determine Y coordinate based on row index
            if (j == 1) {
                current_y = $hole_y_1;
            } else {
                current_y = $hole_y_2;
            }
            
            // Determine X coordinate based on col index
            if (i == 1) {
                current_x = $hole_x_1;
            } else if (i == 2) {
                current_x = $hole_x_2;
            } else {
                current_x = $hole_x_3;
            }
            
            // Create cylinder extending slightly below Z=0 and above Z=4
            // Extending 0.5mm past each face
            hole_cylinders.push(
                translate([current_x, current_y, -0.5])
                cylinder(h = $plate_thickness + 1, r = $hole_diameter / 2)
            );
        }
    }

    // Union the solid parts (Plate + Walls)
    solid_base = union(
        plate,
        wall_left,
        wall_right
    );

    // Difference to cut holes
    result = difference() {
        solid_base;
        for (c = hole_cylinders) {
            c;
        }
    };

    // Output the final geometry
    result;
}

// Generate the part
tube_rack();