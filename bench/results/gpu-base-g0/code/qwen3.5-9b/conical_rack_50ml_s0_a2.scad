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
$hole_spacing_X = 40;  // mm (centre-to-centre)
$hole_spacing_Y = 40;  // mm (centre-to-centre)

// Wall specifications
$wall_length_X = 130;  // mm
$wall_thickness_Y = 4; // mm
$wall_height = 70;     // mm (total height from bed to top of wall)

// --- Global Settings ---
$fn = 128; // High resolution for smooth holes and walls

// --- Main Module ---
module tube_rack() {
    // 1. Create the base plate
    plate = cube([
        $plate_length_X,
        $plate_width_Y,
        $plate_thickness
    ]);

    // 2. Create the six through-holes
    // We use difference to cut holes through the plate
    // Define hole positions explicitly to avoid loop syntax errors
    hole_positions = [
        [-40, -20],
        [0, -20],
        [40, -20],
        [-40, 20],
        [0, 20],
        [40, 20]
    ];

    holes = difference() {
        union() {
            for (p = hole_positions) {
                translate(p) {
                    cylinder(
                        h = $plate_thickness + 1, // Extend slightly past plate to ensure clean cut
                        d = $hole_diameter,
                        $fn = 64
                    );
                }
            }
        }
    };

    // Combine plate and holes
    base_with_holes = difference() {
        plate;
        holes;
    };

    // 3. Create the two side walls
    // Walls run along the long edges (X axis), rising from Z=0 to Z=70
    // They are 4mm thick in Y, flush with the plate edges.
    
    // Left Wall (at Y = -45)
    wall_left = translate([0, -$plate_width_Y/2, 0]) {
        cube([
            $wall_length_X,
            $wall_thickness_Y,
            $wall_height
        ]);
    };

    // Right Wall (at Y = +45)
    wall_right = translate([0, $plate_width_Y/2, 0]) {
        cube([
            $wall_length_X,
            $wall_thickness_Y,
            $wall_height
        ]);
    };

    // 4. Final Assembly
    // Union the base (with holes) and the two walls
    union() {
        base_with_holes;
        wall_left;
        wall_right;
    }
}

// Generate the part
tube_rack();