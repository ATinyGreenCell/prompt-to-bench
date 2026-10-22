// Tapered riser block for raising a beaker
// Solid square frustum with a square pocket in the top face

// ---------- Dimensions (mm) ----------
base_w      = 100;   // bottom square side length (z = 0)
top_w       = 70;    // top square side length (z = height)
height      = 30;    // overall height of frustum
pocket_w    = 60;    // pocket side length
pocket_d    = 8;     // pocket depth from top face
eps         = 0.5;   // overcut past faces for clean booleans

// ---------- Model ----------
difference() {
    // Square frustum built with polyhedron-free hull of thin slabs
    hull() {
        // bottom square
        translate([-base_w/2, -base_w/2, 0])
            cube([base_w, base_w, 0.01]);
        // top square
        translate([-top_w/2, -top_w/2, height - 0.01])
            cube([top_w, top_w, 0.01]);
    }

    // Centred square pocket in the top face
    translate([-pocket_w/2, -pocket_w/2, height - pocket_d])
        cube([pocket_w, pocket_w, pocket_d + eps]);
}
