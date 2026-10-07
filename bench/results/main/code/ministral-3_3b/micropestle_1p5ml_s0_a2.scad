// Pestle dimensions for 1.5 mL tube (all in mm)
$fn = 256;

// Handle
handle_diameter = 8;
handle_height = 45;

// Cone
cone_start_radius = handle_diameter/2; // 4mm
cone_end_radius = 3/2;                // 1.5mm
cone_height = (cone_start_radius - cone_end_radius) * 2 + 0.5; // Extra for extrusion

// Tip
tip_radius = 3/2;

// Grooves
num_grooves = 4;
groove_z_positions = [10, 15, 20, 25];
groove_width = 2;
groove_depth = 1;
groove_angle = 90; // 90 degree arc

module pestle() {
    difference() {
        union() {
            // Handle
            cylinder(diameter=handle_diameter, height=handle_height)

            // Cone
            translate([0, 0, handle_height]) {
                rotate(45) {
                    linear_extrude(height=cone_height) {
                        polygon(points=[
                            [0, -cone_start_radius],
                            [cone_end_radius, -cone_start_radius],
                            [cone_end_radius, cone_end_radius],
                            [0, cone_end_radius]
                        ]);
                    }
                }
            }

            // Tip
            translate([0, 0, handle_height + cone_height]) {
                sphere(radius=tip_radius)
            }
        }

        // Grooves
        for (z in groove_z_positions) {
            translate([0, 0, z])
            rotate(45)
            linear_extrude(height=groove_depth) {
                polygon(points=[
                    [-groove_width/2, -groove_width],
                    [groove_width/2, -groove_width],
                    [groove_width/2, groove_width/2],
                    [-groove_width/2, groove_width/2]
                ]);
            }
        }
    }
}