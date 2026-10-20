// Dimensions (mm)
plate_x = 130;          // plate length (X)
plate_y = 90;           // plate width  (Y)
plate_thick = 4;        // plate thickness (Z)
hole_d = 30.5;          // tube hole diameter
hole_spacing = 40;      // centre‑to‑centre spacing of holes
wall_height = 70;       // final height of the rack after flipping
wall_thick = 4;         // wall thickness (Y direction)

// $fn for smooth circles
$fn = 64;

// Main part
module rack() {
    // Build the solid (plate + two side walls)
    solid = union() {
        // Plate (centered on origin)
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_thick]);

        // Left wall (flush with negative Y edge)
        translate([-plate_x/2, -plate_y/2 - wall_thick, plate_thick])
            cube([plate_x, wall_thick, wall_height - plate_thick]);

        // Right wall (flush with positive Y edge)
        translate([-plate_x/2,  plate_y/2, plate_thick])
            cube([plate_x, wall_thick, wall_height - plate_thick]);
    }

    // Subtract the tube holes (extend 0.5 mm beyond each face)
    difference() {
        solid;
        // Hole grid: 2 rows (Y = ±20) , 3 columns (X = -40,0,40)
        for (col = [-1, 0, 1])
            for (row = [-1, 1])
                translate([col*hole_spacing, row*hole_spacing, -0.5])
                    cylinder(d = hole_d, h = plate_thick + 1);
    }
}

// Render the rack
rack();