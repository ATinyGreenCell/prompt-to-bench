// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over so walls stand on bed and tubes hang down.

// --- Dimensions ---
// Plate size
$plate_x = 130; // mm
$plate_y = 90;  // mm
$plate_z = 4;   // mm

// Hole specifications
$hole_diameter = 30.5; // mm
$hole_count = 6;
$hole_rows = 2;
$hole_cols = 3;
$hole_spacing_x = 40; // mm centre-to-centre
$hole_spacing_y = 40; // mm centre-to-centre

// Wall specifications
$wall_length = 130; // mm (along X)
$wall_thickness = 4; // mm (along Y)
$wall_height = 70;  // mm (rise from plate to z = 70)

// --- Configuration ---
$fn = 128; // High resolution for smooth tube holes

// --- Helper: Generate hole positions ---
// We need 2 rows along Y and 3 columns along X.
// Total span X = 2 * spacing_x = 80. Center offset = 40.
// Total span Y = 1 * spacing_y = 40. Center offset = 20.
// Positions relative to plate center (0,0):
// Row 1 (Y = -20): X = -40, 0, 40
// Row 2 (Y = +20): X = -40, 0, 40

$hole_positions = [
    [-40, -20], [0, -20], [40, -20],
    [-40, 20], [0, 20], [40, 20]
];

// --- Main Module ---
module tube_rack() {
    // 1. The Base Plate
    // Lies on Z=0, extends to Z=$plate_z
    difference() {
        union() {
            // Base Plate
            cube([
                $plate_x, 
                $plate_y, 
                $plate_z
            ]);

            // 2. The Two Side Walls
            // They run along the long edges (X axis).
            // Left Wall: Y = 0 to $wall_thickness
            // Right Wall: Y = $plate_y - $wall_thickness to $plate_y
            // Both rise from Z=0 to Z=$wall_height
            
            // Left Wall
            translate([0, 0, 0]) 
                cube([
                    $wall_length, 
                    $wall_thickness, 
                    $wall_height
                ]);

            // Right Wall
            translate([0, $plate_y - $wall_thickness, 0]) 
                cube([
                    $wall_length, 
                    $wall_thickness, 
                    $wall_height
                ]);
        }

        // 3. Cut the Holes
        // Extend slightly past the plate thickness to ensure clean cut
        $cut_depth = $plate_z + 0.5; 
        
        for (p = $hole_positions) {
            translate(p)
                cylinder(
                    h = $cut_depth,
                    d = $hole_diameter,
                    $fn = $fn
                );
        }
    }
}

// Generate the part
tube_rack();