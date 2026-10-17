// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).

// --- Dimensions ---
// Spine dimensions
$spine_length = 70;   // mm (X)
$spine_width = 12;    // mm (Y)
$plate_thickness = 1.5; // mm (Z)

// Tooth dimensions
$num_teeth = 10;
$tooth_width = 5.0;   // mm (X)
$tooth_length = 12;   // mm (Y) (extends from spine edge)
$tooth_gap = 1.5;     // mm (X) between teeth

// --- Calculations ---
// Total width of the tooth row
$total_tooth_width = ($tooth_width * $num_teeth) + (($tooth_gap * ($num_teeth - 1)));

// Offset to center the tooth row on the spine width
// Spine is 12mm wide. Tooth row is centered.
// The teeth hang in -Y direction.
// We need to position the row so it is centered relative to the spine width.
// Let's define the row's local Y range first.
// The row has total width $total_tooth_width.
// The spine has width $spine_width.
// Center offset = ($spine_width - $total_tooth_width) / 2.
$center_offset_y = ($spine_width - $total_tooth_width) / 2;

// Calculate the start position of the first tooth in the +X direction
// The row is centered in X.
// Total X span of the row = $total_tooth_width.
// Half span = $total_tooth_width / 2.
$first_tooth_x = -($total_tooth_width / 2) + ($tooth_width / 2);

// --- Main Body ---
// Create the flat plate (spine + base)
// Dimensions: X=$spine_length, Y=$spine_width, Z=$plate_thickness
// Position: Centered at origin, resting on Z=0.
// So Z goes from 0 to $plate_thickness.
// X goes from -$spine_length/2 to +$spine_length/2.
// Y goes from -$spine_width/2 to +$spine_width/2.

difference() {
    // 1. The solid block
    translate([0, 0, 0])
    cube([
        $spine_length,
        $spine_width,
        $plate_thickness
    ]);

    // 2. Cut out the teeth
    // We iterate through each tooth and subtract it.
    // Tooth geometry:
    // X: from $first_tooth_x + (i * ($tooth_width + $tooth_gap)) to ...
    // Y: from -$spine_width/2 - $tooth_length to -$spine_width/2 (hanging down)
    // Z: from 0 to $plate_thickness
    
    for (i = [0 : $num_teeth - 1]) {
        // Calculate X position for this tooth
        $tooth_x = $first_tooth_x + (i * ($tooth_width + $tooth_gap));
        
        // Calculate Y position for this tooth
        // The tooth hangs from the edge at Y = -$spine_width/2
        // It extends $tooth_length in the -Y direction.
        $tooth_y_start = -($spine_width / 2) - $tooth_length;
        $tooth_y_end = -($spine_width / 2);
        
        // Define the cutting volume
        // Extend slightly in Z to ensure clean cut (Rule 5)
        $cut_height = $plate_thickness + 0.1;
        
        translate([
            $tooth_x,
            $tooth_y_start,
            0
        ])
        cube([
            $tooth_width,
            $tooth_length,
            $cut_height
        ]);
    }
}