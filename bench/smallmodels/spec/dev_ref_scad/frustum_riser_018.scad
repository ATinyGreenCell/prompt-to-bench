// Tapered riser block for raising a beaker
// Solid square frustum with a square pocket in the top face

// ---- Dimensions (mm) ----
base_size    = 80;   // bottom square side length (at z = 0)
top_size     = 40;   // top square side length (at z = height)
height       = 20;   // overall height of the frustum
pocket_size  = 32;   // square pocket side length
pocket_depth = 8;    // pocket depth from top face
eps          = 0.5;  // overshoot for clean boolean cuts

$fn = 64;

// ---- Frustum via polyhedron-free hull of thin slabs ----
module frustum() {
    hull() {
        // bottom square
        translate([-base_size/2, -base_size/2, 0])
            cube([base_size, base_size, 0.01]);
        // top square
        translate([-top_size/2, -top_size/2, height - 0.01])
            cube([top_size, top_size, 0.01]);
    }
}

difference() {
    frustum();
    // centred square pocket cut into the top face
    translate([-pocket_size/2, -pocket_size/2, height - pocket_depth])
        cube([pocket_size, pocket_size, pocket_depth + eps]);
}
