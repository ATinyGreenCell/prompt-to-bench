$fn = 64;

// Dimensions in millimeters
spine_length = 70.0;      // Spine length (X direction)
spine_width = 12.0;         // Spine width (Y direction)
tooth_width = 5.0;          // Tooth width (X direction)
tooth_length = 12.0;        // Tooth length (Y direction, extending -Y)
gap = 1.5;                  // Gap between teeth (X direction)
thickness = 1.5;              // Comb thickness (Z direction)

// Total X length for teeth (10 teeth + 9 gaps)
total_teeth_length = 10 * tooth_width + 9 * gap;

// Center the comb at origin (X and Y)
spine = cube([spine_length, spine_width, thickness]);
teeth = 
    for (i = [0:9])
        translate([ -spine_length/2 + (spine_length - total_teeth_length)/2 + i * (tooth_width + gap), -tooth_length/2, 0 ])
            cube([tooth_width, tooth_length, thickness]);

// Union spine and teeth to form the complete comb
union() {
    spine;
    teeth;
}