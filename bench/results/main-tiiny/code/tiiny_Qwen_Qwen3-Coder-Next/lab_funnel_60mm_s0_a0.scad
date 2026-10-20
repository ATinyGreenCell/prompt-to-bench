// Lab Funnel Design
// Wall thickness: 1.6 mm
// Spout: 10 mm outer diameter, 20 mm tall (z = 0 to z = 20)
// Cone: expands from 10 mm outer diameter at z = 20 to 60 mm outer diameter at z = 50
// Open at top and bottom for liquid flow

$fn = 64;

// Dimensions
wall_thickness = 1.6;
spout_outer_diameter = 10;
spout_height = 20;
cone_top_diameter = 10;
cone_bottom_diameter = 60;
cone_height = 30; // from z=20 to z=50

// Calculate inner diameters
spout_inner_diameter = spout_outer_diameter - 2 * wall_thickness;
cone_top_inner_diameter = cone_top_diameter - 2 * wall_thickness;
cone_bottom_inner_diameter = cone_bottom_diameter - 2 * wall_thickness;

// Spout (outer cylinder)
module spout_outer() {
    translate([0, 0, 0])
    cylinder(h = spout_height, d = spout_outer_diameter, center = false);
}

// Spout (inner cylinder - for hollowing)
module spout_inner() {
    translate([0, 0, -0.01])
    cylinder(h = spout_height + 0.02, d = spout_inner_diameter, center = false);
}

// Cone (outer cone)
module cone_outer() {
    translate([0, 0, spout_height])
    cylinder(h = cone_height, 
             d1 = cone_top_diameter, 
             d2 = cone_bottom_diameter, 
             center = false);
}

// Cone (inner cone - for hollowing)
module cone_inner() {
    translate([0, 0, spout_height - 0.01])
    cylinder(h = cone_height + 0.02, 
             d1 = cone_top_inner_diameter, 
             d2 = cone_bottom_inner_diameter, 
             center = false);
}

// Build the funnel
module funnel() {
    // Outer shape: spout + cone
    union() {
        spout_outer();
        cone_outer();
    }
    
    // Subtract inner hollow
    difference() {
        union() {
            spout_outer();
            cone_outer();
        }
        spout_inner();
        cone_inner();
    }
}

funnel();