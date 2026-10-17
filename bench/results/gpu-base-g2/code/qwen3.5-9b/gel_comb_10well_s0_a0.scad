// 10-well Agarose Gel Casting Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).

// --- Dimensions ---
// Spine dimensions
$spine_length = 70;   // mm (X)
$spine_width = 12;    // mm (Y)
$plate_thickness = 1.5; // mm (Z)

// Tooth dimensions
$num_teeth = 10;
$tooth_width = 5.0;   // mm (X)
$tooth_length = 12;   // mm (Y) // Length hanging from spine
$tooth_gap = 1.5;     // mm (X)

// --- Calculations ---
// Total width of the tooth row
$total_tooth_width = $num_teeth * $tooth_width;
// Total width of the gaps
$total_gap_width = ($num_teeth - 1) * $tooth_gap;
// Total width of the tooth assembly
$total_assembly_width = $total_tooth_width + $total_gap_width;

// Offset to center the tooth assembly on the spine in X
$x_offset = ($spine_length - $total_assembly_width) / 2;

// Position of the first tooth relative to the spine edge
// The teeth hang in the -Y direction from the spine.
// We assume the spine edge is at Y = $spine_width / 2.
// The teeth start at Y = $spine_width / 2 and extend to Y = $spine_width / 2 - $tooth_length.
// However, the prompt says "hang from one long edge... in the -Y direction".
// Let's place the spine from Y = -$spine_width/2 to Y = $spine_width/2.
// The teeth will hang from Y = $spine_width/2 down to Y = $spine_width/2 - $tooth_length.

// --- Main Body ---
difference() {
    // 1. Create the main spine block
    // Dimensions: X = $spine_length, Y = $spine_width, Z = $plate_thickness
    translate([0, 0, 0])
    cube([
        $spine_length, 
        $spine_width, 
        $plate_thickness
    ]);

    // 2. Cut out the teeth
    // We iterate through each tooth position
    for (i = [0 : $num_teeth - 1]) {
        // Calculate X position for this tooth
        // Start at x_offset, add (tooth_width + gap) * i
        current_x = x_offset + ($tooth_width + $tooth_gap) * i;
        
        // Calculate Y position for this tooth
        // The tooth hangs from the top edge (Y = $spine_width/2)
        // The tooth extends downwards (-Y) by $tooth_length
        // The cutting shape needs to cover the tooth area + a small overhang
        // Tooth Y range: [$spine_width/2 - $tooth_length, $spine_width/2]
        
        // Define the cutting volume
        // X range: [current_x, current_x + $tooth_width]
        // Y range: [$spine_width/2 - $tooth_length, $spine_width/2]
        // Z range: [0, $plate_thickness + 0.1] (slightly past the top face to ensure clean cut)
        
        translate([
            current_x, 
            $spine_width/2 - $tooth_length, 
            0
        ])
        cube([
            $tooth_width, 
            $tooth_length, 
            $plate_thickness + 0.1
        ]);
    }
}