// Lab Funnel - A straight spout tube with a conical funnel on top.
// Printed upright with the wide opening at the top.
// Spout: 10mm OD, 20mm long. Funnel: widens from 10mm to 60mm over 30mm height.
// Wall thickness: 1.6mm everywhere.

$fn = 64;

// Dimensions
spout_od      = 10;
spout_id      = spout_od - 2 * 1.6; // 6.8 mm
spout_height  = 20;
funnel_bottom_od = spout_od;
funnel_top_od   = 60;
funnel_height   = 30;
wall_thickness  = 1.6;

// Calculate inner dimensions for the funnel top
funnel_top_id = funnel_top_od - 2 * wall_thickness;

// Build the part in one difference operation to ensure clean holes
difference() {
    // 1. The Outer Shell (Solid)
    union() {
        // Spout outer cylinder
        cylinder(h = spout_height, d = spout_od);
        
        // Funnel outer cone
        // Starts at z = spout_height with diameter = spout_od
        // Ends at z = spout_height + funnel_height with diameter = funnel_top_od
        translate([0, 0, spout_height]) 
            cylinder(h = funnel_height, 
                    d1 = spout_od, 
                    d2 = funnel_top_od, 
                    center = false);
    }
    
    // 2. The Inner Cavity (Holes)
    union() {
        // Spout inner cylinder (bore)
        translate([0, 0, spout_height - 1]) // Extend slightly past bottom to ensure clean cut
            cylinder(h = spout_height + 1, d = spout_id);
            
        // Funnel inner cone
        // Starts at z = spout_height with diameter = spout_id
        // Ends at z = spout_height + funnel_height with diameter = funnel_top_id
        translate([0, 0, spout_height]) 
            cylinder(h = funnel_height, 
                    d1 = spout_id, 
                    d2 = funnel_top_id, 
                    center = false);
    }
}