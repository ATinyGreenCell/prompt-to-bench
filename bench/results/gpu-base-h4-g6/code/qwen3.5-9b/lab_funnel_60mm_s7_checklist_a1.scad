// Lab Funnel - Corrected version ensuring full spout length and proper funnel transition.
// Printed upright with the wide opening at the top.
// Spout: 10mm OD, 20mm long (z=0 to z=20). Funnel: widens from 10mm to 60mm over 30mm height (z=20 to z=50).
// Wall thickness: 1.6mm everywhere.

$fn = 64;

// Dimensions
spout_od      = 10;
wall_thickness = 1.6;
spout_id      = spout_od - 2 * wall_thickness; // 6.8 mm
spout_height  = 20;
funnel_bottom_od = spout_od;
funnel_top_od   = 60;
funnel_height   = 30;
funnel_top_id = funnel_top_od - 2 * wall_thickness; // 56.8 mm

// Build the part in one difference operation
difference() {
    // 1. The Outer Shell (Solid)
    union() {
        // Spout outer cylinder (z=0 to z=20)
        cylinder(h = spout_height, d = spout_od);
        
        // Funnel outer cone (z=20 to z=50)
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
        // Must extend from z=0 to z=20. 
        // Extend 0.5mm past z=0 and z=20 to ensure clean cut.
        translate([0, 0, -0.5]) 
            cylinder(h = spout_height + 1, d = spout_id);
            
        // Funnel inner cone
        // Starts at z = spout_height (20) with diameter = spout_id
        // Ends at z = spout_height + funnel_height (50) with diameter = funnel_top_id
        // Extend 0.5mm past z=20 and z=50.
        translate([0, 0, spout_height - 0.5]) 
            cylinder(h = funnel_height + 1, 
                    d1 = spout_id, 
                    d2 = funnel_top_id, 
                    center = false);
    }
}