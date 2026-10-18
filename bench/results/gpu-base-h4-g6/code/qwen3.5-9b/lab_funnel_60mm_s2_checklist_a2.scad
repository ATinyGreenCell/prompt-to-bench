// Lab funnel - straight spout with conical body, open top and bottom.
// Printed upright, wide opening at top (z=50), spout at bottom (z=0).

// Dimensions
spout_od      = 10;      // Outer diameter of straight spout
spout_id      = 6.8;     // Inner diameter of straight spout (10 - 2*1.6)
spout_len     = 20;      // Length of straight spout
funnel_start  = 20;      // Z position where cone begins
funnel_end    = 50;      // Z position of funnel rim
funnel_od     = 60;      // Outer diameter at rim
funnel_id     = 56.8;    // Inner diameter at rim (60 - 2*1.6)
wall_thick    = 1.6;     // Wall thickness everywhere

$fn = 128;

// Outer Profile Points [radius, z]
// 1. Bottom of spout (z=0, r=5)
// 2. Top of spout / Bottom of cone (z=20, r=5)
// 3. Top of funnel (z=50, r=30)
outer_points = [
    [spout_od / 2, 0],
    [spout_od / 2, funnel_start],
    [funnel_od / 2, funnel_end]
];

// Inner Profile Points [radius, z]
// 1. Bottom of spout (z=0, r=3.4) - Straight tube
// 2. Top of spout / Bottom of cone (z=20, r=3.4) - Straight tube ends
// 3. Top of funnel (z=50, r=28.4) - Cone widens here
inner_points = [
    [spout_id / 2, 0],
    [spout_id / 2, funnel_start],
    [funnel_id / 2, funnel_end]
];

difference() {
    // Create the outer solid
    rotate_extrude() 
        polygon(outer_points);
    
    // Create the inner void (hole)
    rotate_extrude() 
        polygon(inner_points);
}