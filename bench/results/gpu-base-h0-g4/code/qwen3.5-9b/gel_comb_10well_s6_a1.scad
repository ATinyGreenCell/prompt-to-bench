// 10-well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane (Z=0).

// --- Dimensions ---
// Spine (Back Bar)
$spine_length = 70;   // mm (X)
$spine_width = 12;    // mm (Y)
$plate_thickness = 1.5; // mm (Z)

// Teeth
$num_teeth = 10;
$tooth_width = 5.0;   // mm (X)
$tooth_length = 12;   // mm (Y) // Matches spine width
$tooth_gap = 1.5;     // mm (X)

// --- Calculations ---
// Total width occupied by teeth
$total_teeth_width = $num_teeth * $tooth_width;
// Total width occupied by gaps
$total_gap_width = ($num_teeth - 1) * $tooth_gap;
// Total width of the tooth row
$tooth_row_width = $total_teeth_width + $total_gap_width;

// Centering offset in X to align the tooth row with the spine
// Spine center is at X=0. Tooth row center should also be at X=0.
// Offset = (Spine Width - Tooth Row Width) / 2
$x_offset = ($spine_width - $tooth_row_width) / 2;

// Y position of the teeth: they hang from the top edge of the spine (-Y direction)
// Spine top edge is at Y = $spine_width / 2
// Teeth extend downwards by $tooth_length
$y_start = $spine_width / 2;
$y_end = $y_start - $tooth_length;

// --- Model ---
$fn = 64;

// 1. Create the main spine (back bar)
// Dimensions: X=$spine_length, Y=$spine_width, Z=$plate_thickness
// Position: Centered at origin, resting on Z=0
spine = translate([0, 0, 0]) 
    cube([
        $spine_length, 
        $spine_width, 
        $plate_thickness
    ]);

// 2. Create the teeth
// We use a loop to generate each tooth.
// Tooth X position: Start at -x_offset, step by ($tooth_width + $tooth_gap)
// Tooth Y position: From $y_start to $y_end
// Tooth Z position: From 0 to $plate_thickness

teeth = union();
for (i = [0 : $num_teeth - 1]) {
    // Calculate X position for this tooth
    // i=0 is the leftmost tooth
    $x_pos = -x_offset + (i * ($tooth_width + $tooth_gap));
    
    // Define the tooth block
    tooth = translate([
        $x_pos, 
        $y_start, 
        0
    ]) 
    cube([
        $tooth_width, 
        $tooth_length, 
        $plate_thickness
    ]);
    
    teeth = union(teeth, tooth);
}

// 3. Combine Spine and Teeth
// The teeth are already positioned to hang from the spine.
// We unite them to create a single solid object.
final_comb = union(spine, teeth);

// 4. Output
final_comb;