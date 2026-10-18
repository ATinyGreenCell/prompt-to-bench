// Lab Funnel - Corrected single solid body using rotate_extrude.
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

// Define the outer profile as a list of [radius, z] points.
// The profile starts at z=0, goes up the spout, then widens to the rim.
// Points: [r0, z0], [r1, z1], [r2, z2], [r3, z3]
// We need to close the loop for the polygon, so we repeat the first point at the end.
outer_points = [
    [spout_od / 2, 0],
    [spout_od / 2, spout_len],
    [funnel_end_od / 2, spout_len + funnel_height],
    [spout_od / 2, spout_len + funnel_height], // Close the loop back to start radius at top
    [spout_od / 2, 0]                           // Close the loop back to start point
];

// Define the inner profile similarly.
inner_points = [
    [spout_id / 2, 0],
    [spout_id / 2, spout_len],
    [funnel_end_id / 2, spout_len + funnel_height],
    [spout_id / 2, spout_len + funnel_height], // Close the loop back to start radius at top
    [spout_id / 2, 0]                           // Close the loop back to start point
];

difference() {
    // 1. Outer Shell
    rotate_extrude($fn = 64) 
        polygon(points = outer_points);
    
    // 2. Inner Void
    rotate_extrude($fn = 64) 
        polygon(points = inner_points);
}