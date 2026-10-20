// Dimensions
spine_x = 70;        // Length of the spine (X)
spine_y = 12;        // Width of the spine (Y)
spine_z = 1.5;       // Thickness of the comb (Z)
tooth_x = 5.0;       // Width of each tooth (X)
tooth_y = 12.0;      // Length of each tooth (Y)
gap_x = 1.5;         // Gap between neighbouring teeth (X)
num_teeth = 10;      // Number of teeth

// Calculated positioning to ensure the object is centered on the origin (X, Y)
// Total width of the teeth array (teeth + gaps)
total_teeth_width = (num_teeth * tooth_x) + ((num_teeth - 1) * gap_x);

// X-axis: Center the spine and the teeth array on X=0
spine_x_start = -spine_x / 2;
start_x = -total_teeth_width / 2;

// Y-axis: Center the entire object (spine + teeth) on Y=0
// The spine and teeth together have a total Y-span of spine_y + tooth_y
// To center this, the spine starts at tooth_y and ends at tooth_y + spine_y
// This places the teeth from -tooth_y to 0 and the spine from 0 to spine_y
spine_y_start = tooth_y; 
tooth_y_start = 0;

// Wait, let's re-calculate Y centering to be precise:
// Total Y span = spine_y + tooth_y = 12 + 12 = 24.
// To center 24 on Y=0, Y must go from -12 to 12.
// Since teeth hang in the -Y direction, teeth are from -12 to 0.
// Spine is from 0 to 12.
spine_y_start_final = 0;
tooth_y_start_final = -tooth_y;

// Build the comb
union() {
    // The spine (back bar)
    translate([spine_x_start, spine_y_start_final, 0]) {
        cube([spine_x, spine_y, spine_z]);
    }

    // The 10 rectangular teeth
    for (i = [0 : num_teeth - 1]) {
        translate([
            start_x + i * (tooth_x + gap_x), 
            tooth_y_start_final, 
            0
        ]) {
            cube([tooth_x, tooth_y, spine_z]);
        }
    }
}