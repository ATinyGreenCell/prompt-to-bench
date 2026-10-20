$fn = 64;

// Dimensions
handle_diameter = 8;
handle_height = 45;
shaft_start_z = 45;
shaft_end_z = 62;
shaft_bottom_diameter = 8;
shaft_top_diameter = 3;
tip_diameter = 3;
tip_center_z = 62;
groove_z_positions = [10, 15, 20, 25];
groove_width_z = 2;
groove_depth = 1;

// Handle
handle = cylinder(h=handle_height, d=handle_diameter, center=false);

// Shaft
shaft_height = shaft_end_z - shaft_start_z;
shaft_bottom_radius = shaft_bottom_diameter / 2;
shaft_top_radius = shaft_top_diameter / 2;
shaft = cylinder(h=shaft_height, r1=shaft_bottom_radius, r2=shaft_top_radius, center=false);

// Tip
tip_radius = tip_diameter / 2;
tip = sphere(r=tip_radius, center=false);

// Positive Geometry
positive_part = union() {
    handle;
    shaft;
    tip;
};

// Grooves
grooves = union() {
    for (z = groove_z_positions) {
        // Create a rectangular block representing the groove segment
        // Dimensions: 2mm long (axial), 1mm wide (radial), 1mm deep (into cylinder)
        groove_segment = cube([groove_width_z, groove_depth, groove_depth]);
        // Rotate extrude to make it circumferential
        groove_ring = rotate_extrude(360) groove_segment;
        // Translate to the surface of the cylinder (radius = handle_diameter/2)
        translate([handle_diameter/2, 0, z]) groove_ring;
    }
};

// Final Part
part = difference() {
    positive_part;
    grooves;
};

// Render
part;