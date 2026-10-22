// Dimensions (mm)
base_length = 203;
base_width = 80;
base_height = 20;

cradle_radius = 46;
cradle_axis_y = 0;
cradle_axis_z = 52;

divider_thickness = 3;
divider_height = 60;
num_dividers = 11;
slot_width = 17;

$fn = 64;

// Base block
base = cube([base_length, base_width, base_height], center = true);

// Cradle cut: cylinder along X axis
// The cylinder axis is at (y=0, z=52), radius 46.
// It extends along the entire length of the base.
cradle_cut = cylinder(r = cradle_radius, h = base_length + 2, center = true, $fn = 64);

// Dividers
dividers = union() {
    for (i = [0 : num_dividers - 1]) {
        x_pos = -100 + i * 20;
        translate([x_pos, 0, base_height / 2])
            cube([divider_thickness, base_width, divider_height], center = true);
    }
};

// Final part
difference() {
    union() {
        base;
        dividers;
    }
    // Rotate cradle cut to align with X axis
    rotate([90, 0, 0])
        translate([0, cradle_axis_y, cradle_axis_z])
        cradle_cut;
}