// Dimensions of the sowing template for a 90mm Petri dish
$fn = 64;

// Main disc parameters
DISC_DIAMETER = 85;
DISC_THICKNESS = 2;

// Hole grid parameters (7x7)
HOLE_DIA = 3; // Diameter of each hole
HOLE_SPACING = 9; // Centre-to-centre spacing between holes

// Notch parameters (on +Y side)
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

// Calculate half-widths and offsets for centering
half_disc_x = DISC_DIAMETER / 2;
half_disc_y = DISC_DIAMETER / 2;
hole_radius = HOLE_DIA / 2;
hole_offset_x = (HOLE_SPACING * 6) / 2 + hole_radius; // Extra offset for centering
hole_offset_y = (HOLE_SPACING * 6) / 2 + hole_radius;

module sowing_template() {
    // Main disc
    difference() {
        circle(d=DISC_DIAMETER, center=[0, 0]) |>
        translate([0, -NOTCH_DEPTH/2])
        rotate([90, 0, 0])
        polygon(points=[
            [-half_disc_x + NOTCH_WIDTH/2, half_disc_y],
            [half_disc_x + NOTCH_WIDTH/2, half_disc_y],
            [half_disc_x, -NOTCH_DEPTH/2],
            [half_disc_x, half_disc_y]
        ])
    } |>
    linear_extrude(height=DISC_THICKNESS)();

    // Hole grid
    for (y in range(-6, 7)) {
        for (x in range(-6, 7)) {
            translate([hole_offset_x + x * HOLE_SPACING - hole_radius,
                      hole_offset_y + y * HOLE_SPACING - hole_radius]) {
                circle(d=HOLE_DIA) |>
                linear_extrude(height=-DISC_THICKNESS/2)
                circle(d=HOLE_DIA) |>
                linear_extrude(height=DISC_THICKNESS/2);
            }
        }
    }
}

// Render the template
sowing_template();