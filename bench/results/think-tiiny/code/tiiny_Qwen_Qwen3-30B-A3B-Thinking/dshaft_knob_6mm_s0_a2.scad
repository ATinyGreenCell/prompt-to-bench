$fn = 64;

// Dimensions in millimeters
knob_diameter = 30;
knob_radius = knob_diameter / 2;
knob_height = 15;
hole_diameter = 6.2;
hole_radius = hole_diameter / 2;
hole_depth = 12;
flat_to_opposite = 4.7;
chord_distance_from_center = flat_to_opposite - hole_radius;
cut_box_x_size = chord_distance_from_center - 0.01 + hole_radius;
cut_box_y_size = hole_diameter;
cut_box_z_size = hole_depth;
grip_groove_diameter = 2;
grip_groove_radius = grip_groove_diameter / 2;
grip_groove_placement_radius = knob_radius - grip_groove_radius;
num_grip_grooves = 18;
pointer_groove_width = 1.5;
pointer_groove_depth = 1;

// Main knob cylinder (bottom at z=0, height=15mm)
knob = cylinder(h = knob_height, r = knob_radius, center = false);

// D-shaped hole (blind bore, 12mm deep, flat on positive X side)
hole = difference() {
    cylinder(h = hole_depth, r = hole_radius, center = false);
    translate([ -hole_radius, -hole_radius, 0 ])
        cube([ cut_box_x_size, cut_box_y_size, cut_box_z_size ]);
};

// Assemble final part by subtracting hole, grip grooves, and pointer groove from knob
difference() {
    knob;
    hole;
    for (i = [0 : num_grip_grooves - 1]) {
        rotate([0, 0, i * (360 / num_grip_grooves)])
            translate([ grip_groove_placement_radius, 0, 0 ])
                cylinder(h = knob_height, r = grip_groove_radius, center = false);
    }
    translate([0, -pointer_groove_width / 2, knob_height - pointer_groove_depth])
        cube([ knob_radius, pointer_groove_width, pointer_groove_depth ]);
}