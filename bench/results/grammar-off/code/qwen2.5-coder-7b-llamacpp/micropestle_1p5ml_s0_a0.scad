// Dimensions
handle_diameter = 8;
handle_height = 45;
cone_height = 17;
cone_bottom_diameter = 8;
cone_top_diameter = 3;
tip_diameter = 3;
tip_height = 0;
groove_width = 2;
groove_depth = 1;
groove_spacing = 15;

// Functions
cylinder_with_grooves(d, h, groove_width, groove_depth, groove_spacing) {
    cylinder(d = d, h = h) -
    for (i = [0:groove_spacing:h - groove_spacing]) {
        cylinder(d = d + groove_width, h = groove_depth) -
        cylinder(d = d, h = groove_depth)
    }
}

// Model
handle = cylinder_with_grooves(handle_diameter, handle_height, groove_width, groove_depth, groove_spacing);
cone = cylinder_with_grooves(cone_bottom_diameter, cone_height, groove_width, groove_depth, groove_spacing) -
       cylinder_with_grooves(cone_top_diameter, cone_height, groove_width, groove_depth, groove_spacing);
tip = sphere(d = tip_diameter);

// Combine parts
pestle = handle + translate([0, 0, handle_height]) * cone + translate([0, 0, handle_height + cone_height]) * tip;

// Render
pestle;