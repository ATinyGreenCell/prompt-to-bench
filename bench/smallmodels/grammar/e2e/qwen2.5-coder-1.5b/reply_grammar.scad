// Define the dimensions of the plate
$fn = 50; // For better round corners

// Define the dimensions of the holes
hole_diameter = 3;
hole_distance = 4;

// Define the dimensions of the plate
plate_width = 20;
plate_height = 30;
plate_depth = 5;

// Create the plate
module plate() {
    // Create the base of the plate
    translate([0, 0, 0]) {
        cube([plate_width, plate_height, plate_depth]);
    }

    // Create the holes
    translate([hole_distance, hole_distance, hole_distance]) {
        cylinder(r=hole_diameter/2, h=plate_height, $fn=50);
    }
    translate([plate_width-hole_distance, hole_distance, hole_distance]) {
        cylinder(r=hole_diameter/2, h=plate_height, $fn=50);
    }
    translate([hole_distance, plate_height-hole_distance, hole_distance]) {
        cylinder(r=hole_diameter/2, h=plate_height, $fn=50);
    }
    translate([plate_width-hole_distance, plate_height-hole_distance, hole_distance]) {
        cylinder(r=hole_diameter/2, h=plate_height, $fn=50);
    }
}

// Call the plate module
plate();
