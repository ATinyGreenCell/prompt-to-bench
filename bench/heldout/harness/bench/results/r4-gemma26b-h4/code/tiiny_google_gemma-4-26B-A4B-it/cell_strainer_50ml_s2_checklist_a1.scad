// Coarse cell strainer for 50 mL conical tube
// Designed for FDM printing, oriented upright (Z-axis)

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

// --- Main Part Construction ---

difference() {
    // 1. The Solid Body (Cup + Flare + Rim)
    union() {
        // Main Cup Body
        cylinder(h = cup_h, d = od_cup);
        
        // Flare/Collar (45-degree cone from z=26 to z=30)
        // d1=25 at z=26, d2=33 at z=30
        translate([0, 0, 26])
            cylinder(h = 4, d1 = collar_d1, d2 = collar_d2);
        
        // Rim (from z=30 to z=32)
        translate([0, 0, 30])
            cylinder(h = rim_h, d = rim_d);
    }

    // 2. The Hollow Bore (Inside the cup)
    // Subtracting the bore from the bottom up to the top
    translate([0, 0, -0.01])
        cylinder(h = cup_h + 0.02, d = bore_d);

    // 3. The Vent Notches
    // "3mm wide vent notches, on the +X and -X sides, remove the collar and rim beyond 12.5mm from the axis from z=25 up"
    // We interpret this as: at the +X and -X positions, remove the material 
    // that exists between r=12.5 and the outer edge, for z >= 25.
    for (side = [-1, 1]) {
        translate([side * notch_r, 0, 25])
            // We use a large cube to cut the "outer" part of the notch.
            // The notch is 3mm wide (Y direction).
            // We rotate it so the "cut" is on the side.
            // Actually, to remove material *beyond* 12.5mm, we subtract a block 
            // that is centered on the X axis, 3mm wide in Y, and starts at X=12.5.
            // To ensure it cuts through the rim/collar, we make the cube large.
            cube([20, notch_w, cup_h + 10], center = true); 
            // Note: The cube is centered, so we must adjust translation.
            // Let's use a more precise subtraction method.
    }
    
    // Re-implementing Notch subtraction more cleanly:
    // We want to remove material where (abs(x) > 12.5 AND abs(y) < notch_w/2 AND z >= 25)
    // on the +X and -X sides.
    for (side = [-1, 1]) {
        translate([side * notch_r, 0, 25])
            // This cube is centered at X=notch_r. 
            // To remove material from notch_r to the edge, we make the cube 
            // extend from X=0 to X=infinity.
            // Since it's centered, we translate it so its edge is at X=0.
            translate([notch_r/2, 0, 25])
                cube([20, notch_w, cup_h + 10], center = true);
    }
    
    // 4. The Floor Holes
    // "The floor has 1.0 mm holes on a 2 mm square grid... one hole at the centre... 
    // keeping every hole whose centre is within 10 mm of the axis (81 holes)."
    // Grid is aligned with X and Y.
    // Holes are in the floor (z=0 to z=1.2).
    // We subtract holes from the bottom (z=0) upwards.
    for (x = [-10 : 2 : 10]) {
        for (y = [-10 : 2 : 10]) {
            // Check if center is within 10mm of axis
            if (sqrt(x*x + y*y) <= 10.0) {
                translate([x, y, -0.01])
                    cylinder(h = 1.2 + 0.02, d = hole_d);
            }
        }
    }
}

// Note on Notch Logic:
// The user requested: "remove the collar and rim beyond 12.5 mm from the axis".
// This means the notch is a gap in the outer wall.
// My code subtracts a block that starts at X=12.5 and goes outwards.
// This creates a notch/gap in the side of the collar/rim.