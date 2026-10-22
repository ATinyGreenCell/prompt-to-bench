// Dimensions
diameter_puck = 80;
height_puck = 26;
cut_off_x = 34;
tube_diameter = 11.2;
seat_depth = 20;
half_sphere_radius = tube_diameter / 2;

// Puck with cut-off side
puck = cylinder(h = height_puck, r = diameter_puck / 2);
cut_off_side = translate([cut_off_x, 0, 0]) * rotate_extrude() * polygon(points = [ [-diameter_puck/2, -diameter_puck/2], [diameter_puck/2, -diameter_puck/2], [diameter_puck/2, diameter_puck/2], [-diameter_puck/2, diameter_puck/2] ], paths = [[0, 1, 2, 3]]);
puck_with_cut_off = difference() {
    puck;
    translate([cut_off_x, 0, 0]) * cylinder(h = height_puck + 1, r = diameter_puck / 2);
    cut_off_side;
};

// Seats for tubes
seat_positions = [
    [tube_diameter / 2, 0],
    [diameter_puck / 4, tube_diameter / 2],
    [-diameter_puck / 4, tube_diameter / 2],
    [-tube_diameter / 2, 0],
    [-diameter_puck / 4, -tube_diameter / 2],
    [diameter_puck / 4, -tube_diameter / 2]
];

seats = union() {
    for (pos = seat_positions) {
        translate(pos + [0, 0, half_sphere_radius]) * rotate_extrude($fn = 64) * cylinder(h = seat_depth + 1, r = tube_diameter / 2);
    }
};

// Final model
final_model = difference() {
    puck_with_cut_off;
    seats;
};

// Render the model
render(final_model);