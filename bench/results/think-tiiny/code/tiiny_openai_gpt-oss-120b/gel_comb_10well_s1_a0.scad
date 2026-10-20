// Parameters (mm)
thickness = 1.5;          // Plate thickness
spine_length = 70;        // Length of the back bar (X)
spine_width = 12;         // Width of the back bar (Y)
tooth_width = 5.0;        // Width of each tooth (X)
tooth_length = 12;        // Length of each tooth (Y)
gap = 1.5;                // Gap between neighbouring teeth (Y)
num_teeth = 10;           // Number of teeth

$fn = 64; // smooth circles/cylinders

// Main module
module agarose_comb() {
    // Spine (back bar) – centered on origin, bottom at Z=0
    translate([-spine_length/2, -spine_width/2, 0])
        cube([spine_length, spine_width, thickness]);

    // Compute total width occupied by teeth + gaps
    total_tooth_row_width = num_teeth*tooth_width + (num_teeth-1)*gap;

    // Generate teeth with a for‑loop
    for (i = [0 : num_teeth-1]) {
        // X position of the centre of the i‑th tooth
        tooth_center_x = -total_tooth_row_width/2 + tooth_width/2 + i*(tooth_width + gap);
        // Y position: front face of tooth aligns with the -Y edge of the spine
        tooth_y = -spine_width/2 - tooth_length;

        translate([tooth_center_x - tooth_width/2,
                   tooth_y,
                   0])
            cube([tooth_width, tooth_length, thickness]);
    }
}

// Assemble the part
agarose_comb();