// Lab Funnel - A straight spout tube with a conical funnel body, open at top and bottom.
// Printed upright with the wide opening at the top.

// Dimensions
spout_od    = 10;      // Outer diameter of straight spout
spout_id    = 6.8;     // Inner diameter of straight spout (10 - 2*1.6)
spout_len   = 20;      // Length of straight spout (z=0 to z=20)
funnel_start_od = 10;  // Outer diameter at start of cone (z=20)
funnel_end_od  = 60;   // Outer diameter at rim (z=50)
funnel_len    = 30;    // Length of cone section (50 - 20)
wall_thick    = 1.6;   // Wall thickness everywhere

// Derived dimensions
funnel_start_id = funnel_start_od - 2 * wall_thick; // 6.8
funnel_end_id   = funnel_end_od - 2 * wall_thick;  // 52.8

$fn = 64;

// Build the solid part
difference() {
    union() {
        // 1. Straight Spout (Tube)
        // Outer cylinder
        translate([0, 0, 0]) 
            cylinder(h = spout_len, d = spout_od);
        
        // Inner cylinder (hole)
        translate([0, 0, 0]) 
            cylinder(h = spout_len, d = spout_id);

        // 2. Conical Funnel Body
        // Outer cone
        translate([0, 0, spout_len]) 
            linear_extrude(height = funnel_len) 
                polygon([
                    [spout_od / 2, 0],
                    [funnel_end_od / 2, funnel_len],
                    [-funnel_end_od / 2, funnel_len],
                    [-spout_od / 2, 0]
                ]);
        
        // Inner cone (hole)
        translate([0, 0, spout_len]) 
            linear_extrude(height = funnel_len) 
                polygon([
                    [spout_id / 2, 0],
                    [funnel_end_id / 2, funnel_len],
                    [-funnel_end_id / 2, funnel_len],
                    [-spout_id / 2, 0]
                ]);
    }
    
    // Cut the top opening (rim)
    // Extend slightly past the rim to ensure clean cut
    translate([0, 0, spout_len + funnel_len]) 
        cylinder(h = 2, d = funnel_end_od + 0.5);
    
    // Cut the bottom opening (spout tip)
    // Extend slightly past the tip to ensure clean cut
    translate([0, 0, -1]) 
        cylinder(h = 2, d = spout_od + 0.5);
}