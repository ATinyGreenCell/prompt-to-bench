// Dimensions in millimetres
handle_diameter = 8;  // Diameter of the cylindrical handle
handle_height = 45;   // Height of the cylindrical handle
cone_height = 17;     // Height of the cone
cone_bottom_diameter = 8;  // Diameter of the cone at the base
cone_top_diameter = 3;     // Diameter of the cone at the top
tip_diameter = 3;     // Diameter of the rounded tip
groove_width = 2;     // Width of each circumferential groove
groove_depth = 1;     // Depth of each circumferential groove
groove_positions = [10, 15, 20, 25];  // Z positions of the grooves

$fn = 64;  // Number of facets for curved shapes

// Cylindrical handle
handle = cylinder(h = handle_height, d = handle_diameter, center = false);

// Cone
cone = translate([0, 0, handle_height])
       cylinder(h = cone_height, d1 = cone_bottom_diameter, d2 = cone_top_diameter, center = false);

// Rounded tip
tip = translate([0, 0, handle_height + cone_height])
      sphere(d = tip_diameter, center = true);

// Grooves
grooves = union() {
    for (z = groove_positions) {
        translate([0, 0, z])
        rotate_extrude()
        translate([handle_diameter/2 - groove_width/2, 0])
        square([groove_width, groove_depth]);
    }
};

// Final assembly
difference() {
    union() {
        handle;
        cone;
        tip;
    }
    translate([0, 0, -0.01]) // Ensure grooves extend slightly below the handle
    grooves;
}