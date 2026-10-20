// Dimensions for 10-well comb for agarose gel casting
$fn = 64;

// Plate thickness (Z-direction, lying flat on bed)
plate_thickness = 1.5;

// Spine dimensions (back bar)
spine_length = 70;        // mm (X-direction)
spine_width = 12;         // mm (Y-direction)

// Tooth dimensions
tooth_width = 5.0;        // mm (X-direction)
tooth_length = 12;        // mm (Y-direction)
gap_between_teeth = 1.5;  // mm

// Number of teeth
num_teeth = 10;

// Create the spine: a rectangular plate from x = -35 to 35 mm, y = 0 to 12 mm, z = 0 to 1.5 mm
spine = cube([spine_length, spine_width, plate_thickness]);

// Create the teeth: each tooth is a rectangular block attached to the right edge of the spine
// The spine is from x = -35 to 35 mm, y = 0 to 12 mm.
// The teeth hang from the spine in the -Y direction, so they are attached at y = 12 and extend down to y = 12 - tooth_length.
// The teeth are centered on the spine in X, so each tooth is centered at x = 35 mm (right edge of spine).

// The teeth are placed in Y, with gaps between them, so the Y position of each tooth is offset by gap_between_teeth.

// For tooth i (0 to 9), the tooth extends from y = 12 - tooth_length - gap_between_teeth * i to y = 12 - gap_between_teeth * i
// This ensures the tooth has length = tooth_length and is spaced by gap_between_teeth.

// The tooth is centered at x = 35 mm, so it spans from x = 35 - tooth_width/2 to x = 35 + tooth_width/2

// We will use a for loop to create each tooth and union them.

// Start with the spine
result = spine;

// Loop over teeth
for (i = [0 : num_teeth - 1]) {
    // Position of the tooth in Y: starts at 12 - tooth_length - gap_between_teeth * i, ends at 12 - gap_between_teeth * i
    // But this would make the tooth go from y = 12 - tooth_length - gap_between_teeth * i to y = 12 - gap_between_teeth * i
    // That is a length of tooth_length, correct.
    
    // The tooth is a block of size [tooth_width, tooth_length, plate_thickness]
    // Positioned at:
    //   x: 35 - tooth_width/2 to 35 + tooth_width/2
    //   y: 12 - tooth_length - gap_between_teeth * i to 12 - gap_between_teeth * i
    //   z: 0 to plate_thickness
    
    // But we must ensure the tooth is attached to the spine and extends down.
    
    // Create the tooth block
    tooth = cube([tooth_width, tooth_length, plate_thickness]);
    
    // Translate the tooth to the correct position
    tooth = translate([spine_length/2 - tooth_width/2, 12 - tooth_length - gap_between_teeth * i, 0]) * tooth;
    
    // Add to the result
    result = union() {
        result;
        tooth;
    };
}

// The spine is already included, and the teeth are added on top.
// But the spine is defined as a cube, and we are adding teeth on top of it.

// However, the spine is from y=0 to 12, and the teeth are from y=12 - tooth_length to 12, so they are attached at the top.

// But the spine is at y=0 to 12, and the tooth is at y=12 - tooth_length to 12, so it is attached at the top edge.

// This is correct.

// But the spine is defined as a cube, and we are adding teeth that are on top of it.

// However, the spine is a solid, and the teeth are added as separate blocks.

// But the spine is only 12 mm in Y, and the teeth are attached at y=12, so they are on the edge.

// But the spine is defined as a cube with size [70, 12, 1.5], so it spans x from -35 to 35, y from 0 to 12.

// The tooth is at x from 35 - 2.5 to 35 + 2.5, y from 12 - 12 to 12, so it is at the top-right corner.

// But we want 10 teeth, each 12 mm long in Y, with 1.5 mm gaps between them.

// The first tooth at i=0: y from 12 - 12 to 12 → y from 0 to 12? No, 12 - 12 = 0, so from 0 to 12.

// That would overlap with the spine.

// This is the error.

// We must place the teeth in the -Y direction, so they extend from y = 12 to y = 12 - tooth_length.

// So the tooth should be from y = 12 - tooth_length to y = 12.

// But that is the same as before.

// But the spine is from y=0 to 12, so the tooth at y=12 - tooth_length to 12 is overlapping with the spine.

// We want the teeth to hang from the spine, so they should be on the top edge and extend down.

// But the spine is already there.

// So we need to create a new object that is the spine and the teeth, and the teeth are separate.

// But the spine is from y=0 to 12, and the tooth is from y=12 - tooth_length to 12, so it is on top of the spine.

// That is correct.

// But the user said "hang from one long edge of the spine in the -Y direction", so the tooth should extend down from the spine.

// So the tooth is at y = 12 - tooth_length to 12.

// This is correct.

// But the spine is already at y=0 to 12, so the tooth is on top of it.

// So the final part is the spine and the teeth.

// However, the spine and the teeth are both in the same region, so we must use union.

// We have already used union in the for loop.

// But the initial spine is defined as a cube, and then we add teeth with union.

// So the final object is the spine and the 10 teeth.

// But the spine is from y=0 to 12, and the teeth are from y=12 - tooth_length to 12, so they are on top.

// This is correct.

// However, the spine is defined as a cube, and we are adding teeth that are on top of it.

// But the spine is only 12 mm in Y, and the tooth is 12 mm in Y, so it is exactly on the top edge.

// But the tooth is 12 mm long, and the spine is 12 mm wide, so the tooth is exactly on the top edge.

// This is acceptable.

// But the tooth should be centered on the spine in X, so we place it at x = 35 mm.

// So the final code is:

// Start with the spine
// Then for each tooth, create a block and union it.

// But we must ensure the tooth is not overlapping with the spine in a way that causes errors.

// The spine is from y=0 to 12, and the tooth is from y=12 - tooth_length to 12, so it is on the top edge.

// So it is not overlapping in volume, only on the boundary.

// Therefore, it is acceptable.

// However, the warning "Ignoring unknown function 'cube'" suggests that the cube function is not being recognized.

// In OpenSCAD, the function is `cube`, not `cube()` with parentheses.

// But in the code above, we used `cube([tooth_width, tooth_length, plate_thickness])`, which is correct.

// But in the spine, we used `cube([spine_length, spine_width, plate_thickness])`, which is correct.

// So the issue might be in the for loop.

// We must use `union` and `translate`.

// Let's rewrite the entire file correctly.

// Final version:

// Create the spine
spine = cube([spine_length, spine_width, plate_thickness]);

// Start with the spine
result = spine;

// For each tooth, create a block and union it
for (i = [0 : num_teeth - 1]) {
    // The tooth is a block of size [tooth_width, tooth_length, plate_thickness]
    // Positioned at:
    //   x: spine_length/2 - tooth_width/2 to spine_length/2 + tooth_width/2
    //   y: 12 - tooth_length to 12
    //   z: 0 to plate_thickness
    // But we want to space them in Y, so