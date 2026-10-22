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
teeth_row_width = num_wells * tooth_width + (num_wells - 1) * gap_width;

// Spine should extend beyond teeth row on both sides
// Spine length = 70 mm, teeth row width = 63.5 mm
// So spine extends (70 - 63.5)/2 = 3.25 mm beyond on each side
spine_extension = (spine_length - teeth_row_width) / 2;

// Build comb as single solid
module comb() {
    // Back bar (spine) - full length, centered at X=0, Y centered
    translate([0, 0, 0])
        cube([spine_length, spine_width, thickness]);
    
    // Teeth - attached to the bottom edge of spine (Y negative direction)
    // Teeth row is centered on spine in X
    for (i = [0 : num_wells - 1]) {
        // X position of each tooth center (centered on spine)
        tooth_x = -teeth_row_width/2 + i * (tooth_width + gap_width) + tooth_width/2;
        
        // Place tooth: aligned with spine in X, attached at bottom edge of spine in Y
        // Spine Y range: -spine_width/2 to +spine_width/2
        // Tooth Y range: -spine_width/2 - tooth_length to -spine_width/2
        translate([tooth_x, -spine_width/2 - tooth_length, 0])
            cube([tooth_width, tooth_length, thickness]);
    }
}

// Render
comb();