// Dimensions for pestle in millimetres
$fn = 64;

// Handle dimensions
handle_diameter = 8;
handle_height = 45;

// Cone dimensions (from top of handle to rounded tip)
cone_start_radius = handle_diameter / 2; // 4 mm
cone_end_radius = 3 / 2;                // 1.5 mm
cone_total_height = cone_start_radius * 2 - cone_end_radius * 2;
cone_height = 62 - 45;

// Rounded tip (sphere)
tip_radius = 3 / 2; // 1.5 mm

// Groove dimensions for grip
groove_width = 2;
groove_depth = 1;
groove_z_positions = [10, 15, 20, 25];
groove_arc_length = 90; // degrees (for quarter-circle approximation)

module handle() {
    cylinder(diameter=handle_diameter, height=handle_height);
}

module cone() {
    translate([0, 0, -cone_start_radius]) {
        rotate(45) {
            linear_extrude(height=cone_total_height * 2) {
                polygon(points=[[0, 0], [cone_end_radius, 0],
                              [cone_end_radius, cone_end_radius * 2],
                              [0, cone_end_radius * 2]]);
            }
        }
    }
}

module tip() {
    sphere(radius=tip_radius);
}

// Create grooves
module groove() {
    translate([0, 0, z_pos]) {
        rotate(45) {
            linear_extrude(height=groove_depth) {
                polygon(points=[[0, -groove_width/2], [groove_width, -groove_width/2],
                              [groove_width, groove_width/2], [0, groove_width/2]]);
            }
        }
    }
}

// Combine all parts
pestle = difference() {
    union() {
        handle();
        translate([0, 0, 45]) cone();
        translate([0, 0, 62 - tip_radius]) tip();
    }

    // Cut grooves for grip
    for (z in groove_z_positions) {
        groove(z);
    }
};