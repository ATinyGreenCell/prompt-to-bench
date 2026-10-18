// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over so walls stand on the bed and tubes insert from top.

// --- Dimensions ---
// Plate size
$plate_x = 130; // mm
$plate_y = 90;  // mm
$plate_z = 4;   // mm

// Hole specifications
$hole_diameter = 30.5; // mm
$hole_count_x = 3;     // 3 holes along X
$hole_count_y = 2;     // 2 holes along Y (rows)
$hole_spacing_x = 40;  // mm centre-to-centre
$hole_spacing_y = 40;  // mm centre-to-centre

// Wall specifications
$wall_length = 130;    // mm (along X)
$wall_thickness = 4;   // mm (along Y)
$wall_height = 70;     // mm (rise from plate)

// --- Derived Variables ---
// Calculate hole positions relative to plate center (0,0)
// X positions: -65, 0, 65 (since spacing is 40 and centered)
// Y positions: -40, 40 (since spacing is 40 and centered)
$hole_x_positions = [-65, 0, 65];
$hole_y_positions = [-40, 40];

// --- Configuration ---
$fn = 128; // High resolution for round holes

// --- Main Block ---
difference() {
    // 1. Create the base plate
    union() {
        // The plate itself
        translate([0, 0, 0]) 
            cube([$plate_x, $plate_y, $plate_z], center = false);
        
        // The two side walls
        // Wall 1: Left side (at Y = -$plate_y/2)
        translate([0, -$plate_y/2, 0]) 
            cube([$wall_length, $wall_thickness, $wall_height], center = false);
        
        // Wall 2: Right side (at Y = +$plate_y/2)
        translate([0, $plate_y/2, 0]) 
            cube([$wall_length, $wall_thickness, $wall_height], center = false);
    }
    
    // 2. Cut the holes
    // We iterate through the grid of holes
    for (xi = [0:$hole_count_x-1]) {
        for (yi = [0:$hole_count_y-1]) {
            // Calculate current hole center
            x_pos = $hole_x_positions[xi];
            y_pos = $hole_y_positions[yi];
            
            // Create a cylinder slightly larger than the hole to ensure clean cut
            // Extending 0.1mm past the face ensures no coplanar faces
            $cut_radius = ($hole_diameter / 2) + 0.1;
            
            translate([x_pos, y_pos, 0])
                cylinder(h = $wall_height + $plate_z + 1, r = $cut_radius, $fn = $fn);
        }
    }
}