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
    // This creates the solid shape sitting on the bed.
    translate([0, 0, 0]) 
        cylinder(h = body_top_z, d = body_od);
    
    // Collar: Ring from Z=0 to Z=collar_thick
    // Outer radius = collar_od/2, Inner radius = body_od/2
    // This is redundant geometrically if the main cylinder is solid, 
    // but explicitly defines the collar region if we were doing union/difference differently.
    // Here, the main cylinder already covers this volume.
    
    // Through-hole: Cylinder extending slightly past top and bottom to ensure clean cut.
    // Starts at Z = -0.1 to ensure it cuts through the bottom face at Z=0.
    translate([0, 0, -0.1]) 
        cylinder(h = body_top_z + 0.9, d = bore_d);
}