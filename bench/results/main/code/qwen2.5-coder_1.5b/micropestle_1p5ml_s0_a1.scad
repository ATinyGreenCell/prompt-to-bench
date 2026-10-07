// Define dimensions
$fn = 64; // For curved shapes

// Cylindrical handle
handle_diameter = 8;
handle_height = 45;
handle_radius = handle_diameter / 2;

// Cone
cone_diameter = 8;
cone_height = 17;
cone_radius = cone_diameter / 2;

// Rounded tip
tip_diameter = 3;
tip_radius = tip_diameter / 2;

// Handle grooves
groove_width = 2;
groove_depth = 1;
num_grooves = 4;

// Create the handle
handle = cylinder(d=handle_diameter, h=handle_height, r=handle_radius);

// Create the cone
cone = cylinder(d=cone_diameter, h=cone_height, r=cone_radius);

// Create the tip
tip = sphere(r=tip_radius);

// Create the grooves in the handle
for (i = [0:num_grooves-1]) {
    groove_x = 10 + i * groove_width;
    groove_y = 0;
    translate([groove_x, groove_y, 10]) rotate([90, 0, 0]) difference() {
        cylinder(d=handle_diameter, h=handle_height - groove_depth, r=handle_radius);
        cylinder(d=tip_diameter, h=groove_depth, r=tip_radius);
    }
}

// Combine all parts
final_part = union() {
    handle,
    cone,
    tip,
    translate([0, 0, 62]) rotate([90, 0, 0]) difference() {
        cylinder(d=handle_diameter, h=handle_height - groove_depth, r=handle_radius);
        cylinder(d=tip_diameter, h=groove_depth, r=tip_radius);
    }
};

// Render the final part
render(final_part);