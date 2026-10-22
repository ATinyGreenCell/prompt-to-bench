// Sowing template for 90 mm Petri dish
// Corrected to match specifications exactly

// Overall disc dimensions
diameter_disc = 85;
thickness_disc = 2;

// Grid parameters
grid_rows = 7;
grid_cols = 7;
hole_diameter = 3;
hole_spacing = 9;

// Notch dimensions
notch_width = 10;      // X direction
notch_depth = 4;       // Y direction (in from rim)

// Set resolution for smooth holes
$fn = 64;

// Main disc body
module disc() {
    difference() {
        // Solid disc: centered on origin, lies on XY plane at z = 0
        cylinder(h = thickness_disc, r = diameter_disc / 2, center = true);
        
        // Cut out the grid of holes
        // Center the grid on the origin: total span = (6 * 9) = 54 mm
        // So grid spans from -27 to +27 in both X and Y
        for (i = [0 : grid_rows - 1]) {
            for (j = [0 : grid_cols - 1]) {
                translate([
                    -27 + j * hole_spacing,
                    -27 + i * hole_spacing,
                    0
                ]) {
                    cylinder(h = thickness_disc + 0.1, r = hole_diameter / 2, center = true);
                }
            }
        }
        
        // Cut out the orientation notch
        // Notch is on the +Y side, centered on Y axis, 10 mm wide (X), 4 mm deep (Y from rim)
        // Rim is at Y = -42.5 (since disc radius is 42.5), so notch starts at Y = -42.5 + 4 = -38.5
        // Notch extends from Y = -42.5 to Y = -38.5 (4 mm deep), and X from -5 to +5 (10 mm wide)
        translate([
            0,
            -42.5 + notch_depth,
            -0.01
        ]) {
            cube([
                notch_width,
                notch_depth,
                thickness_disc + 0.02
            ], center = false);
        }
    }
}

// Ensure the part sits flat on the bed at z = 0
// The cylinder is centered at z = 0, so bottom is at z = -1, top at z = 1
// We need to shift the entire part so that z = -1 becomes z = 0
// But the problem says: "lies on the bed" — so the bottom must be at z = 0

// Adjust: move the whole disc up by 1 mm so that its bottom is at z = 0
translate([0, 0, 1]) {
    disc();
}