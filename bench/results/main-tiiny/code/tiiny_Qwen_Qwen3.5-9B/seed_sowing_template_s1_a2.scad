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

// 1. Create the main disc with holes and notch
disc = difference() {
    // Base cylinder
    cylinder(h = $h, r = $D_outer / 2, $fn = 64);
    
    // 2. Cut the 7x7 grid of holes
    // Calculate offset to center the grid
    $offset = (($grid_rows - 1) * $spacing) / 2;
    
    for (y = [-$offset : $spacing : $offset], 
         x = [-$offset : $spacing : $offset]) {
        // Ensure hole is within disc bounds (safety check)
        if (abs(x) < $D_outer/2 && abs(y) < $D_outer/2) {
            translate([x, y, 0]) {
                cylinder(h = $h + 0.1, r = $d_hole / 2, $fn = 64);
            }
        }
    }
    
    // 3. Cut the rectangular orientation notch on the +Y side
    // The notch is centred on the Y axis of the disc.
    // It starts at the rim (Y = $D_outer/2) and goes inward by $notch_depth.
    // The center of the notch in Y is: ($D_outer/2) - ($notch_depth/2).
    $notch_center_y = ($D_outer / 2) - ($notch_depth / 2);
    
    translate([0, $notch_center_y, 0]) {
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