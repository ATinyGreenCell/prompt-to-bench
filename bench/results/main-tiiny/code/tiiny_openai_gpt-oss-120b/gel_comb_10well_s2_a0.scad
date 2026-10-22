// --------------- Parameters (mm) ----------------
// Spine (back bar) dimensions
spine_length = 70;        // length along X
spine_width  = 12;        // width along Y
spine_thick = 1.5;        // thickness along Z

// Tooth dimensions
tooth_width  = 5.0;       // width along X
tooth_len    = 12.0;      // length extending beyond spine in -Y
gap_between = 1.5;        // gap between adjacent teeth

num_teeth = 10;           // number of teeth

// --------------- Computed values ----------------
total_tooth_span = num_teeth*tooth_width + (num_teeth-1)*gap_between; // total X span of teeth
x_offset = -total_tooth_span/2;   // leftmost tooth edge, centered on spine

// --------------- Rendering ----------------
$fn = 64;   // smoothness for any curved primitives (not used here)

module spine() {
    // Spine plate, centered on origin, lying on Z=0
    translate([-spine_length/2, -spine_width/2, 0])
        cube([spine_length, spine_width, spine_thick]);
}

module teeth() {
    // Generate each tooth with a for‑loop
    for (i = [0 : num_teeth-1]) {
        x_pos = x_offset + i*(tooth_width + gap_between);
        // Position: start at spine's -Y edge (-spine_width/2) and extend -tooth_len
        translate([x_pos, -spine_width/2 - tooth_len, 0])
            cube([tooth_width, tooth_len, spine_thick]);
    }
}

union() {
    spine();
    teeth();
}