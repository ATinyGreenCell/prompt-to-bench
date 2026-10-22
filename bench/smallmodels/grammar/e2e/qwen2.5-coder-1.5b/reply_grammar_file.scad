// Define the dimensions of the plate
$fn = 50; // Number of segments for the holes

// Define the dimensions of the holes
hole_diameter = 3; // Diameter of the holes
hole_distance = 4; // Distance between the holes

// Define the dimensions of the plate
plate_width = 20; // Width of the plate
plate_height = 30; // Height of the plate
plate_depth = 5; // Depth of the plate

// Create the plate
module plate() {
    difference() {
        cube([plate_width, plate_height, plate_depth]);
        translate([hole_distance, hole_distance, hole_distance]) {
            for (x = [0:plate_width-1]) {
                for (y = [0:plate_height-1]) {
                    translate([x, y, 0]) {
                        cylinder(diameter = hole_diameter, height = plate_depth);
                    }
                }
            }
        }
    }
}

// Create the plate
plate();
