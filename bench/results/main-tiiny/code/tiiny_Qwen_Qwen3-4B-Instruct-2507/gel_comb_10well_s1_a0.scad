// Dimensions for 10-well comb for agarose gel casting
$fn = 64;

// Plate thickness (Z-direction, lying flat on bed)
plate_thickness = 1.5;

// Spine dimensions (back bar)
spine_length = 70;        // mm (X-direction)
spine_width = 12;         // mm (Y-direction)

// Tooth dimensions
tooth_width = 5.0;        // mm (X-direction)
tooth_length = 12;       // mm (Y-direction)
gap_between_teeth = 1.5; // mm

// Number of wells (teeth)
num_teeth = 10;

// Spine is centered at origin in X, extends from -spine_length/2 to +spine_length/2 in X
// Teeth hang from the +Y edge of the spine in the -Y direction

// Create the spine
spine = cube([spine_length, spine_width, plate_thickness]);

// Create the 10 teeth
// Teeth are positioned along the spine, centered in X, extending in -Y direction
// The spine is centered at origin, so teeth are centered at x = 0, and spaced in -Y

// Calculate the position of the first tooth (centered on spine)
// The teeth are spaced with 1.5 mm gaps between them, and each tooth is 12 mm long in Y
// The total length occupied by teeth (including gaps) is: (num_teeth * tooth_length) + (num_teeth - 1) * gap_between_teeth
// But we place them from Y = 0 to Y = -tooth_length, with gaps between them

// The teeth are centered on the spine in X, so each tooth is centered at x = 0
// The teeth extend from Y = 0 to Y = -tooth_length, and are spaced with gaps between them

// Calculate the starting Y position of the first tooth (centered at Y = 0)
// The first tooth starts at Y = -tooth_length - gap_between_teeth * (num_teeth - 1) / 2
// Actually, we want the teeth to be centered on the spine in X, and aligned in -Y direction

// Center the teeth row in Y: the first tooth starts at Y = -tooth_length - (num_teeth - 1) * (gap_between_teeth + tooth_length) / 2
// But simpler: place teeth symmetrically in -Y direction, centered at Y = 0

// Total length from first to last tooth in Y: (num_teeth - 1) * (gap_between_teeth + tooth_length) + tooth_length
// The teeth are centered at Y = 0, so the first tooth starts at Y = -total_length/2

// Total length of tooth row in Y direction:
total_tooth_length = num_teeth * tooth_length + (num_teeth - 1) * gap_between_teeth;
centered_start_y = -total_tooth_length / 2;

// Create each tooth as a rectangular block extending in -Y direction
for (i = [0 : num_teeth - 1]) {
    // Position of tooth i: centered at x=0, y = centered_start_y + i * (tooth_length + gap_between_teeth)
    // The tooth extends from y = y_start to y = y_start + tooth_length
    y_offset = centered_start_y + i * (tooth_length + gap_between_teeth);
    tooth = cube([tooth_width, tooth_length, plate_thickness]);
    // Translate tooth to correct position
    tooth = translate([0, y_offset, 0]) * tooth;
    // Add tooth to the union
    union() {
        spine;
        tooth;
    }
}

// Now, we want to build the full part as a union of spine and teeth
// But the spine already includes the base, and teeth are hanging from it
// However, the spine and teeth are both at the same X=0, and teeth extend in -Y

// Actually, we need to create the spine and then subtract the teeth from the spine?
// No — we want the spine and teeth to be joined.

// Instead, we build the spine and then add the teeth as separate parts, all centered.

// Correct approach: create the spine and then add each tooth as a separate block
// But the spine is already defined as a cube, and teeth are hanging from it.

// We will create the spine and then union with each tooth, properly positioned.

// Reset: build the spine and then add each tooth

// Start with the spine
module comb() {
    // Spine
    translate([0, 0, 0]) {
        cube([spine_length, spine_width, plate_thickness]);
    }
    
    // Add each tooth
    for (i = [0 : num_teeth - 1]) {
        y_offset = centered_start_y + i * (tooth_length + gap_between_teeth);
        translate([0, y_offset, 0]) {
            cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}

// But the above will create overlapping or incorrect geometry.
// Actually, we need to define the entire part as a single union.

// Final design: the spine is a flat plate, and 10 teeth extend from it in -Y direction.
// Each tooth is 5.0 mm wide (X), 12 mm long (Y), and the gaps between teeth are 1.5 mm.

// The spine is 70 mm long (X), 12 mm wide (Y), 1.5 mm thick.
// The teeth are centered on the spine in X, and extend in -Y direction.

// The first tooth starts at Y = -total_tooth_length/2, and each tooth is spaced by (tooth_length + gap_between_teeth)

// Recompute the Y positions:
// Total length from first to last tooth: (num_teeth - 1) * (tooth_length + gap_between_teeth) + tooth_length
// So the first tooth starts at Y = -total_length/2

total_length_y = (num_teeth - 1) * (tooth_length + gap_between_teeth) + tooth_length;
start_y = -total_length_y / 2;

// Now create the spine and teeth in a single union
union() {
    // Spine
    translate([0, 0, 0]) {
        cube([spine_length, spine_width, plate_thickness]);
    }
    
    // Teeth: each tooth is a 5x12 mm block, extending from y = start_y + i*(tooth_length+gap) to y = start_y + i*(tooth_length+gap) + tooth_length
    for (i = [0 : num_teeth - 1]) {
        y_offset = start_y + i * (tooth_length + gap_between_teeth);
        translate([0, y_offset, 0]) {
            cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}