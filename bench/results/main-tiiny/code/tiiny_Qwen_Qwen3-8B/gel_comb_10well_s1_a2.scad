// Dimensions for the 10-well comb
spine_length = 70;       // Length of the spine in X direction
spine_width = 12;        // Width of the spine in Y direction
comb_thickness = 1.5;    // Thickness of the comb in Z direction
tooth_width = 5.0;       // Width of each tooth in X direction
tooth_length = 12;       // Length of each tooth in Y direction
tooth_gap = 1.5;         // Gap between neighboring teeth in Y direction
num_teeth = 10;           // Number of teeth

// Calculate total width of the comb including teeth and gaps
total_comb_width = (tooth_width + tooth_gap) * num_teeth - tooth_gap;

// Create the spine
spine = cube([spine_length, spine_width, comb_thickness], center=false);

// Create the teeth using a for loop
teeth = [];
for (i = [0:num_teeth-1]) {
    x_offset = i * (tooth_width + tooth_gap);
    tooth = cube([tooth_width, tooth_length, comb_thickness], center=false);
    tooth = translate([x_offset, -spine_width/2 + 0.5, 0]) * tooth;
    teeth += tooth;
}

// Combine spine and teeth
comb = union() {
    spine;
    for (i = [0:num_teeth-1]) {
        x_offset = i * (tooth_width + tooth_gap);
        // Add a small offset to the tooth to avoid coplanar faces
        tooth = cube([tooth_width, tooth_length, comb_thickness + 0.01], center=false);
        tooth = translate([x_offset, -spine_width/2 + 0.5, 0]) * tooth;
        // Add the tooth to the union
        comb = comb + tooth;
    }
}

// Final comb with teeth
final_comb = difference() {
    comb;
    for (i = [0:num_teeth-1]) {
        x_offset = i * (tooth_width + tooth_gap);
        // Create a cutting shape that extends slightly beyond the tooth
        cut_shape = cube([tooth_width + 0.1, tooth_length + 0.1, comb_thickness + 0.01], center=false);
        cut_shape = translate([x_offset, -spine_width/2 + 0.5, 0]) * cut_shape;
        // Ensure the cut shape is slightly offset to avoid coplanar faces
        cut_shape = translate([0, 0, -0.005]) * cut_shape;
        // Subtract the cut shape from the comb
        final_comb = final_comb - cut_shape;
    }
}

// Render the final comb
final_comb;