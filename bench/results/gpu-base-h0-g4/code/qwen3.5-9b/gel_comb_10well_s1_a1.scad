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

// Centering offset in X to align the tooth row with the spine
// Spine is 70mm wide, Tooth Row is ~61.5mm wide.
// Offset = (Spine - Tooth Row) / 2
$x_offset = ($spine_length - $tooth_row_width) / 2;

// Position of the spine edge from which teeth hang (-Y direction)
// Spine is 12mm wide. Teeth hang from the bottom edge (Y = -6).
$spine_bottom_y = -$spine_width / 2;
$tooth_start_y = $spine_bottom_y;
$tooth_end_y = $tooth_start_y - $tooth_length;

// --- Main Body ---
// Create the spine plate
difference() {
    // Outer block (slightly larger to ensure clean cuts)
    cube([
        $spine_length + 0.1,
        $spine_width + 0.1,
        $plate_thickness + 0.1
    ], center = true);
    
    // Cut out the space where teeth will be (negative Y side)
    // We cut a rectangle that is the full spine length, 
    // starting from the bottom edge and going down by tooth_length + gap_buffer
    translate([0, $tooth_start_y, 0]) {
        cube([
            $spine_length + 0.1,
            $tooth_length + 0.1, // Extend slightly past the tooth length
            $plate_thickness + 0.1
        ]);
    }
}

// --- Teeth ---
// Loop to create each tooth
for (i = [0 : $num_teeth - 1]) {
    // Calculate X position for this tooth
    // Start at x_offset, add tooth_width, then add gap (except for the last tooth)
    $current_x = $x_offset;
    for (j = [0 : i - 1]) {
        $current_x += $tooth_width + $gap_size;
    }
    
    translate([
        $current_x,
        $tooth_start_y,
        0
    ]) {
        // Create the tooth
        // Dimensions: Width ($tooth_width), Length ($tooth_length), Thickness ($plate_thickness)
        // Orientation: Lying flat, hanging down in -Y
        cube([
            $tooth_width,
            $tooth_length,
            $plate_thickness
        ]);
    }
}