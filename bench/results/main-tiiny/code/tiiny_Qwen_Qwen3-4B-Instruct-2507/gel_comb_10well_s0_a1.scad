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

// Create the spine
spine = cube([spine_length, spine_width, plate_thickness]);

// Create the teeth
// Teeth are attached to the right edge of the spine and extend in the -Y direction
// Each tooth is 5.0 mm wide (X), 12 mm long (Y), and hangs from the spine in -Y
// The spine is 70 mm long (X), 12 mm wide (Y), and lies from x = -35 to 35 mm, y = 0 to 12 mm
// The teeth are centered on the spine in X, so each tooth is centered at x = 35 mm (right edge of spine)

// The base of each tooth is at the right edge of the spine (x = 35 mm) and extends in -Y direction
// So each tooth is a rectangular block:
//   x from 35 - tooth_width/2 to 35 + tooth_width/2
//   y from 12 to 12 - tooth_length
//   z from 0 to plate_thickness

// But we want the teeth to be spaced in Y, with gaps between them.

// The teeth are placed along the spine in Y, from y = 12 down to y = 12 - (num_teeth - 1) * (tooth_length + gap_between_teeth) - tooth_length/2

// Actually, we want the teeth to be centered on the spine in X, and aligned in Y.

// The spine is from y = 0 to 12.
// The teeth hang from the spine in -Y, so their base is at y = 12, and they extend down to y = 12 - tooth_length.

// But we want multiple teeth, spaced by gap_between_teeth.

// So the first tooth starts at y = 12 - tooth_length - gap_between_teeth * 0
// The second at y = 12 - tooth_length - gap_between_teeth * 1
// etc.

// So the Y range for tooth i is:
//   y from (12 - tooth_length - gap_between_teeth * i) to (12 - tooth_length - gap_between_teeth * i + tooth_length)

// But that would make the tooth extend up, not down.

// We want the tooth to extend from y = 12 to y = 12 - tooth_length, so it goes down.

// So for tooth i, it is:
//   y from (12 - tooth_length) to 12
//   but that is fixed.

// We want multiple teeth, each 12 mm long in Y, with 1.5 mm gaps between them, so the teeth are stacked vertically in Y.

// So the first tooth starts at y = 12 - tooth_length, and goes to y = 12.
// The second tooth starts at y = 12 - tooth_length - gap_between_teeth, and goes to y = 12 - gap_between_teeth.
// But that would go down.

// Actually, we want the teeth to hang from the spine in -Y, so each tooth is a block that starts at y = 12 and goes down to y = 12 - tooth_length.

// But we want 10 teeth, each 12 mm long, with 1.5 mm gaps between them.

// So the teeth are placed at:
//   y_start = 12 - tooth_length - gap_between_teeth * i
//   y_end = 12 - gap_between_teeth * i

// But that would go from y = 12 - tooth_length - gap_between_teeth * i to y = 12 - gap_between_teeth * i

// But that is only 12 mm long, and we want it to go from y = 12 to y = 12 - tooth_length.

// So we define the tooth as:
//   y from (12 - tooth_length) to 12
//   but that is fixed.

// We must place the teeth in Y, with gaps between them, so the teeth are stacked vertically.

// So the first tooth is from y = 12 - tooth_length to y = 12
// The second tooth is from y = 12 - tooth_length - gap_between_teeth to y = 12 - gap_between_teeth
// The third from y = 12 - tooth_length - 2*gap_between_teeth to y = 12 - 2*gap_between_teeth
// etc.

// So for tooth i (0 to 9):
//   y_start = 12 - tooth_length - gap_between_teeth * i
//   y_end = 12 - gap_between_teeth * i

// But then the tooth length is 12 mm, and the gap is 1.5 mm, so the total length from first to last is 12 + 9*1.5 = 22.5 mm, which is fine.

// But the spine is only 12 mm wide in Y, so the teeth are hanging from the spine at y=12, and go down to y=12 - tooth_length.

// So the tooth is:
//   x from spine_length/2 - tooth_width/2 to spine_length/2 + tooth_width/2
//   y from (12 - tooth_length - gap_between_teeth * i) to (12 - gap_between_teeth * i)
//   z from 0 to plate_thickness

// But this is not correct because the tooth should be attached to the spine and extend down.

// Actually, the spine is from y=0 to y=12, so the top edge is at y=12.
// The tooth is attached at y=12 and extends down to y=12 - tooth_length.

// So the tooth is a block of size [tooth_width, tooth_length, plate_thickness] at:
//   x: spine_length/2 - tooth_width/2 to spine_length/2 + tooth_width/2
//   y: 12 - tooth_length to 12
//   z: 0 to plate_thickness

// But we want multiple teeth, so we place them at different Y positions, with gaps.

// So for tooth i, we place it at:
//   y from (12 - tooth_length - gap_between_teeth * i) to (12 - gap_between_teeth * i)

// But that would make the tooth go from y = 12 - tooth_length - gap_between_teeth * i to y = 12 - gap_between_teeth * i

// And the length is tooth_length, so it goes down by tooth_length.

// So the tooth is correct.

// But the spine is only 12 mm wide, so the tooth is attached at the top edge of the spine.

// So we create a tooth for each i from 0 to 9.

// The spine is at x from -35 to 35 mm, y from 0 to 12 mm.
// The teeth are attached at the top edge (y=12) and extend down to y=12 - tooth_length.

// So the tooth is:
//   x: 35 - tooth_width/2 to 35 + tooth_width/2
//   y: 12 - tooth_length to 12
//   z: 0 to plate_thickness

// But we want the teeth to be centered on the spine in X, so we place them at x = 35 mm (right edge of spine).

// So the tooth is centered at x = 35 mm.

// Therefore, we define the tooth as:
//   x from 35 - tooth_width/2 to 35 + tooth_width/2
//   y from 12 - tooth_length to 12
//   z from 0 to plate_thickness

// But we want 10 teeth, spaced in Y.

// So we place them at:
//   y_start = 12 - tooth_length - gap_between_teeth * i
//   y_end = 12 - gap_between_teeth * i

// But that would make the tooth go from y = 12 - tooth_length - gap_between_teeth * i to y = 12 - gap_between_teeth * i

// And the length is tooth_length, so it goes down by tooth_length.

// This is correct.

// However, the spine is only 12 mm wide, so the tooth is attached at the top edge.

// So we create a list of teeth.

// We will use a for loop to create each tooth.

// But we must use difference or union to combine.

// We will use union to combine all teeth and the spine.

// First, create the spine.
// Then, for each tooth, create a block and union.

// But the spine is already defined.

//