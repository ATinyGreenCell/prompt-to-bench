// PCR Tube Adapter Sleeve - fits 0.2mL tubes into 1.5mL rack holes.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od = 13;
collar_t  = 1.5;
body_od   = 10.8;
body_h    = 21.5;
bore_d    = 6.2;

$fn = 64;

// Total height calculation
total_h = collar_t + body_h;

difference() {
    // Main body: Cylinder from z=0 to z=total_h
    translate([0, 0, 0]) 
        cylinder(h = total_h, d = collar_od);
    
    // Cut out the bore through the entire height
    translate([0, 0, -1]) 
        cylinder(h = total_h + 2, d = bore_d);
    
    // Cut out the collar area to create the step down to the body OD
    // The collar sits on the bed, so we cut a cylinder from z=0 to z=collar_t
    // with diameter = body_od. We extend slightly past the collar top.
    translate([0, 0, -1]) 
        cylinder(h = collar_t + 0.01, d = body_od);
}