// Lab Funnel Design Parameters
spout_outer_diameter = 10;   // mm, outer diameter of the spout
spout_length = 20;           // mm, length of the spout from z=0 to z=20
cone_outer_diameter = 60;    // mm, outer diameter of the cone at the rim
cone_length = 30;             // mm, length of the cone from z=20 to z=50
wall_thickness = 1.6;       // mm, thickness of the funnel walls
bore_diameter = spout_outer_diameter - 2 * wall_thickness; // mm, bore diameter of the spout

// Create the spout (tube) with bore
spout_bore_radius = bore_diameter / 2;
spout_outer_radius = spout_outer_diameter / 2;

spout = difference() {
    // Outer cylinder of the spout
    cylinder(r = spout_outer_radius, h = spout_length, $fn = 64);
    // Inner bore of the spout
    cylinder(r = spout_bore_radius, h = spout_length, $fn = 64);
}

// Create the cone with wall thickness
cone_outer_radius = cone_outer_diameter / 2;
cone_inner_radius = (cone_outer_diameter - 2 * wall_thickness) / 2;

// Cone shape with outer and inner radii
cone = linear_extrude(height = cone_length, $fn = 64) {
    difference() {
        // Outer cone
        circle(r = cone_outer_radius);
        // Inner cone (cutting shape)
        translate([0, 0, cone_length]) {
            circle(r = cone_inner_radius);
        }
    }
}

// Combine spout and cone
funnel = union() {
    spout;
    translate([0, 0, spout_length]) {
        cone;
    }
}

// Final funnel with open top and bottom
final_funnel = difference() {
    funnel;
    // Open the top of the cone
    translate([0, 0, spout_length + cone_length]) {
        cylinder(r = cone_outer_radius, h = 0.01, $fn = 64);
    }
    // Open the bottom of the spout
    cylinder(r = spout_bore_radius, h = 0.01, $fn = 64);
}

// Center the funnel on the origin
translate([-(spout_outer_diameter / 2), -(spout_outer_diameter / 2), 0]) {
    final_funnel;
}