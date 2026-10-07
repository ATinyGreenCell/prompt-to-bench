// Dimensions of the sowing template for a 90mm Petri dish
$fn = 64;

// Main disc parameters
DISC_DIAMETER = 85;
DISC_THICKNESS = 2;

// Hole grid parameters (7x7)
HOLE_DIA = 3; // Diameter of each hole
HOLE_SPACING = 9; // Centre-to-centre spacing between holes

// Notch parameters (+Y side, centered on Y axis)
NOTCH_WIDTH_X = 10;
NOTCH_DEPTH_Y = 4;

// Calculate offsets and positions
half_disc = DISC_DIAMETER / 2;
hole_radius = HOLE_DIA / 2;
center_offset_x = (HOLE_SPACING * 6) + hole_radius; // Extra offset for centering

module sowing_template() {
    // Main disc with notch cutout
    difference() {
        circle(d=DISC_DIAMETER, center=[0, 0]) |>
        translate([0, -NOTCH_DEPTH_Y/2])
        rotate([90, 0, 0])
        polygon(points=[
            [-half_disc + NOTCH_WIDTH_X/2, half_disc],
            [half_disc + NOTCH_WIDTH_X/2, half_disc],
            [half_disc, -NOTCH_DEPTH_Y/2]
        ])
    } |>
    linear_extrude(height=DISC_THICKNESS)();

    // Hole grid
    for (y in range(-6, 7)) {
        translate([-center_offset_x + y * HOLE_SPACING,
                  -hole_radius + y * HOLE_SPACING]) {
            circle(d=HOLE_DIA) |>
            linear_extrude(height=-DISC_THICKNESS/2)
            circle(d=HOLE_DIA) |>
            linear_extrude(height=DISC_THICKNESS/2);
        }
    }
}

// Render the template
sowing_template();