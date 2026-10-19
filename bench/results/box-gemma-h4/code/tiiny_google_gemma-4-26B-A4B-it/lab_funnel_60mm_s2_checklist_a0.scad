// Small Lab Funnel
// Designed for FDM printing: printed upright, spout at bottom.

// --- Dimensions ---
spout_od     = 10.0;    // Outer diameter of the spout (mm)
spout_height = 20.0;    // Height of the spout (mm)
rim_od       = 60.0;    // Outer diameter at the top rim (mm)
funnel_height = 30.0;   // Height of the conical section (50mm total - 20mm spout)
wall_thick   = 1.6;     // Wall thickness (mm)

// --- Derived Dimensions ---
total_height = spout_height + funnel_height;
spout_id     = spout_od - (2 * wall_thick);
rim_id       = rim_od - (2 * wall_thick);

$fn = 128;

// --- Geometry Construction ---

// The main body is a union of the spout cylinder and the conical frustum.
// We use a difference to subtract the internal hollow space.

module funnel_body() {
    union() {
        // Spout section
        cylinder(h = spout_height, d = spout_od);
        
        // Conical section
        // We use a polygon with rotate_extrude to create the frustum profile
        rotate_extrude() {
            polygon(points = [
                [spout_od / 2, 0],              // Bottom of cone (at z=20)
                [rim_od / 2, funnel_height]     // Top of cone (at z=50)
            ]);
        }
    }
}

module internal_hollow() {
    // The hollow part consists of the spout bore and the conical bore.
    // We extend the shapes slightly to ensure clean cuts.
    
    // Spout bore
    translate([0, 0, -1])
        cylinder(h = spout_height + 2, d = spout_id);
    
    // Conical bore
    // We calculate the profile of the internal cone
    rotate_extrude() {
        polygon(points = [
            [spout_id / 2, -1],              // Start slightly below spout junction
            [rim_id / 2, funnel_height + 1] // End slightly above rim
        ]);
    }
}

// Final Assembly
difference() {
    // The solid outer shell
    translate([0, 0, 0]) funnel_body();
    
    // The hollow interior
    translate([0, 0, 0]) internal_hollow();
}

// Note: The part is centered on X and Y. 
// It sits on the XY plane (z=0) at the bottom of the spout.