// Lab Funnel Design
// Wall thickness: 1.6 mm
// Spout: 10 mm outer diameter, 20 mm tall (z = 0 to z = 20)
// Cone: 10 mm outer diameter at z = 20, 60 mm outer diameter at z = 50

$fn = 64;

wall_thickness = 1.6;
spout_height = 20;
spout_outer_diameter = 10;
spout_inner_diameter = spout_outer_diameter - 2 * wall_thickness;
cone_height = 30; // from z=20 to z=50
cone_top_diameter = spout_outer_diameter;
cone_bottom_diameter = 60;

// Spout (cylinder with hole)
module spout() {
    difference() {
        cylinder(h = spout_height + 0.01, d = spout_outer_diameter, center = false);
        translate([0, 0, -0.01]) 
            cylinder(h = spout_height + 0.02, d = spout_inner_diameter, center = false);
    }
}

// Cone (frustum with hole)
module cone() {
    translate([0, 0, spout_height]) {
        difference() {
            // Outer cone
            cylinder(h = cone_height + 0.01, 
                     r1 = cone_top_diameter / 2, 
                     r2 = cone_bottom_diameter / 2, 
                     center = false);
            // Inner cone (smaller by wall_thickness)
            translate([0, 0, -0.01]) 
                cylinder(h = cone_height + 0.02, 
                         r1 = (cone_top_diameter - 2 * wall_thickness) / 2, 
                         r2 = (cone_bottom_diameter - 2 * wall_thickness) / 2, 
                         center = false);
        }
    }
}

// Build the funnel
spout();
cone();