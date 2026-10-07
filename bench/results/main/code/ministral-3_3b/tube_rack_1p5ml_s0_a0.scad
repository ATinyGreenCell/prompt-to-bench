// Dimensions of the bench rack (mm)
$fn = 64;
X = 106; // Length
Y = 72;  // Width
Z = 30;  // Height

// Hole parameters
hole_diameter = 11.2;
hole_depth = 25;
floor_height = 5;

// Calculate hole spacing (centre-to-centre)
spacing_X = 16;
spacing_Y = 16;

// Create the solid block
block = difference(
    cube([X, Y, Z]),
    [
        // Vertical holes (4 rows × 6 columns)
        for (y in [0..3]) {
            for (x in [0..5]) {
                translate([(x * spacing_X + spacing_X / 2) - X/2, (y * spacing_Y + spacing_Y / 2) - Y/2, 0])
                cylinder(
                    r = hole_diameter / 2,
                    h = floor_height,
                    $fn = 64
                )
            }
        },
        // Cut the bottom floor to create holes
        translate([0, 0, Z - floor_height])
        cylinder(
            r = hole_diameter / 2 + 1, // Extend slightly beyond hole diameter for clean cut
            h = floor_height,
            $fn = 64
        )
    ]
);

// Subtract the remaining cylindrical parts of holes (to close bottom)
for (y in [0..3]) {
    for (x in [0..5]) {
        translate([(x * spacing_X + spacing_X / 2) - X/2, (y * spacing_Y + spacing_Y / 2) - Y/2, Z])
        cylinder(
            r = hole_diameter / 2,
            h = hole_depth - floor_height,
            $fn = 64
        )
    }
}

bench_rack = block;