// 10-well agarose gel comb - flat plate with spine and hanging teeth.
// Orientation: Lying flat on XY plane, spine along X, teeth hanging in -Y.

// Dimensions
spine_len = 70;
spine_w   = 12;
plate_thk = 1.5;

tooth_w   = 5.0;
tooth_l   = 12;
tooth_gap = 1.5;
num_teeth = 10;

$fn = 64;

// Calculate total width of the tooth row
tooth_row_w = (num_teeth * tooth_w) + ((num_teeth - 1) * tooth_gap);

// Position the tooth row so it is centred on the spine in X
// The spine is from -spine_len/2 to +spine_len/2.
// The tooth row starts at x_start and ends at x_start + tooth_row_w.
// We want the midpoint of the tooth row to align with the spine's midpoint (0).
x_start = -tooth_row_w / 2;

// Calculate the Y position of the teeth.
// The spine top edge is at y = spine_w / 2.
// The teeth hang down from this edge.
// Tooth top is at spine_w / 2. Tooth bottom is at spine_w / 2 - tooth_l.
y_top = spine_w / 2;
y_bot = y_top - tooth_l;

// Build the spine (back bar)
// It is a rectangle extruded to thickness.
// Centred at origin.
translate([0, -spine_w / 2, 0])
    cube([spine_len, spine_w, plate_thk]);

// Build the teeth
// We use a loop to create each tooth.
// The teeth are positioned along X.
// We use difference() to cut the teeth out of a larger block or union them?
// Actually, the prompt says "hang from one long edge".
// The spine is the main body. The teeth are additional material hanging down.
// So we can just union the spine with the teeth.

// However, to ensure clean geometry and avoid non-manifold issues if they touch,
// we can model the teeth as separate blocks and union them with the spine.
// Or, we can model the whole thing as one difference operation from a bounding box?
// No, union is safer for adding features.

// Let's create the teeth as a separate union and then union with the spine.
// Actually, since the teeth are attached to the spine, we can just union them all together.

// Define the tooth geometry
module tooth() {
    translate([0, y_top, 0])
        cube([tooth_w, tooth_l, plate_thk]);
}

// Generate the teeth positions
// We need to place them along X starting from x_start with spacing (tooth_w + tooth_gap).
// The loop variable i goes from 0 to num_teeth - 1.
// Position = x_start + i * (tooth_w + tooth_gap).

union() {
    // Spine
    translate([0, -spine_w / 2, 0])
        cube([spine_len, spine_w, plate_thk]);
    
    // Teeth
    for (i = [0 : num_teeth - 1]) {
        x_pos = x_start + i * (tooth_w + tooth_gap);
        translate([x_pos, 0, 0])
            tooth();
    }
}