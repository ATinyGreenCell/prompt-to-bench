// Lab Funnel Design
// Units: mm
// Orientation: Upright, resting on XY plane at z=0

// Dimensions
spout_od = 10;        // Outer diameter of the spout
spout_length = 20;    // Length of the straight spout
funnel_bottom_z = 20; // Z position where the cone starts
funnel_top_z = 50;    // Z position of the funnel rim
wall_thickness = 1.6; // Thickness of the funnel walls
rim_thickness = 1.6;  // Thickness of the rim (same as wall)

// Derived Dimensions
spout_id = spout_od - (2 * wall_thickness); // Inner diameter of spout
funnel_od_top = 60;                          // Outer diameter at the rim
funnel_od_bottom = spout_od;                 // Outer diameter at the cone start
funnel_id_top = funnel_od_top - (2 * wall_thickness); // Inner diameter at the rim
funnel_id_bottom = spout_id;                // Inner diameter at the cone start

// Rendering
$fn = 64;

// Main Body
union() {
    // 1. Straight Spout (Tube)
    // We create a cylinder for the outer wall and subtract the inner bore
    translate([0, 0, 0])
    cylinder(h = spout_length, d = spout_od, center = false);
    
    difference() {
        // Inner bore of the spout
        cylinder(h = spout_length, d = spout_id, center = false);
        
        // Optional: Add a small chamfer or rounded edge at the bottom of the spout
        // to prevent sharp edges that might tear the print bed or catch liquid
        translate([0, 0, -0.1])
        cylinder(h = 0.2, d = spout_id + 0.5, center = false);
    }

    // 2. Funnel Cone
    // The cone starts at z = funnel_bottom_z
    // We use a cylinder with a large diameter and subtract a smaller cylinder
    // to create the conical volume.
    
    // Outer Cone
    translate([0, 0, funnel_bottom_z])
    cylinder(h = (funnel_top_z - funnel_bottom_z), d = funnel_od_top, center = false);
    
    // Inner Cone (Bore)
    translate([0, 0, funnel_bottom_z])
    cylinder(h = (funnel_top_z - funnel_bottom_z), d = funnel_id_top, center = false);
    
    // 3. Rim
    // A flat ring at the top of the funnel
    translate([0, 0, funnel_top_z])
    cylinder(h = rim_thickness, d = funnel_od_top, center = false);
    
    // Rim Bore (Hole for liquid)
    translate([0, 0, funnel_top_z])
    cylinder(h = rim_thickness, d = funnel_id_top, center = false);
}