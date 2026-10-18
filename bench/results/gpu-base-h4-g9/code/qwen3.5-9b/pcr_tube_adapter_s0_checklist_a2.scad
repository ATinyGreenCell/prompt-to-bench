// PCR Tube Adapter Sleeve - fits a 0.2mL tube into a 1.5mL rack hole.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od = 13;
collar_t  = 1.5;
body_od   = 10.8;
body_h    = 20.0; // Calculated as 21.5 (top Z) - 1.5 (collar height)
bore_d    = 6.2;

$fn = 64;

// Calculate total height for the main body block
total_h = collar_t + body_h;

difference() {
    // Main solid: Collar + Body
    union() {
        // Collar (lies flat on bed)
        translate([0, 0, 0]) 
            cylinder(h = collar_t, d = collar_od);
        
        // Body (rises from top of collar)
        translate([0, 0, collar_t]) 
            cylinder(h = body_h, d = body_od);
    }
    
    // Bore (straight hole through full height)
    // Extend slightly past top and bottom to ensure clean cut
    translate([0, 0, -1]) 
        cylinder(h = total_h + 2, d = bore_d);
}