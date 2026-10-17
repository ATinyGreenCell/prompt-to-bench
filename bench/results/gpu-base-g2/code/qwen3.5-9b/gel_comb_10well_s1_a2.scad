// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).
// Dimensions in millimetres.

// --- Dimensions ---
// Spine (Back Bar)
$spine_length = 70;   // X dimension
$spine_width = 12;    // Y dimension
$plate_thickness = 1.5; // Z dimension

// Teeth
$num_teeth = 10;
$tooth_width = 5.0;   // X dimension
$tooth_length = 12;   // Y dimension (extends from spine edge)
$gap_size = 1.5;      // Gap between teeth

// --- Calculations ---
// Total width of the teeth row
$total_teeth_width = $num_teeth * $tooth_width;
// Total width of the gaps
$total_gap_width = ($num_teeth - 1) * $gap_size;
// Total width of the tooth row including gaps
$tooth_row_width = $total_teeth_width + $total_gap_width;

// Centering offset in X: The row must be centered on the spine.
// Spine spans [-35, 35]. Row must span [-RowWidth/2, +RowWidth/2].
$tooth_row_start_x = -($tooth_row_width / 2);

// Position of the spine edge from which teeth hang (-Y direction)
// Spine is 12mm wide. Teeth hang from the bottom edge (Y = -6).
$spine_bottom_y = -$spine_width / 2;
$tooth_start_y = $spine_bottom_y;
$tooth_end_y = $tooth_start_y - $tooth_length;

// --- Main Body (Spine) ---
// The spine is a flat plate 70x12x1.5
// We use a difference to cut the teeth out from the top surface only.
// The cut volume must extend slightly past the tooth length to ensure separation.
difference() {
    // Main block
    cube([
        $spine_length, 
        $spine_width, 
        $plate_thickness
    ], center = true);
    
    // Cut out the area where teeth will be attached to create a clean separation.
    // We cut a rectangle slightly larger than the tooth row to ensure separation.
    // The cut extends 0.1mm past the tooth length in -Y to ensure the teeth are not fused.
    translate([
        $tooth_row_start_x - 0.1, // Left edge of tooth row - clearance
        $spine_bottom_y + 0.1,    // Top edge of spine + clearance
        0.1                       // Just below surface
    ])
    cube([
        $tooth_row_width + 0.2,
        $tooth_length + 0.2,
        $plate_thickness + 0.2
    ]);
}

// --- Teeth ---
// Loop to generate 10 teeth
for (i = [0 : $num_teeth - 1]) {
    // Calculate X position for this tooth
    // Start at $tooth_row_start_x, add tooth_width and gap_size for each previous tooth
    $current_x = $tooth_row_start_x + ($tooth_width + $gap_size) * i;
    
    // Translate to position
    translate([
        $current_x, 
        $tooth_start_y, 
        0
    ])
    // Tooth is a rectangular prism: width x length x thickness
    // Width is X, Length is -Y, Thickness is Z
    cube([
        $tooth_width,
        $tooth_length,
        $plate_thickness
    ]);
}