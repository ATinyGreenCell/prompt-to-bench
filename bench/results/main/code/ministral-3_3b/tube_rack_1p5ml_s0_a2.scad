// Bench rack for 1.5 mL microcentrifuge tubes (mm)
$fn = 64;

// Dimensions and hole parameters
X = 106;       // Length
Y = 72;        // Width
Z = 30;        // Height
hole_diameter = 11.2;
spacing_X = 16;
spacing_Y = 16;
hole_depth = 25;
floor_height = Z - hole_depth;

module tube_rack() {
    // Create base block
    base_block = cube([X, Y, Z]);

    // Subtract floor (5mm solid bottom)
    subtract(
        base_block,
        translate([0, 0, 0]) * cylinder(r=hole_diameter/2+1, h=floor_height, $fn=64)
    );

    // Create vertical holes
    for (y in [0:3], x in [0:5]) {
        hole_pos = [
            x*spacing_X + spacing_X/2 - X/2,
            y*spacing_Y + spacing_Y/2 - Y/2,
            floor_height
        ];
        subtract(
            base_block,
            translate(hole_pos) * cylinder(r=hole_diameter/2+1, h=Z-floor_height, $fn=64)
        );
    }

    // Subtract open top portions of holes
    for (y in [0:3], x in [0:5]) {
        hole_pos = [
            x*spacing_X + spacing_X/2 - X/2,
            y*spacing_Y + spacing_Y/2 - Y/2,
            Z - hole_depth
        ];
        subtract(
            base_block,
            translate(hole_pos) * cylinder(r=hole_diameter/2+1, h=hole_depth, $fn=64)
        );
    }

    // Final result with proper hole geometry
    return difference(
        base_block,
        [
            for (y in [0:3], x in [0:5])
                translate([
                    x*spacing_X + spacing_X/2 - X/2,
                    y*spacing_Y + spacing_Y/2 - Y/2,
                    floor_height
                ]) * cylinder(r=hole_diameter/2, h=floor_height, $fn=64),
            for (y in [0:3], x in [0:5])
                translate([
                    x*spacing_X + spacing_X/2 - X/2,
                    y*spacing_Y + spacing_Y/2 - Y/2,
                    Z - hole_depth
                ]) * cylinder(r=hole_diameter/2, h=hole_depth, $fn=64)
        ]
    );
}

tube_rack();