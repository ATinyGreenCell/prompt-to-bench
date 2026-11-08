// Design a 10-well comb for casting agarose gels, printed lying flat.
// The whole comb is a flat plate 1.5 mm thick (Z) lying on the bed.
// Seen from above, it has a straight spine (back bar) 70 mm long (X) and 12 mm wide (Y), 
// and 10 rectangular teeth that hang from one long edge of the spine in the -Y direction.
// Each tooth is 5.0 mm wide (X) and 12 mm long (Y). The gaps between neighbouring teeth are 1.5 mm, 
// and the row of teeth is centred on the spine in X.

// Dimensions in millimetres
length_spine = 70;   // Length along X axis
width_teeth = 12;    // Width of each tooth along Y axis (negative direction)
height_comb = 1.5;   // Thickness of the comb along Z axis
gap_between_tooth = 1.5; // Gap between teeth in Y direction

// Number of teeth
num_tooth = 10;

// Tooth width and length
tooth_width = 5.0;
tooth_length = 12.0;

// Spine dimensions (width along X)
spine_width = 12.0; // Matches tooth width to ensure alignment

// Create the comb structure
comb = linear_extrude(
    height_comb, 
    length_spine, 
    spine_width, 
    -tooth_length, // Teeth hang in negative Y direction
    num_tooth, 
    gap_between_tooth
);

// Add a small fillet at the junction of the spine and teeth to prevent stress concentration
fillet = rotate(90, 1.5);
comb_union = union(comb, fillet);

// Print orientation: lying flat on XY plane (Z=0), building up in +Z
print_comb = hull(comb_union);

// Set number of slices for smooth curved surfaces if needed, though this is a simple extrusion
fn = 64; // Ensure holes come out round and to size

// Optional: Add a label or text indicating the part name
text_label = translate(0, 0.5, -1) "Agarose Gel Casting Comb";
print_comb_with_text = union(print_comb, rotate_extrude(90, 2, text_label)); // Rotate to lay flat on XY plane for viewing

// Final output
print(print_comb_with_text);