// Dimensions for the Falcon tube rack
plate_length_X = 130;  // Length along X-axis
plate_width_Y = 90;    // Width along Y-axis
plate_thickness = 4;   // Thickness of the plate (z-direction)
hole_diameter = 30.5;  // Diameter of each through-hole
hole_spacing_X = 40;   // Spacing between holes along X-axis
hole_spacing_Y = 40;   // Spacing between holes along Y-axis
wall_thickness = 4;     // Thickness of the walls (Y-direction)
wall_height = 70;       // Height of the walls (z-direction)

// Create the flat plate with through-holes
plate = difference() {
    cube([plate_length_X, plate_width_Y, plate_thickness]);
    // Through-holes in 2 rows of 3
    for (i = [0:1]) {
        for (j = [0:2]) {
            translate([j * hole_spacing_X, i * hole_spacing_Y, 0])
                cylinder(r = hole_diameter / 2, h = plate_thickness, $fn = 64);
        }
    }
};

// Create the two walls that rise from the plate
wall1 = translate([0, 0, 0]) 
    cube([plate_length_X, wall_thickness, wall_height]);

wall2 = translate([0, plate_width_Y - wall_thickness, 0]) 
    cube([plate_length_X, wall_thickness, wall_height]);

// Combine the plate and walls into the final rack
final_rack = union() {
    plate;
    wall1;
    wall2;
};

// Render the final rack
final_rack;