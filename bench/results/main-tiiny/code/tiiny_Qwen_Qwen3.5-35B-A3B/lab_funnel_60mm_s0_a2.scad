// Lab Funnel Design
// Units: millimetres
// Print orientation: Upright (XY plane at z=0, builds +Z)
// Centered on origin in X and Y.

// --- Dimensions ---
// Spout dimensions
spout_od = 10.0;       // Outer diameter of the straight spout
spout_height = 20.0;    // Height of the straight spout section
spout_thickness = 1.6; // Wall thickness
spout_id = spout_od - 2 * spout_thickness; // Inner diameter of spout (6.8 mm)

// Funnel (Cone) dimensions
funnel_height = 30.0;   // Height of the cone section (from z=20 to z=50)
funnel_rim_od = 60.0;   // Outer diameter at the top rim
funnel_rim_id = funnel_rim_od - 2 * spout_thickness; // Inner diameter at rim (56.8 mm)

// --- Calculated Values ---
// Radii
spout_r = spout_od / 2;
spout_inner_r = spout_id / 2;
funnel_rim_r = funnel_rim_od / 2;
funnel_rim_inner_r = funnel_rim_id / 2;

// Total height
total_height = spout_height + funnel_height;

// Epsilon for cutting tolerance (Rule 5: extend 0.01-1 mm past faces)
epsilon = 0.02;

// --- Construction Modules ---

// Module to create the outer solid shape
module outer_shape() {
    // 1. Straight Spout (Cylinder)
    // Extends from z=0 to z=20
    cylinder(h = spout_height, r = spout_r, center = false);
    
    // 2. Funnel Cone (Cone)
    // Extends from z=20 to z=50.
    // Bottom radius = spout_r, Top radius = funnel_rim_r.
    translate([0, 0, spout_height]) {
        cylinder(h = funnel_height, r1 = spout_r, r2 = funnel_rim_r, center = false);
    }
}

// Module to create the inner void shape
module inner_shape() {
    // 1. Straight Spout Bore (Cylinder)
    // Extends from z=0 to z=20
    cylinder(h = spout_height, r = spout_inner_r, center = false);
    
    // 2. Funnel Bore (Cone)
    // Extends from z=20 to z=50.
    // Bottom radius = spout_inner_r, Top radius = funnel_rim_inner_r.
    translate([0, 0, spout_height]) {
        cylinder(h = funnel_height, r1 = spout_inner_r, r2 = funnel_rim_inner_r, center = false);
    }
}

// --- Final Part Construction ---
// We use difference() to subtract the inner void from the outer solid.
// The inner shape is extended slightly to ensure clean cuts (Rule 5).
difference() {
    // The solid outer shell
    outer_shape();
    
    // The hollow inner void
    // We shift the inner shape slightly downwards to ensure it cuts through the bottom face
    // and extends slightly past the top face to avoid coplanar faces.
    translate([0, 0, -epsilon]) {
        inner_shape();
    }
}