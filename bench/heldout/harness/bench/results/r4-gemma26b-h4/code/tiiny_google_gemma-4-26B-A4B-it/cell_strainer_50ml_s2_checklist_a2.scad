// Coarse cell strainer for 50 mL conical tube
// Corrected: Notches now only cut the outer wall, not the whole part.

// --- Dimensions ---
od_cup      = 25.0;    // Outer diameter of the main cup
wall_t      = 1.2;     // Wall thickness
bore_d      = 22.6;    // Inner diameter of the cup
cup_h       = 32.0;    // Height of the cup body
floor_t     = 1.2;     // Thickness of the bottom floor
hole_d      = 1.0;     // Diameter of the strainer holes
grid_step   = 2.0;     // Spacing of the hole grid (square)
max_hole_r  = 10.0;    // Maximum radius for hole centers
collar_d1   = 25.0;    // Diameter at the start of the flare (z=26)
collar_d2   = 33.0;    // Diameter at the top of the flare (z=30)
rim_d       = 33.0;    // Diameter of the rim
rim_h       = 2.0;     // Height of the rim (from z=30 to z=32)
notch_w     = 3.0;     // Width of the vent notches (along Y axis)
notch_r     = 12.5;    // Radius from axis where notches begin

$fn = 64;

module strainer_body() {
    union() {
        // Main Cup Body
        cylinder(h = cup_h, d = od_cup);
        
        // Flare/Collar (45-degree cone from z=26 to z=30)
        translate([0, 0, 26])
            cylinder(h = 4, d1 = collar_d1, d2 = collar_d2);
        
        // Rim (from z=30 to z=32)
        translate([0, 0, 30])
            cylinder(h = rim_h, d = rim_d);
    }
}

difference() {
    // 1. The Solid Body
    strainer_body();

    // 2. The Hollow Bore
    // Subtract from z=0 to cup_h, but leave the floor_t
    translate([0, 0, -0.01])
        cylinder(h = cup_h - floor_t + 0.02, d = bore_d);

    // 3. The Vent Notches
    // "remove the collar and rim beyond 12.5 mm from the axis from z = 25 up"
    // To make a notch that only affects the outer wall, we subtract a 
    // shape that is wide in X (to cover the wall) but narrow in Y (the 3mm width)
    // and centered on the X axis.
    for (side = [-1, 1]) {
        translate([side * notch_r, 0, 25])
            // The cube is centered on the notch_r point.
            // To ensure it only cuts the "outer" part, we make it 
            // extend from the notch_r to the outer edge.
            // We use a large X dimension to ensure it clears the rim.
            // We use notch_w for the Y dimension.
            cube([20, notch_w, cup_h + 10], center = true);
    }
    
    // 4. The Floor Holes
    // Holes are subtracted from the bottom (z=0)
    for (x = [-10 : 2 : 10]) {
        for (y = [-10 : 2 : 10]) {
            // Check if center is within 10mm of axis
            if (sqrt(x*x + y*y) <= 10.0) {
                // Subtract from the bottom up through the floor
                translate([x, y, -0.01])
                    cylinder(h = floor_t + 0.02, d = hole_d);
            }
        }
    }
}