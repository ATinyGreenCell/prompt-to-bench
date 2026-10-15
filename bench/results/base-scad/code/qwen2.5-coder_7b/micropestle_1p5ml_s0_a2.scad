// Dimensions in millimeters
handle_diameter = 8;
handle_height = 45;
cone_height = 17;
tip_radius = 3;
groove_width = 2;
groove_depth = 1;
groove_positions = [10, 15, 20, 25];

// Handle cylinder
handle = cylinder(d = handle_diameter, h = handle_height);

// Cone
cone = cylinder(d1 = handle_diameter, d2 = tip_radius * 2, h = cone_height, center = true) + 
      translate([0, 0, handle_height]) * rotate_extrude($fn = 64) (circle(r = tip_radius));

// Tip sphere
tip = sphere(r = tip_radius);

// Grooves in the handle
grooves = union() {
    for (z = groove_positions) {
        cylinder(d1 = handle_diameter, d2 = handle_diameter - groove_depth, h = groove_width, center = true) + 
        translate([0, 0, z]) * rotate_extrude($fn = 64) (circle(r = handle_diameter / 2));
    }
};

// Final model
pestle = handle + cone + tip - grooves;

// Center the model on the origin
translate([-handle_diameter / 2, -handle_diameter / 2, 0]) pestle;