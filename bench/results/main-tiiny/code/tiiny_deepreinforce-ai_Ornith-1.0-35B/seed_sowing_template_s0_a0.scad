// Sowing template for 90 mm Petri dish
// Disc: 85 mm diameter, 2 mm thick
// Grid: 7x7 holes, 3 mm diameter, 9 mm pitch, centred
// Notch: 10 mm wide (X), 4 mm deep (Y), on +Y side, centred on Y axis

// --- Dimensions ---
disc_diameter = 85;          // mm, overall disc diameter
disc_thickness = 2;          // mm, disc thickness
hole_diameter = 3;           // mm, through-hole diameter
grid_count = 7;              // number of holes per row/column
grid_pitch = 9;            // mm, centre-to-centre spacing between holes
notch_width = 10;            // mm, width of notch along X
notch_depth = 4;           // mm, depth of notch along -Y (in from rim)

// --- Derived values ---
disc_radius = disc_diameter / 2;
half_pitch = (grid_count - 1) * grid_pitch / 2;
half_notch_width = notch_width / 2;
half_notch_depth = notch_depth / 2;

// --- Build the disc ---
disc = cylinder(d = disc_diameter, h = disc_thickness, center = false, $fn = 128);

// --- Build the grid of holes ---
grid_holes = [];
for (i = [0 : grid_count - 1]) {
    for (j = [0 : grid_count - 1]) {
        x = (i - (grid_count - 1) / 2) * grid_pitch;
        y = (j - (grid_count - 1) / 2) * grid_pitch;
        grid_holes = concat(grid_holes, [translate([x, y, 0])
            cylinder(d = hole_diameter, h = disc_thickness + 0.1, center = false, $fn = 64)]);
    }
}

// --- Build the orientation notch ---
// The notch is cut from the +Y rim, centred on the Y axis.
// It removes material from y = (disc_radius - notch_depth) to y = disc_radius,
// and from x = -half_notch_width to x = +half_notch_width.
notch_cut = cube([notch_width + 0.1, notch_depth + 0.1, disc_thickness + 0.1],
    center = [0, disc_radius - notch_depth / 2, disc_thickness / 2]);

// --- Assemble: disc minus holes minus notch ---
sowing_template = difference() {
    disc;
    for (h = grid_holes) {
        h;
    }
    notch_cut;
};

sowing_template;