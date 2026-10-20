// Dimensions for the sowing template
$fn = 64; // For curved shapes to ensure smooth holes

// Main disc dimensions
disc_diameter = 85; // Diameter of the flat disc in mm
disc_thickness = 2; // Thickness of the disc in mm

// Grid parameters
grid_rows = 7; // Number of rows in the grid
grid_cols = 7; // Number of columns in the grid
hole_diameter = 3; // Diameter of each through-hole in mm
spacing = 9; // Centre-to-centre spacing between holes in mm

// Notch dimensions
notch_width = 10; // Width of the notch in X direction
notch_depth = 4; // Depth of the notch in Y direction
notch_position_offset = (disc_diameter / 2 - spacing / 2) - (notch_width / 2); // X offset to center the notch on Y axis

// Create the main disc
disc = cylinder(r = disc_diameter / 2, h = disc_thickness, $fn = 64);

// Create the grid of holes
holes = union() for (i = [0:grid_rows-1]) for (j = [0:grid_cols-1]) {
    translate([spacing/2 + j * spacing, spacing/2 + i * spacing, 0])
        cylinder(r = hole_diameter / 2, h = disc_thickness, $fn = 64);
}

// Create the notch
notch = cube([notch_width, notch_depth, disc_thickness], center=true)
    - cube([notch_width, notch_depth, 0.1], center=true); // Subtract a small cube to avoid coplanar faces

// Combine the disc with the holes and notch
template = difference() {
    disc;
    holes;
    translate([notch_position_offset, 0, 0]) notch;
}

// Final output
template;