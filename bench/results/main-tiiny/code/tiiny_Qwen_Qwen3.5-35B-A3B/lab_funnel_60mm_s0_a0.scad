// Lab Funnel Design
// Units: millimetres
// Print orientation: Upright (XY plane at z=0, builds +Z)
// Centered on origin in X and Y.

// --- Dimensions ---
// Spout dimensions
spout_od = 10.0;       // Outer diameter of the straight spout
spout_height = 20.0;    // Height of the straight spout section
spout_thickness = 1.6; // Wall thickness
spout_id = spout_od - 2 * spout_thickness; // Inner diameter of spout

// Funnel (Cone) dimensions
funnel_height = 30.0;   // Height of the cone section (from z=20 to z=50)
funnel_rim_od = 60.0;   // Outer diameter at the top rim
funnel_rim_id = funnel_rim_od - 2 * spout_thickness; // Inner diameter at rim

// --- Calculated Values ---
// Radii
spout_r = spout_od / 2;
spout_inner_r = spout_id / 2;
funnel_rim_r = funnel_rim_od / 2;
funnel_rim_inner_r = funnel_rim_id / 2;

// Total height
total_height = spout_height + funnel_height;

// --- Construction ---
// We build the outer shape and subtract the inner void.
// The outer shape consists of a cylinder (spout) and a cone (funnel).
// The inner shape consists of a cylinder (spout bore) and a cone (funnel bore).

module outer_shape() {
    // 1. Straight Spout (Cylinder)
    // Extends from z=0 to z=20
    cylinder(h = spout_height, r = spout_r, center = false);
    
    // 2. Funnel Cone (Cone)
    // Extends from z=20 to z=50.
    // Bottom radius = spout_r, Top radius = funnel_rim_r.
    // We use a cylinder with different top and bottom radii (cone).
    // Note: OpenSCAD cylinder with r1 != r2 creates a cone.
    // We need to position the base at z=20.
    translate([0, 0, spout_height]) {
        cylinder(h = funnel_height, r1 = spout_r, r2 = funnel_rim_r, center = false);
    }
}

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

// Final Part: Outer shape minus Inner shape
// Ensure the inner shape extends slightly past the faces to avoid coplanar issues.
// We add a small epsilon to the height of the inner shape to ensure it cuts through.
epsilon = 0.01;

union() {
    // Create the solid outer shell
    outer_shape();
    
    // Subtract the inner void
    // We use a slightly taller inner shape to ensure the cut goes through the top rim
    // and bottom spout tip cleanly.
    difference() {
        // The outer shape is the base
        outer_shape();
        
        // The inner void
        // We shift the inner shape slightly to ensure it cuts the top face of the cone
        // and the bottom face of the spout.
        // Actually, for a hollow part, we just subtract the inner volume.
        // To ensure no coplanar faces at the very top rim, we make the inner cone
        // slightly taller than the outer cone, or the outer cone slightly shorter.
        // The rule says "make every cutting shape extend 0.01-1 mm past the faces".
        // So we extend the inner shape slightly beyond the outer shape's top and bottom.
        
        translate([0, 0, -epsilon]) {
            inner_shape();
        }
    }
}

// Render the final part
difference() {
    outer_shape();
    // Extend the inner cut slightly to ensure clean topology
    translate([0, 0, -epsilon]) {
        inner_shape();
    }
}