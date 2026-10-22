// Dimensions for 10-well agarose gel comb
// Plate thickness (Z)
plate_thickness = 1.5;

// Spine dimensions
spine_length = 70;       // X direction
spine_width = 12;        // Y direction

// Tooth dimensions
tooth_width = 5.0;      // X direction
tooth_length = 12;      // Y direction (hanging in -Y)

// Gap between teeth
gap_width = 1.5;        // X direction

// Number of teeth
num_teeth = 10;

// Calculate total width of teeth and gaps
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * gap_width;
total_tooth_row_width = total_tooth_width + total_gap_width;

// Define the spine base
// Centered at origin, Z from 0 to plate_thickness
spine_base = translate([0, 0, 0]) {
    cube([spine_length, spine_width, plate_thickness], center = true);
}

// Define the teeth
// We create a single block for all teeth and then subtract the gaps.
// The teeth block will be positioned such that its top edge aligns with the spine's bottom edge.
// Spine Y range: -spine_width/2 to +spine_width/2
// Teeth Y range: -spine_width/2 - tooth_length to -spine_width/2
// Teeth X range: -total_tooth_row_width/2 to +total_tooth_row_width/2

// Create the full block for the teeth row (including gaps)
// Position: Center X=0, Center Y = -spine_width/2 - tooth_length/2
teeth_block = translate([0, -spine_width/2 - tooth_length/2, 0]) {
    cube([total_tooth_row_width, tooth_length, plate_thickness], center = true);
}

// Subtract the gaps
// There are (num_teeth - 1) gaps.
// We iterate through each gap and subtract a cube slightly larger than the gap to ensure clean cuts.
teeth_with_gaps = teeth_block;

for (i = [1 : num_teeth - 1]) {
    // Calculate center of gap i
    // Gap i is between tooth i and tooth i+1.
    // Center of gap i = -total_tooth_row_width/2 + i * (tooth_width + gap_width) - gap_width/2
    gap_center_x = -total_tooth_row_width/2 + i * (tooth_width + gap_width) - gap_width/2;
    
    // Create gap cutout
    // Extend slightly past the faces (0.02mm) to avoid coplanar issues
    gap_cut = translate([gap_center_x, 0, 0]) {
        cube([gap_width + 0.02, tooth_length, plate_thickness], center = true);
    };
    
    teeth_with_gaps = difference() {
        teeth_with_gaps;
        gap_cut;
    };
}

// Union the spine and the teeth block
// The teeth block is already positioned correctly relative to the spine.
// Spine Y max: -spine_width/2
// Teeth Y min: -spine_width/2 - tooth_length
// Teeth Y max: -spine_width/2
// They touch at Y = -spine_width/2.
final_comb = union() {
    spine_base;
    teeth_with_gaps;
};

// Render the final comb
// The comb rests on the XY plane (Z=0) and builds upward.
// The spine is centered at X=0, Y=0.
// The teeth hang in the -Y direction.
// The entire object is centered at X=0, Y=0, Z=0 (bottom face).
// Wait, the spine is centered at Y=0. The teeth hang from Y=-spine_width/2.
// So the center of the whole object is not at Y=0.
// The user said: "centred on the spine in X".
// The spine is centered at X=0.
// The teeth are centered on the spine in X.
// The spine is centered at Y=0.
// The teeth are attached to the spine at Y=-spine_width/2.
// So the whole comb is centered at X=0.
// The Y position of the whole comb is from -spine_width/2 - tooth_length to +spine_width/2.
// The center of the whole comb in Y is (-spine_width/2 - tooth_length + spine_width/2) / 2 = -tooth_length/2.
// But the user said "centred on the spine in X".
// So we just need to ensure X is centered.
// The code above does that.
// The spine is centered at X=0.
// The teeth are centered at X=0.
// So the whole comb is centered at X=0.
// The Y position is as described.

// Final output
translate([0, 0, 0]) {
    final_comb;
}