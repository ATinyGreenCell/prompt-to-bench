$fn = 64;

// Dimensions
SPINE_LENGTH_X = 70;
SPINE_WIDTH_Y = 12;
SPINE_THICK_Z = 1.5;

TOOTH_COUNT = 10;
TOOTH_WIDTH_X = 5.0;
TOOTH_LENGTH_Y = 12;
TOOTH_THICK_Z = 1.5;

GAP_X = 1.5;

// Spine is centered at origin (0,0,0)
// Spine Y range: -6 to +6
// Spine Z range: 0 to 1.5

// Teeth hang from Y=6 edge in -Y direction
// Tooth Y range: 6 to -6 (matches spine width)
// Tooth X range: centered on spine

// Calculate tooth row centering
// Total tooth row length = 10 * 5.0 + 9 * 1.5 = 50 + 13.5 = 63.5 mm
// Center offset from spine edge = (70 - 63.5) / 2 = 3.25 mm

// Tooth positions in X
// Start X = 3.25
// Step X = 5.0 + 1.5 = 6.5

// Tooth positions in Y
// Hang from Y=6 edge in -Y direction
// Tooth Y range: 6 to -6
// Tooth center Y = 0

union() {
    // Spine
    translate([0, 0, 0])
    cube([SPINE_LENGTH_X, SPINE_WIDTH_Y, SPINE_THICK_Z]);

    // Teeth
    for (i = [0 : TOOTH_COUNT - 1]) {
        // Calculate X position for this tooth
        x_center = (SPINE_LENGTH_X - (TOOTH_COUNT * TOOTH_WIDTH_X + (TOOTH_COUNT - 1) * GAP_X)) / 2;
        x_pos = x_center + i * (TOOTH_WIDTH_X + GAP_X);

        // Translate to position
        translate([x_pos, 6, 0])
        // Tooth hangs from spine in -Y direction
        // Tooth Y range: 6 to -6
        // Tooth X range: -2.5 to +2.5 (width 5)
        // Tooth Z range: 0 to 1.5
        cube([TOOTH_WIDTH_X, TOOTH_LENGTH_Y, TOOTH_THICK_Z]);
    }
}