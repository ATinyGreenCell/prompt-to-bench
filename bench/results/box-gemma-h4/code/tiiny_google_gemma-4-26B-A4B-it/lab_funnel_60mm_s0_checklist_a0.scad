// Small Lab Funnel
// Designed for FDM printing, printed upright.

// Dimensions
spout_od      = 10.0;    // Outer diameter of the spout (mm)
spout_height  = 20.0;    // Height of the spout (mm)
funnel_top_od = 60.0;    // Outer diameter at the top rim (mm)
funnel_height = 50.0;    // Total height from base to rim (mm)
wall_thickness = 1.6;    // Wall thickness (mm)

$fn = 100;               // High resolution for smooth curves

// Calculated internal dimensions
spout_id = spout_od - (2 * wall_thickness);
funnel_id_base = spout_od - (2 * wall_thickness);
funnel_id_top  = funnel_top_od - (2 * wall_thickness);

// The height of the conical section is the total height minus the spout height
cone_section_height = funnel_height - spout_height;

module funnel_body() {
    union() {
        // 1. The Spout (Cylinder)
        cylinder(h = spout_height, d = spout_od);
        
        // 2. The Funnel Cone
        // We use a hull of two circles to create the conical frustum
        hull() {
            // Bottom of cone (at z = 20)
            translate([0, 0, spout_height]) 
                cylinder(h = 0.01, d = spout_od);
            
            // Top of cone (at z = 50)
            translate([0, 0, funnel_height]) 
                cylinder(h = 0.01, d = funnel_top_od);
        }
    }
}

difference() {
    // Main solid body
    funnel_body();
    
    // Subtract the internal cavity to create the hollow funnel
    union() {
        // Internal spout bore
        translate([0, 0, -1]) 
            cylinder(h = spout_height + 2, d = spout_id);
        
        // Internal conical bore
        hull() {
            // Bottom of internal cone (at z = 20)
            translate([0, 0, spout_height]) 
                cylinder(h = 0.01, d = spout_id);
            
            // Top of internal cone (at z = 50)
            translate([0, 0, funnel_height]) 
                cylinder(h = 0.01, d = funnel_id_top);
        }
    }
}