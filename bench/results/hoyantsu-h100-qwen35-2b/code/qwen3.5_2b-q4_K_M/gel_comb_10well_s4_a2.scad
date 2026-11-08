// Design a 10-well comb for casting agarose gels, printed lying flat.
// The whole comb is a flat plate 1.5 mm thick (Z) lying on the bed.
// Seen from above, it has a straight spine (back bar) 70 mm long (X) and 12 mm wide (Y), 
// and 10 rectangular teeth that hang from one long edge of the spine in the -Y direction.
// Each tooth is 5.0 mm wide (X) and 12 mm long (Y). The gaps between neighbouring teeth are 1.5 mm, 
// and the row of teeth is centred on the spine in X.

// Dimensions in millimetres
long_spine_X = 70.0; // Length along X
wide_spine_Y = 12.0; // Width along Y (height of comb)
thick_comb_Z = 1.5;  // Thickness along Z

tooth_width_X = 5.0;  // Width along X
tooth_length_Y = 12.0; // Length hanging down in -Y direction
gap_between_teeth = 1.5;
num_teils = 10;

// Total length of the comb spine (including gaps)
total_comb_X = long_spine_X + ((num_teils - 1) * gap_between_teeth);

// Centering offset to align teeth on the spine in X
center_offset_X = (long_spine_X / 2.0) - (tooth_width_X / 2.0);

// Total height of the comb (spine length + tooth lengths)
total_comb_Y = long_spine_Y + (num_teils * tooth_length_Y);

// Total width of the comb (width of spine + gaps between teeth)
total_comb_W = wide_spine_Y + ((num_teils - 1) * gap_between_teeth);

// Centering offset for Y axis to center the row on the spine
center_offset_Y = (wide_spine_Y / 2.0) - (tooth_length_Y / 2.0);

// Total height of the comb (thickness + tooth lengths)
total_comb_Z = thick_comb_Z + (num_teils * tooth_length_Y);

// Create a helper function to generate teeth using a for loop
create_teeth = function(
    long_spine_X, wide_spine_Y, tooth_width_X, tooth_length_Y, gap_between_teeth, num_teils) {

    var teeth_list; 

    for (i = 0; i < num_teils; i++) {
        // Calculate X position of the current tooth center relative to spine start
        var x_pos = (i * gap_between_teeth) + (tooth_width_X / 2.0);

        teeth_list += linear_extrude(
            length = tooth_length_Y,
            width = tooth_width_X,
            height = thick_comb_Z, 
            origin = translate(x_pos, wide_spine_Y/2.0 - tooth_length_Y/2.0, 0)
        );
    }

    return teeth_list;
};

// Create the main comb structure: spine + teeth
var comb_body;

comb_body = union(
    // The spine itself (a flat plate)
    linear_extrude(
        length = long_spine_Y,
        width = wide_spine_Y,
        height = thick_comb_Z, 
        origin = translate(center_offset_X, 0.0, 0)
    ),

    // Add the teeth hanging from the spine
    create_teeth(long_spine_X, wide_spine_Y, tooth_width_X, tooth_length_Y, gap_between_teeth, num_teils),

    // Ensure no gaps between the spine and the first tooth (they are joined at Y=0)
    var gap_fill;
    gap_fill = difference(
        linear_extrude(length=tooth_length_Y, width=tooth_width_X, height=thick_comb_Z, origin=translate(center_offset_X, wide_spine_Y/2.0 - tooth_length_Y/2.0, 0)), // First tooth
        linear_extrude(length=long_spine_Y, width=wide_spine_Y, height=thick_comb_Z, origin=translate(0,0,0)) // Spine
    );

    comb_body = union(linear_extrude(...), gap_fill);

// Final assembly: Center the whole thing on the XY plane at Z=0.
var final_part;
final_part = translate(center_offset_X, center_offset_Y, 0) - hull(comb_body); 

// Ensure we are printing from bottom to top (Z increasing upwards)
// The 'hull' operation centers the geometry around its centroid in X and Y, 
// but it does not change the Z coordinate of the bounding box.
// Since we defined the spine at Z=0 and teeth extend downwards into negative Z,
// the hull will shift the entire assembly upwards so that the center of mass is at 0,0.
// This effectively moves the bottom of the comb up by half its height.
// To print it correctly with the spine at Z=0, we must translate the final part down by half the total height.

var corrected_part;
corrected_part = translate(-total_comb_Z/2.0, 0.0, 0) - hull(comb_body); 

final_part = corrected_part;

print(final_part);