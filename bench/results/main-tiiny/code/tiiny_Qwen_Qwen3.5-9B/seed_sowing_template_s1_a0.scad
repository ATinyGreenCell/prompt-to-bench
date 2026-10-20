// Sowing Template for 90mm Petri Dish
// Designed to sit on the XY plane (Z=0), centred at origin.

// --- Dimensions ---
// Disc outer diameter
$D_outer = 85;
// Disc thickness
$h = 2;
// Grid configuration
$grid_rows = 7;
$grid_cols = 7;
// Hole diameter
$d_hole = 3;
// Hole spacing (centre-to-centre)
$spacing = 9;
// Notch dimensions (on +Y side)
$notch_width = 10; // X dimension
$notch_depth = 4;  // Y dimension (in from rim)

// --- Geometry Generation ---

// 1. Create the main disc
disc = difference() {
    // Base cylinder
    cylinder(h = $h, r = $D_outer / 2, $fn = 64);
    
    // 2. Cut the 7x7 grid of holes
    // Calculate offset to center the grid
    $offset = (($grid_rows - 1) * $spacing) / 2;
    
    for (y = [-$offset : $spacing : $offset], 
         x = [-$offset : $spacing : $offset]) {
        // Ensure hole is within disc bounds (safety check, though spacing ensures it)
        if (abs(x) < $D_outer/2 && abs(y) < $D_outer/2) {
            translate([x, y, 0]) {
                cylinder(h = $h + 0.1, r = $d_hole / 2, $fn = 64);
            }
        }
    }
    
    // 3. Cut the rectangular orientation notch on the +Y side
    // Notch is centred on Y axis, so x range is [-width/2, width/2]
    // Depth is measured from the rim inward (-Y direction)
    translate([0, $notch_depth/2, 0]) {
        // Cut a box: width x depth x full_height
        // Extending slightly past the top face to ensure clean cut
        cube([
            $notch_width, 
            $notch_depth, 
            $h + 0.1
        ]);
    }
};

// Final assembly: Center the object on the origin
translate([0, 0, 0]) {
    disc;
}