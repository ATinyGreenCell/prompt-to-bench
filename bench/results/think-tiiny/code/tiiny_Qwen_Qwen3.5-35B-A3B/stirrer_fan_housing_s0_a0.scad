// Dimensions
outer_size = 90;
wall_thickness = 2.5;
top_thickness = 2;
box_height = 40;
screw_hole_dia = 4.5;
screw_pattern = 71.5;
notch_width = 12;
notch_depth = 8;

// Calculated Dimensions
half_outer = outer_size / 2;
half_wall_thickness = wall_thickness / 2;
half_screw_pattern = screw_pattern / 2;
half_notch_width = notch_width / 2;
notch_start_z = box_height - notch_depth;
notch_end_z = box_height;
wall_start_z = top_thickness;
wall_end_z = box_height;
wall_height = wall_end_z - wall_start_z;
screw_hole_radius = screw_hole_dia / 2;
screw_hole_z_end = top_thickness + 0.1;
screw_hole_z_start = -0.1;

// Notch Cutter Dimensions
notch_cutter_y_start = -half_outer - 1;
notch_cutter_y_end = -half_outer + half_wall_thickness - 0.5;
notch_cutter_x_start = -half_notch_width;
notch_cutter_x_end = half_notch_width;
notch_cutter_z_start = notch_start_z;
notch_cutter_z_end = notch_end_z;

// Screw Hole Positions
screw_hole_positions = [
    [-half_screw_pattern, -half_screw_pattern],
    [half_screw_pattern, -half_screw_pattern],
    [-half_screw_pattern, half_screw_pattern],
    [half_screw_pattern, half_screw_pattern]
];

$fn = 64;

module main() {
    // Base Plate (Top Plate)
    base_plate = cube([outer_size, outer_size, top_thickness], center=[0, 0, top_thickness/2]);

    // Walls
    wall_front = translate([0, -half_outer - half_wall_thickness, wall_start_z + wall_height/2])
                 cube([outer_size, wall_thickness, wall_height], center=[0, 0, 0]);
    wall_back = translate([0, half_outer + half_wall_thickness, wall_start_z + wall_height/2])
                cube([outer_size, wall_thickness, wall_height], center=[0, 0, 0]);
    wall_left = translate([-half_outer - half_wall_thickness, 0, wall_start_z + wall_height/2])
                cube([wall_thickness, outer_size, wall_height], center=[0, 0, 0]);
    wall_right = translate([half_outer + half_wall_thickness, 0, wall_start_z + wall_height/2])
                 cube([wall_thickness, outer_size, wall_height], center=[0, 0, 0]);

    // Screw Holes
    screw_holes = [
        for (pos = screw_hole_positions)
            translate(pos)
                cylinder(h=screw_hole_z_end - screw_hole_z_start, r=screw_hole_radius, center=[0, 0, (screw_hole_z_end + screw_hole_z_start)/2])
    ];

    // Cable Notch Cutter
    notch_cutter = cube([notch_width, notch_cutter_y_end - notch_cutter_y_start, notch_end_z - notch_start_z],
                        center=[0, (notch_cutter_y_end + notch_cutter_y_start)/2, (notch_end_z + notch_start_z)/2]);

    // Union of Base and Walls
    box_structure = union() {
        base_plate;
        wall_front;
        wall_back;
        wall_left;
        wall_right;
    };

    // Union of Cutters
    cutters = union() {
        for (hole = screw_holes) {
            hole;
        }
        notch_cutter;
    };

    // Final Difference
    difference() {
        box_structure;
        cutters;
    }
}

main();