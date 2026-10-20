$fn = 64;

// --- Dimensions ---
// Spout (tube) dimensions
spout_od = 10;          // Outer diameter of the spout
spout_len = 20;         // Length of the spout (z=0 to z=20)
spout_r = spout_od / 2; // Outer radius of the spout

// Funnel (cone) dimensions
funnel_top_od = 60;     // Outer diameter of the funnel rim
funnel_top_r = funnel_top_od / 2; // Outer radius of the funnel rim
funnel_height = 50 - spout_len;    // Height of the cone section (z=20 to z=50)

// Wall thickness
wall_thickness = 1.6;

// Calculated Inner Dimensions
spout_id = spout_od - 2 * wall_thickness; // 10 - 3.2 = 6.8
spout_i_r = spout_id / 2;                  // 3.4
funnel_top_id = funnel_top_od - 2 * wall_thickness; // 60 - 3.2 = 56.8
funnel_top_i_r = funnel_top_id / 2;         // 28.4

// --- Geometry Construction ---

// 1. Outer Shape (Solid)
// Consists of a cylinder (spout) and a truncated cone (funnel)
outer_shape = union() {
    cylinder(h = spout_len, r = spout_r);
    translate([0, 0, spout_len]) {
        cylinder(h = funnel_height, r1 = spout_r, r2 = funnel_top_r);
    }
};

// 2. Inner Shape (Void to be subtracted)
// Consists of a cylinder (spout bore) and a truncated cone (funnel bore)
// Must extend slightly past outer faces to ensure clean cuts (Rule 5)
inner_shape = union() {
    // Spout Bore Cylinder: extends 0.1mm past bottom and top
    cylinder(h = spout_len + 0.2, r = spout_i_r);
    
    // Funnel Bore Cone: extends 0.1mm past top rim
    translate([0, 0, spout_len]) {
        cylinder(h = funnel_height + 0.1, r1 = spout_i_r, r2 = funnel_top_i_r);
    }
};

// 3. Final Object
// Subtract the inner void from the outer solid
difference() {
    outer_shape;
    inner_shape;
}