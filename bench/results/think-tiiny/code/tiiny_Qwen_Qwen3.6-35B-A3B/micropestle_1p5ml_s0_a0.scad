$fn = 64;

// Handle dimensions
handle_diam = 8;
handle_height = 45;

// Cone dimensions
cone_bottom_diam = 8;
cone_top_diam = 3;
cone_height = 17; // 62 - 45

// Tip dimensions
tip_diam = 3;
tip_center_z = 62;

// Groove dimensions
groove_width = 2;
groove_depth = 1;
groove_centers = [10, 15, 20, 25];

// Build main part
part = union() {
    // Cylindrical handle
    cylinder(d=handle_diam, h=handle_height, center=false);
    // Tapered cone
    cylinder(d1=cone_bottom_diam, d2=cone_top_diam, h=cone_height, center=false);
    // Rounded tip
    translate([0, 0, tip_center_z]) sphere(r=tip_diam/2, center=false);
};

// Groove cut shape (ring)
outer_d = handle_diam + 2 * groove_depth;
inner_d = handle_diam;
h_cut = groove_width + 0.02; // Extends 0.01 past each face
groove_cut_shape = difference() {
    cylinder(d=outer_d, h=h_cut, center=false);
    cylinder(d=inner_d, h=h_cut + 0.01, center=false);
};

// Final part with grooves
difference() {
    part;
    for (z in groove_centers) {
        translate([0, 0, z]) groove_cut_shape;
    }
}