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
$