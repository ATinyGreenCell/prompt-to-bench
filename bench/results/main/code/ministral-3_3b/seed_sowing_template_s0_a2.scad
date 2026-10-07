// Dimensions of the sowing template for a 90mm Petri dish
$fn = 64;

// Main disc parameters
DISC_DIAMETER = 85;
DISC_THICKNESS = 2;

// Hole grid (7x7) parameters
HOLE_DIA = 3; // Diameter of each hole
HOLE_SPACING_CENTRE = 9; // Centre-to-centre spacing between holes

// Notch dimensions (+Y side, centered on Y axis)
NOTCH_WIDTH_X = 10;
NOTCH_DEPTH_Y = 4;

// Calculate positions and offsets for centering
half_disc_radius = DISC_DIAMETER / 2;
hole_center_offset_x = (HOLE_SPACING_CENTRE * 6) + HOLE_DIA/2; // Extra offset

module sowing_template() {
    // Main disc with notch cutout
    difference() {
        circle(d=DISC_DIAMETER, center=[0, 0]) |>
        translate([0, -NOTCH_DEPTH_Y])
        rotate([90, 0, 0])
        polygon(points=[
            [-half_disc_radius + NOTCH_WIDTH_X/2, half_disc_radius],
            [half_disc_radius + NOTCH_WIDTH_X/2, half_disc_radius],
            [half_disc_radius, -NOTCH_DEPTH_Y]
        ])
    } |>
    linear_extrude(height=DISC_THICKNESS)();

    // Hole grid
    for (y in range(-6, 7)) {
        translate([-hole_center_offset_x + y * HOLE_SPACING_CENTRE,
                  -HOLE_DIA/2 + y * HOLE_SPACING_CENTRE]) {
            circle(d=HOLE_DIA) |>
            linear_extrude(height=-DISC_THICKNESS/2)
            circle(d=HOLE_DIA) |>
            linear_extrude(height=DISC_THICKNESS/2);
        }
    }
}

// Render the template
sowing_template();