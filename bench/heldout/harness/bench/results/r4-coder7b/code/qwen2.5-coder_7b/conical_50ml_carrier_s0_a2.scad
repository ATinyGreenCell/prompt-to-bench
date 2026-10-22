// Dimensions
base_width = 90;
base_height = 90;
base_depth = 35;

seat_diameter = 30.5;
seat_depth = 30;
floor_thickness = 5;

post_width = 10;
post_height = 16;
post_hole_size = 10.4;

handle_length = 100;
handle_gap = 10;

// Base block
base = cube([base_width, base_height, base_depth]);

// Seats
seat_radius = seat_diameter / 2;
seats = union() {
    for (i = [-1, 1]) {
        translate([i * (base_width - seat_diameter), 0, 0])
            cylinder(r = seat_radius, h = seat_depth + floor_thickness, center = true);
    }
};

// Posts
post = difference() {
    cube([post_width, post_height, post_width]);
    translate([0, post_hole_size / 2, 0])
        cube([post_width, post_hole_size, post_width]);
};
posts = union() {
    translate([-base_width / 2 + post_width / 2, 0, 0]) post;
    translate([base_width / 2 - post_width / 2, 0, 0]) post;
};

// Base with seats and posts
base_with_features = difference(base, seats) + posts;

// Handle
handle = cube([handle_length, handle_gap, handle_length]);

// Final model
model = union() {
    translate([0, base_height - handle_gap / 2, 0]) base_with_features;
    translate([-handle_length / 2, base_height - handle_gap / 2 + handle_gap, 0]) handle;
};

// Render the model
model;