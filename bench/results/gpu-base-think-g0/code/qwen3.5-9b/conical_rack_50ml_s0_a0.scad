// Variables
    plate_width_x = 130;
    plate_width_y = 90;
    plate_thickness = 4;
    hole_diameter = 30.5;
    hole_spacing_x = 40;
    hole_spacing_y = 40;
    wall_length = 130;
    wall_thickness = 4;
    wall_height_total = 70;
    wall_start_z = plate_thickness;
    wall_height = wall_height_total - wall_start_z;

    $fn = 64;

    // Calculate positions
    // Plate centered at 0,0
    // X range: -65 to 65
    // Y range: -45 to 45

    // Hole centers
    // X: -40, 0, 40
    // Y: -20, 20

    // Wall positions
    // Y: -45 to -41 and 41 to 45
    // X: -65 to 65
    // Z: 4 to 70

    difference() {
        union() {
            // Base Plate
            cube([plate_width_x, plate_width_y, plate_thickness], center = false);
            // Wait, cube center=false means origin at corner.
            // I need to center the plate on origin.
            // translate([-plate_width_x/2, -plate_width_y/2, 0]) cube([plate_width_x, plate_width_y, plate_thickness]);

            // Walls
            // Wall 1 (Bottom Edge)
            translate([-wall_length/2, -plate_width_y/2 + wall_thickness, wall_start_z])
                cube([wall_length, wall_thickness, wall_height]);
            // Wall 2 (Top Edge)
            translate([-wall_length/2, plate_width_y/2 - wall_thickness, wall_start_z])
                cube([wall_length, wall_thickness, wall_height]);
        }

        // Holes
        // Loop X
        for (i = [-1, 0, 1]) {
            // Loop Y
            for (j = [-1, 1]) {
                // Calculate center
                cx = i * hole_spacing_x;
                cy = j * hole_spacing_y / 2; // Wait, spacing is 40.
                // If j = -1, cy = -20. If j = 1, cy = 20.
                // hole_spacing_y is 40.
                // So cy = j * (hole_spacing_y / 2);
                // Wait, loop j = [-1, 1].
                // j=-1 -> -20. j=1 -> 20. Correct.

                translate([cx, cy, -0.05])
                    cylinder(h = plate_thickness + 0.1, d = hole_diameter, $fn = 64);
            }
        }
    }