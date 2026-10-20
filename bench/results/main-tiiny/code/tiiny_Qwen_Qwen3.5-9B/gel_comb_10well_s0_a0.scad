$fn = 128;

// --- Dimensions ---
// Spine dimensions
$spine_length = 70;   // X dimension
$spine_width = 12;    // Y dimension
$plate_thickness = 1.5; // Z dimension

// Tooth dimensions
$tooth_width = 5.0;   // X dimension
$tooth_length = 12;   // Y dimension (matches spine width)
$tooth_count = 10;    // Number of wells
$gap_size = 1.5;      // Gap between teeth

// Derived dimensions
$tooth_spacing = $tooth_width + $gap_size;
$total_teeth_width = $tooth_count * $tooth_width;
$center_offset = ($spine_length - $total_teeth_width) / 2;

// --- Main Body ---
// Create the flat plate (spine)
difference() {
    // Outer block
    cube([
        $spine_length, 
        $spine_width, 
        $plate_thickness
    ]);
    
    // Cut out the 10 wells
    // We subtract cylinders to create the wells. 
    // Extending slightly past the face ensures clean cuts.
    for (i = [0 : $tooth_count - 1]) {
        translate([
            $center_offset + (i * $tooth_spacing), 
            $tooth_length / 2, // Center in Y
            0
        ]) {
            cylinder(
                h = $plate_thickness + 0.1, // Extend 0.1mm past face
                r = $tooth_width / 2,
                $fn = 64
            );
        }
    }
}