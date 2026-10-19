// Small Lab Funnel - Corrected Version 2
// Designed for FDM printing: printed upright, spout at bottom.

// --- Dimensions ---
spout_od      = 10.0;    // Outer diameter of the spout (mm)
spout_height  = 20.0;    // Height of the spout (mm)
rim_od        = 60.0;    // Outer diameter at the top rim (mm)
funnel_height = 30.0;    // Height of the conical section (mm)
wall_thick    = 1.6;     // Wall thickness (mm)

// --- Derived Dimensions ---
total_height   = spout_height + funnel_height;
spout_id       = spout_od - (2 * wall_thick);
rim_id         = rim_od - (2 * wall_thick);

$fn = 128;

// --- Geometry Construction ---

module funnel_outer() {
    // Use hull to create the conical frustum smoothly
    union() {
        // The spout
        cylinder(h = spout_height, d = spout_od);
        
        // The conical section
        translate([0, 0, spout_height])
        hull() {
            cylinder(h = 0.01, d = spout_od);
            cylinder(h = funnel_height, d = rim_od);
        }
    }
}

module funnel_inner() {
    // The hollow part
    union() {
        // Spout bore
        translate([0, 0, -1])
            cylinder(h = spout_height + 2, d = spout_id);
        
        // Conical bore
        translate([0, 0, spout_height])
        hull() {
            cylinder(h = 0.01, d = spout_id);
            cylinder(h = funnel_height + 1, d = rim_id);
        }
    }
}

// Final Assembly
difference() {
    // The solid outer shell
    funnel_outer();
    
    // The hollow interior
    funnel_inner();
}