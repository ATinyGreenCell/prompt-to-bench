// 10-well comb for agarose gel casting
// Print orientation: flat on XY plane, Z = 0

thickness = 1.5;      // mm, comb thickness (Z)
spine_length = 70;    // mm, X direction (length of back bar)
spine_width = 12;     // mm, Y direction (width of back bar)
num_wells = 10;       // number of teeth/wells
tooth_width = 5.0;    // mm, X direction (width of each tooth)
tooth_length = 12;    // mm, Y direction (length of each tooth, hanging down in -Y)
gap_width = 1.5;      // mm, gap between neighbouring teeth

// Calculate total width of teeth + gaps
total_tooth_width = num_wells * tooth_width;
total_gap_width = (num_wells - 1) * gap_width;
teeth_row_width = total_tooth_width + total_gap_width;

// Center the teeth row on the spine (which is spine_width wide)
// Spine is centered at X=0, so teeth row should be centered at X=0 too
teeth_row_x_start = -teeth_row_width / 2;
tooth_spacing = tooth_width + gap_width;

// Build comb
module comb() {
    // Back bar (spine)
    translate([0, -spine_width/2, 0])
        cube([spine_length, spine_width, thickness]);
    
    // Teeth (10 rectangular teeth hanging from -Y edge)
    for (i = [0 : num_wells - 1]) {
        // X position of each tooth (centered on the spine)
        tooth_x = teeth_row_x_start + i * tooth_spacing + tooth_width/2;
        
        // Position tooth: X is tooth_x, Y starts at spine edge (-spine_width/2) and extends in -Y direction
        translate([tooth_x, -spine_width/2 - tooth_length, 0])
            cube([tooth_width, tooth_length, thickness]);
    }
}

// Render
comb();