// 10-well comb for agarose gel casting
// Print orientation: flat on XY plane, Z = 0

$fn = 64;

// Dimensions
thickness = 1.5;        // Z thickness (mm)
spine_length = 70;      // X length of spine (mm)
spine_width = 12;       // Y width of spine (mm)
tooth_width = 5.0;      // X width of each tooth (mm)
tooth_length = 12;      // Y length of each tooth (mm)
gap_width = 1.5;        // X gap between neighbouring teeth (mm)
num_teeth = 10;         // number of teeth

// Calculate total width of teeth + gaps
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * gap_width;
teeth_row_width = total_tooth_width + total_gap_width;

// Build the comb - position so bottom is at z=0
union() {
    // Spine (back bar) - positioned at z=0 to z=thickness
    translate([0, 0, thickness/2])
        cube([spine_length, spine_width, thickness], center = true);
    
    // Teeth - positioned at z=0 to z=thickness
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position of each tooth
        // Teeth are centered on the spine, so first tooth starts at:
        // -teeth_row_width/2 + tooth_width/2
        x_pos = -teeth_row_width/2 + i * (tooth_width + gap_width) + tooth_width/2;
        
        // Position tooth: centered in X, extending from spine edge (-Y direction)
        // Spine edge is at Y = -spine_width/2 (since spine is centered at Y=0)
        // Translate to position tooth with bottom at z=0
        translate([x_pos, -spine_width/2 - tooth_length/2, thickness/2])
            cube([tooth_width, tooth_length, thickness], center = true);
    }
}