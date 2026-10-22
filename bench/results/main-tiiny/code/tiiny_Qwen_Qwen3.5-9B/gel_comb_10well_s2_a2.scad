$fn = 128;

// --- Dimensions ---
// Plate thickness (Z)
$plate_thickness = 1.5;

// Spine dimensions (X, Y)
$spine_length = 70;
$spine_width = 12;

// Tooth dimensions (X, Y)
$tooth_width = 5.0;
$tooth_length = 12;

// Gap between teeth
$gap_size = 1.5;

// Number of wells
$num_wells = 10;

// --- Calculations ---
// Total width of the tooth row (teeth + gaps)
$total_row_width = ($num_wells * $tooth_width) + (($num_wells - 1) * $gap_size);

// --- Build ---

// 1. Create the Spine
// Dimensions: X = $spine_length, Y = $spine_width, Z = $plate_thickness
// Centered at origin.
spine = cube([$spine_length, $spine_width, $plate_thickness]);

// 2. Create the Teeth Block
// The teeth hang from the spine in the -Y direction.
// The spine top edge is at Y = $spine_width / 2.
// The teeth extend from Y = $spine_width / 2 to Y = $spine_width / 2 - $tooth_length.

// We construct the teeth by taking a solid block and subtracting the gaps.

// Step 2a: Create the solid block of teeth (before cutting gaps)
// Dimensions: X = $total_row_width, Y = $tooth_length, Z = $plate_thickness
// Position: Centered at X=0. 
// Y position: The block hangs from the spine edge ($spine_width/2).
// So the block's Y range is [$spine_width/2 - $tooth_length, $spine_width/2].
// Center Y = $spine_width/2 - $tooth_length/2.
// Z position: Centered at $plate_thickness/2.

teeth_solid = translate([
    0, 
    $spine_width/2 - $tooth_length/2, 
    $plate_thickness/2
], 
cube([$total_row_width, $tooth_length, $plate_thickness]));

// Step 2b: Create the gaps to subtract
// There are $num_wells - 1 gaps.
// Each gap is $gap_size wide in X, full tooth length in Y, full thickness in Z.
// The gaps are centered between the teeth.
// The centers of the gaps are located at:
// x_center = -($total_row_width / 2) + (i + 1) * ($tooth_width + $gap_size / 2)
// for i from 0 to $num_wells - 2.

gaps_list = [];
for (i = [0 : $num_wells - 2]) {
    $gap_x_center = -($total_row_width / 2) + (i + 1) * ($tooth_width + $gap_size / 2);
    
    $gap = translate([
        $gap_x_center, 
        $spine_width/2 - $tooth_length/2, 
        $plate_thickness/2
    ], 
    cube([$gap_size, $tooth_length, $plate_thickness]));
    
    gaps_list = concat(gaps_list, [$gap]);
}

// Step 2c: Subtract gaps from the solid block
teeth = difference([
    teeth_solid,
    gaps_list
]);

// 3. Combine Spine and Teeth
// Union the spine and the teeth block.
comb = union(spine, teeth);

// 4. Final Output
// The part is already oriented correctly: lying flat on XY, building up in Z.
// It is centered at X=0, Y=0.
comb;