// PCR Tube Adapter Sleeve - fits 0.2mL tubes into 1.5mL rack holes.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od = 13;
collar_t  = 1.5;
body_od   = 10.8;
top_z     = 21.5;
bore_d    = 6.2;

$fn = 64;

difference() {
    // Main body: Cylinder from z=0 to z=top_z (21.5)
    translate([0, 0, 0]) 
        cylinder(h = top_z, d = collar_od);
    
    // Cut out the bore through the entire height
    // Extend slightly past top_z to ensure the hole is fully open at the top surface
    translate([0, 0, -1]) 
        cylinder(h = top_z + 0.1, d = bore_d);
    
    // Cut out the collar area to create the step down to the body OD
    // The collar sits on the bed (z=0 to 1.5). We cut a cylinder from z=0 to z=1.5
    // with diameter = body_od. We extend slightly past the collar top (1.5) to ensure the step is clean.
    translate([0, 0, -1]) 
        cylinder(h = collar_t + 0.01, d = body_od);
}