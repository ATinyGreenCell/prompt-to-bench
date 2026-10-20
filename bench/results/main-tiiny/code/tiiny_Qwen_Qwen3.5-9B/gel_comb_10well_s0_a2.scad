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
difference() {
    // Outer block (Spine)
    cube([
        $spine_length, 
        $spine_width, 
        $plate_thickness
    ]);
    
    // Cut out the 10 wells
    // Align Y=0 with the spine edge to ensure teeth hang from that edge
    for (i = [0 : $tooth_count - 1]) {
        translate([
            $center_offset + (i * $tooth_spacing), 
            0, // Align with spine edge (Y=0)
            0
        ]) {
            cylinder(
                h = $plate_thickness + 0.1, // Extend slightly past face
                r = $tooth_width / 2,
                $fn = 64
            );
        }
    }
}