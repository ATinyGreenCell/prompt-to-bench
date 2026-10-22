// Lab Funnel Design
// Wall thickness: 1.6 mm
// Spout: 10 mm outer diameter, 20 mm tall (z = 0 to z = 20)
// Cone: 10 mm outer diameter at z = 20, 60 mm outer diameter at z = 50

$fn = 64;

wall_thickness = 1.6;
spout_outer_diameter = 10;
spout_height = 20;
cone_top_diameter = 10;
cone_bottom_diameter = 60;
cone_height = 30; // from z = 20 to z = 50

// Calculate inner diameters
spout_inner_diameter = spout_outer_diameter - 2 * wall_thickness;
cone_top_inner_diameter = cone_top_diameter - 2 * wall_thickness;
cone_bottom_inner_diameter = cone_bottom_diameter - 2 * wall_thickness;

// Spout (cylinder)
spout_outer_radius = spout_outer_diameter / 2;
spout_inner_radius = spout_inner_diameter / 2;

// Cone (frustum)
cone_top_radius = cone_top_diameter / 2;
cone_bottom_radius = cone_bottom_diameter / 2;
cone_top_inner_radius = cone_top_inner_diameter / 2;
cone_bottom_inner_radius = cone_bottom_inner_diameter / 2;

// Build the funnel
module funnel() {
    // Outer spout
    translate([0, 0, 0])
        cylinder(h = spout_height, r = spout_outer_radius, center = false);
    
    // Outer cone (frustum)
    translate([0, 0, spout_height])
        cylinder(h = cone_height, r1 = cone_top_radius, r2 = cone_bottom_radius, center = false);
    
    // Inner spout (hole)
    translate([0, 0, -0.01])
        cylinder(h = spout_height + 0.02, r = spout_inner_radius, center = false);
    
    // Inner cone (hole)
    translate([0, 0, spout_height - 0.01])
        cylinder(h = cone_height + 0.02, r1 = cone_top_inner_radius, r2 = cone_bottom_inner_radius, center = false);
}

funnel();