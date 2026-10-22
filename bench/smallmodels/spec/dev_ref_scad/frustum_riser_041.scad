// Tapered riser block (square frustum) with top pocket
// Print orientation: large base on bed, builds upward (+Z)

$fn = 64;

// --- Dimensions (mm) ---
base_size    = 60;   // bottom square side at z = 0
top_size     = 30;   // top square side at z = height
height       = 25;   // overall height
pocket_size  = 20;   // square pocket side (in top face)
pocket_depth = 5;    // pocket depth from top face
eps          = 0.5;  // cutter overshoot past faces

// Solid square frustum, edges parallel to X and Y
module frustum() {
    hull() {
        translate([-base_size/2, -base_size/2, 0])
            cube([base_size, base_size, 0.01]);
        translate([-top_size/2, -top_size/2, height - 0.01])
            cube([top_size, top_size, 0.01]);
    }
}

difference() {
    frustum();
    // Centred square pocket cut down from the top face
    translate([-pocket_size/2, -pocket_size/2, height - pocket_depth])
        cube([pocket_size, pocket_size, pocket_depth + eps]);
}
