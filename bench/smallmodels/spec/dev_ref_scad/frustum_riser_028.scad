// Tapered riser block (square frustum) with top pocket
// Print orientation: large base on bed (z = 0), builds upward.

// ---- Dimensions (mm) ----
base_size    = 100;   // bottom square side length at z = 0
top_size     = 70;    // top square side length at z = height
height       = 25;    // overall block height
pocket_size  = 62;    // square pocket side length (in top face)
pocket_depth = 8;     // pocket depth from top face
eps          = 0.5;   // overcut for clean boolean cuts

$fn = 64;

// ---- Model ----
difference() {
    // Solid square frustum, centred on origin in X and Y
    hull() {
        translate([-base_size/2, -base_size/2, 0])
            cube([base_size, base_size, 0.01]);
        translate([-top_size/2, -top_size/2, height - 0.01])
            cube([top_size, top_size, 0.01]);
    }

    // Centred square pocket cut into the top face
    translate([-pocket_size/2, -pocket_size/2, height - pocket_depth])
        cube([pocket_size, pocket_size, pocket_depth + eps]);
}
