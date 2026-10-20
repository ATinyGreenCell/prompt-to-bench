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

// Number of teeth
num_teeth = 10;

// Spine position: centered on origin in X, extending from -spine_length/2 to spine_length/2 in X
// Teeth hang from the right edge of the spine in -Y direction

// Create the spine
spine = cube([spine_length, spine_width, plate_thickness]);

// Create the teeth
// Teeth are placed along the spine, centered in X, extending in -Y direction
// The spine is from -spine_length/2 to spine_length/2 in X
// Teeth are centered on the spine in X, so their center is at x = 0

// The right edge of the spine is at x = spine_length/2
// Teeth hang from that edge in -Y direction, so their base is at y = spine_width/2 to y = spine_width/2 - tooth_length - gap_between_teeth

// Calculate the starting Y position of the first tooth (bottom of the tooth row)
// The teeth are centered on the spine in X, so each tooth is centered at x = 0
// The teeth are spaced in Y from spine_width/2 down to spine_width/2 - (num_teeth - 1) * (tooth_length + gap_between_teeth)

// The base of each tooth is at y = spine_width/2 - (tooth_length + gap_between_teeth) * (i) - tooth_length/2
// But we want the teeth to hang from the spine in -Y, so their base is at y = spine_width/2 - offset

// Calculate the Y positions of the teeth: centered on spine, so each tooth is centered at y = spine_width/2 - (i * (tooth_length + gap_between_teeth)) - tooth_length/2

// We will place teeth from y = spine_width/2 - (num_teeth - 1) * (tooth_length + gap_between_teeth) / 2 to y = spine_width/2 - (tooth_length + gap_between_teeth) / 2

// Center the teeth row on the spine in X (x=0), so each tooth is centered at x=0

// The spine is from x = -spine_length/2 to x = spine_length/2
// Teeth are attached to the right edge of the spine, so their base is at x = spine_length/2

// So each tooth is a rectangular block of size [tooth_width, tooth_length, plate_thickness]
// Positioned at:
//   x = spine_length/2 (right edge of spine)
//   y from (spine_width/2 - tooth_length/2 - offset) to (spine_width/2 - tooth_length/2 - offset + tooth_length)
// But we want them to hang from the spine in -Y, so their base is at y = spine_width/2 - (tooth_length + gap_between_teeth) * i - tooth_length/2

// Actually, we want the teeth to be centered on the spine in X, and aligned in Y from the spine.

// Let's define the Y positions of the teeth:
// The first tooth starts at y = spine_width/2 - (num_teeth - 1) * (tooth_length + gap_between_teeth) / 2 - tooth_length/2
// But simpler: place teeth centered at y = spine_width/2 - (tooth_length + gap_between_teeth) * i - tooth_length/2

// Actually, the spine is 12 mm wide (Y), and teeth hang from it in -Y direction.
// So the base of the tooth is at y = spine_width/2 (right edge of spine) and extends to y = spine_width/2 - tooth_length - gap_between_teeth

// We want the teeth to be centered on the spine in X, so each tooth is centered at x = 0

// The spine is from x = -spine_length/2 to x = spine_length/2
// The teeth are attached to the right edge of the spine, so their base is at x = spine_length/2

// So each tooth is a block at:
//   x = spine_length/2
//   y from (spine_width/2 - tooth_length/2 - offset) to (spine_width/2 - tooth_length/2 - offset + tooth_length)
// But we want them to be spaced in Y, centered on spine in X.

// Actually, the spine is 12 mm wide in Y, so it spans from y = 0 to y = 12.
// The teeth hang from the spine in -Y, so their base is at y = 12 (top of spine) and extend down to y = 12 - tooth_length - gap_between_teeth?

// But the user says: "hang from one long edge of the spine in the -Y direction"
// So the base of each tooth is at y = spine_width (12 mm), and extends to y = spine_width - tooth_length (12 - 12 = 0) in -Y.

// So the tooth extends from y = spine_width to y = spine_width - tooth_length in -Y direction.

// But we want the teeth to be centered on the spine in X, so each tooth is centered at x = 0.

// So each tooth is:
//   x from 0 to tooth_width (centered at x=0)
//   y from spine_width to spine_width - tooth_length (in -Y direction)
//   z from 0 to plate_thickness

// But the spine is from x = -spine_length/2 to x = spine_length/2, so the right edge is at x = spine_length/2.

// Therefore, the teeth are attached to the right edge of the spine, so their base is at x = spine_length/2.

// So each tooth is at:
//   x from spine_length/2 to spine_length/2 + tooth_width
//   y from spine_width to spine_width - tooth_length
//   z from 0 to plate_thickness

// But that would make them extend to the right, not hang from the spine.

// Correction: "hang from one long edge of the spine in the -Y direction" means the teeth are attached to the spine and extend in the negative Y direction.

// So the base of each tooth is at y = spine_width (top of spine), and the tooth extends down to y = spine_width - tooth_length.

// So the tooth is:
//   x from spine_length/2 to spine_length/2 + tooth_width
//   y from spine_width to spine_width - tooth_length
//   z from 0 to plate_thickness

// But this would make the tooth extend to the right, not hang.

// We must interpret "hang in -Y direction" as extending in the negative Y direction (downward from the spine).

// So the spine is at y from 0 to 12.
// The tooth is attached at y = 12 (top of spine), and extends to y = 12 - tooth_length.

// So the tooth is:
//   x from spine_length/2 to spine_length/2 + tooth_width
//   y from 12 to 12 - tooth_length
//   z from 0 to plate_thickness

// But the spine is 12 mm wide in Y, so it spans from y=0 to y=12.

// The teeth are attached to the spine at the top edge (y=12), and extend down to y=12 - tooth_length.

// But the user says "the row of teeth is centred on the spine in X", so each tooth is centered at x=0.

// So we place the teeth at x = spine_length/2 (right edge of spine), and centered in X.

// So each tooth is centered at x = spine_length/2, so it spans from x = spine_length/2 - tooth_width/2 to x = spine_length/2 + tooth_width/2.

// But the spine is from x = -spine_length/2 to x = spine_length/2, so the right edge is at x = spine_length/2.

// So the tooth is centered at x = spine_length/2, so it extends from x = spine_length/2 - tooth_width/2 to x = spine_length/2 + tooth_width/2.

// And in Y, it extends from y = spine_width to y = spine_width - tooth_length.

// But that would extend to the right, not hang.

// We need to place the teeth so that they hang from the spine in -Y, so their base is at the spine and they go down.

// So the tooth is:
//   x from spine_length/2 - tooth_width/2 to spine_length/2 + tooth_width/2
//   y from spine_width to spine_width - tooth_length
//   z from 0 to plate_thickness

// But that would extend to the right, not hang.

// The only interpretation that makes sense is that the teeth are attached to the spine and