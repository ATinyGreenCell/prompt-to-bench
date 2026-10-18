// Rack for six 50 mL conical (Falcon-type) tubes.
// Print orientation: Flat plate on bed (z=0), walls rising to z=70.
// After printing, flip over so walls are on the bed and tubes hang down.

// Plate dimensions
L     = 130; // Length (X)
W     = 90;  // Width (Y)
t     = 4;   // Plate thickness (Z)

// Hole specifications
n_holes = 6;
hole_d  = 30.5;

// Grid layout
row_spacing = 40; // Centre-to-centre Y
col_spacing = 40; // Centre-to-centre X

// Wall specifications
wall_h = 70; // Height of walls from plate top (z=4)
wall_t = 4;  // Thickness of walls (Y)

// Derived positions
// Centred on origin in X and Y
x_offset = (n_holes / 2 - 0.5) * col_spacing;
y_offset = (2 / 2 - 0.5) * row_spacing;

// Calculate specific hole positions
hole_positions = [
    [x_offset, y_offset],
    [x_offset, -y_offset],
    [-x_offset, y_offset],
    [-x_offset, -y_offset],
    [0, y_offset],
    [0, -y_offset]
];

$fn = 64;

module tube_hole(x, y) {
    translate([x, y, 0]) cylinder(h = t + 1, d = hole_d);
}

difference() {
    union() {
        // 1. The flat base plate
        translate([-L / 2, -W / 2, 0]) cube([L, W, t]);

        // 2. The two side walls
        // Left wall (at -L/2)
        translate([-L / 2, -W / 2, t]) cube([wall_t, W, wall_h]);
        // Right wall (at +L/2)
        translate([L / 2 - wall_t, -W / 2, t]) cube([wall_t, W, wall_h]);
    }

    // Cut the holes for the tubes
    for (p = hole_positions) {
        tube_hole(p[0], p[1]);
    }
}