// Define the dimensions of the plate
$fn = 50; // For better round corners
$fnHole = 50; // For better round holes

// Define the dimensions of the holes
holeDiameter = 3;
holeDistance = 4;

// Create the plate
module plate() {
    // Create the base of the plate
    translate([0, 0, 0]) {
        cube([20, 30, 5], center = true);
    }

    // Create the holes
    translate([holeDistance, holeDistance, holeDistance]) {
        for (i = [0:3]) {
            for (j = [0:3]) {
                translate([i * holeDistance, j * holeDistance, 0]) {
                    cylinder(r = holeDiameter / 2, h = 5, center = true);
                }
            }
        }
    }
}

// Call the plate module
plate();
