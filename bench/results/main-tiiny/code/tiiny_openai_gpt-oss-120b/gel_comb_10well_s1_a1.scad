// Parameters (mm)
spine_len = 70;          // length of the back bar along X
spine_width = 12;        // width of the back bar along Y
thickness = 1.5;         // plate thickness (Z)
tooth_width = 5.0;        // width of each tooth along X
tooth_length = 12;        // length of each tooth along Y (extends -Y)
gap = 1.5;               // gap between neighbouring teeth (X)
tooth_count = 10;        // number of teeth

// Derived values
occupied_width = tooth_width*tooth_count + gap*(tooth_count-1); // total X span of teeth+gaps
margin = (spine_len - occupied_width)/2; // half‑margin on each side of the tooth row

// Set resolution for any curved primitives (none used here, but $fn is required)
$fn = 64;

// Main model
union() {
    // Back bar (spine) – a flat rectangular plate
    translate([-spine_len/2, -spine_width/2, 0])
        cube([spine_len, spine_width, thickness]);

    // Teeth – rectangular prisms hanging from the -Y edge of the spine
    for (i = 0; i < tooth_count; i++) {
        x_pos = -spine_len/2 + margin + i*(tooth_width + gap);
        translate([x_pos,
                   -spine_width/2 - tooth_length,
                   0])
            cube([tooth_width, tooth_length, thickness]);
    }
}