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

// --- Helper: Center coordinates ---
// Plate is centered on origin.
$plate_x_center = 0;
$plate_y_center = 0;

// Calculate hole positions relative to plate center
// Row 1 (Y = -spacing/2), Row 2 (Y = +spacing/2)
// Col 1 (X = -spacing/2), Col 2 (X = 0), Col 3 (X = +spacing/2)
$hole_positions = [
    [ -$hole_spacing_x/2, -$hole_spacing_y/2 ],
    [  0,                 -$hole_spacing_y/2 ],
    [  $hole_spacing_x/2, -$hole_spacing_y/2 ],
    [ -$hole_spacing_x/2,  $hole_spacing_y/2 ],
    [  0,                 $hole_spacing_y/2 ],
    [  $hole_spacing_x/2,  $hole_spacing_y/2 ]
];

// --- Main Module ---
module tube_rack() {
    union() {
        // 1. The Base Plate
        // Lies on Z=0 to Z=$plate_thickness
        translate([0, 0, 0]) {
            cube([
                $plate_length,
                $plate_width,
                $plate_thickness
            ], center = false);
        }

        // 2. The Through-Holes
        // Cut into the plate. Extend slightly past Z=0 to ensure clean cut.
        for (p = $hole_positions) {
            translate(p) {
                difference() {
                    // The hole cylinder (slightly larger to ensure clean cut)
                    cylinder(
                        h = $plate_thickness + 0.1,
                        d = $hole_diameter,
                        center = true
                    );
                    // The solid plate part (slightly smaller to avoid coplanar faces)
                    cube([
                        $hole_diameter,
                        $hole_diameter,
                        $plate_thickness - 0.01
                    ], center = true);
                }
            }
        }

        // 3. The Side Walls
        // Two walls along the long edges (Y = +/- $plate_width/2).
        // They rise from Z=0 to Z=$wall_height.
        // Since the plate is 4mm thick, the walls effectively start at Z=0 and go up.
        // We model them as extrusions from the plate surface.
        
        // Left Wall (at Y = -$plate_width/2)
        translate([0, -$plate_width/2, 0]) {
            cube([
                $wall_length,
                $wall_thickness,
                $wall_height
            ], center = false);
        }

        // Right Wall (at Y = +$plate_width/2)
        translate([0, $plate_width/2, 0]) {
            cube([
                $wall_length,
                $wall_thickness,
                $wall_height
            ], center = false);
        }
    }
}

// Generate the part
tube_rack();