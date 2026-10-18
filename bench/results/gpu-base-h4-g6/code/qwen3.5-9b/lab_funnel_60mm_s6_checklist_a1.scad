// Lab Funnel - Corrected single solid body.
// Printed upright (wide opening at top), resting on XY plane at z=0.

// Dimensions
spout_od    = 10;      // Outer diameter of straight spout
spout_id    = 6.8;     // Inner diameter of straight spout (10 - 2*1.6)
spout_len   = 20;      // Length of straight spout (z=0 to z=20)
funnel_start_od = 10;  // Outer diameter at start of cone (z=20)
funnel_end_od  = 60;   // Outer diameter at rim (z=50)
funnel_height = 30;    // Height of cone section (50 - 20)
wall_thick   = 1.6;    // Wall thickness everywhere

// Derived dimensions
funnel_end_id = funnel_end_od - 2 * wall_thick; // 56.8 mm

$fn = 64;

// Build the solid part using rotate_extrude to ensure a single watertight body.
// We define the profile as a list of [radius, z] points.
// The profile goes from z=0 to z=50.
// Outer profile: (5, 0) -> (5, 20) -> (30, 50)
// Inner profile: (3.4, 0) -> (3.4, 20) -> (28.4, 50)

difference() {
    // 1. Outer Shell
    rotate_extrude($fn = 64) 
        linear_extrude(height = 50, convexity = 3) 
            polygon([
                [spout_od / 2, 0],
                [spout_od / 2, spout_len],
                [funnel_end_od / 2, spout_len + funnel_height],
                [spout_od / 2, spout_len + funnel_height]
            ]);
    
    // 2. Inner Void
    rotate_extrude($fn = 64) 
        linear_extrude(height = 50, convexity = 3) 
            polygon([
                [spout_id / 2, 0],
                [spout_id / 2, spout_len],
                [funnel_end_id / 2, spout_len + funnel_height],
                [spout_id / 2, spout_len + funnel_height]
            ]);
}