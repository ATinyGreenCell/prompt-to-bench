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
module cradle_cutter() {
    // To place a cylinder axis at (y=0, z=52) running along X:
    // 1. We want the cylinder to be centered on X. 
    // 2. We rotate it to lie along X.
    // 3. We translate it to the target Z and Y.
    // 4. We translate it along X by half its length so its center is at x=0.
    
    cylinder_len = base_l + 2;
    translate([0, 0, cradle_z]) // Move to Z axis height
        rotate([0, 90, 0])      // Rotate to lie along X
            translate([0, 0, -cylinder_len/2]) // Center the cylinder on X=0
                cylinder(h = cylinder_len, d = cradle_r * 2);
}

// Final Assembly
// Rule: "The cradle is not cut through them [the dividers]"
// We use union of (Base - Cradle) and (Dividers).

union() {
    // Part 1: The base with the cradle cut out
    difference() {
        base();
        // Subtract the cradle cutter from the base
        cradle_cutter();
    }
    
    // Part 2: The solid dividers
    dividers();
}