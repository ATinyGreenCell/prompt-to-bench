// PCR Tube Adapter Sleeve - fits 0.2mL tubes into 1.5mL rack holes.
// Print orientation: Collar on bed (Z=0), body rises upward.

// Dimensions
collar_od = 13;      // Collar outer diameter
collar_thick = 1.5;  // Collar thickness (Z=0 to 1.5)
body_od = 10.8;      // Sleeve body outer diameter
body_top_z = 21.5;   // Top of sleeve body
bore_d = 6.2;        // Through-hole diameter

$fn = 64;

// Calculate body height
body_height = body_top_z - collar_thick;

difference() {
    // Main body: Cylinder from Z=0 to Z=body_top_z
    translate([0, 0, 0]) 
        cylinder(h = body_top_z, d = body_od);
    
    // Collar: Ring from Z=0 to Z=collar_thick
    // Outer radius = collar_od/2, Inner radius = body_od/2
    translate([0, 0, 0]) 
        cylinder(h = collar_thick, d = collar_od);
    
    // Through-hole: Cylinder extending slightly past top and bottom
    translate([0, 0, -1]) 
        cylinder(h = body_top_z + 2, d = bore_d);
}