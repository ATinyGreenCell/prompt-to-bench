// Petri Dish Rack
// Designed for 90mm diameter dishes standing on edge.

// --- Dimensions ---
base_l      = 203.0;  // Length of base (X)
base_w      = 80.0;   // Width of base (Y)
base_h      = 20.0;   // Height of base (Z)

dish_radius = 45.0;   // Radius of 90mm dish
cradle_r    = 46.0;   // Radius of the cutting cylinder
cradle_z    = 52.0;   // Z-offset of the cylinder axis (bottoms at 52-46=6mm)

num_dividers = 11;     // Number of vertical plates
divider_t    = 3.0;    // Thickness of each divider (X)
divider_h    = 60.0;   // Height of dividers (Z)
divider_w    = 80.0;   // Width of dividers (Y)

// Spacing calculation: 
// 11 dividers create 10 slots. 
// Total length covered by dividers is from -100 to 100.
x_start      = -100.0;
x_end        = 100.0;
x_step       = 20.0;

$fn = 128;

// --- Modeling ---

// The base block
module base() {
    // Centered on X and Y, sitting on Z=0
    translate([-base_l/2, -base_w/2, 0])
        cube([base_l, base_w, base_h]);
}

// The vertical dividers
module dividers() {
    for (i = [0 : num_dividers - 1]) {
        x_pos = x_start + (i * x_step);
        translate([x_pos, -divider_w/2, 0])
            cube([divider_t, divider_w, divider_h]);
    }
}

// The cradle (the curved groove)
// The axis runs along X at y=0, z=52.
module cradle_cutter() {
    // To place a cylinder axis at (y=0, z=52) running along X:
    // 1. Start at origin.
    // 2. Rotate 90 deg around Y so it lies on X.
    // 3. Translate to the target Z (52) and Y (0).
    // 4. Make it long enough to clear the base.
    translate([0, 0, cradle_z])
        rotate([0, 90, 0])
            cylinder(h = base_l + 2, d = cradle_r * 2);
}

// Final Assembly
// Rule: "The cradle is not cut through them [the dividers]"
// This means we calculate (Base - Cradle) and then add Dividers.

union() {
    // Part 1: The base with the cradle cut out
    difference() {
        base();
        // We use a small epsilon/overlap to ensure clean cuts
        translate([0, 0, 0]) 
            cradle_cutter();
    }
    
    // Part 2: The solid dividers
    dividers();
}