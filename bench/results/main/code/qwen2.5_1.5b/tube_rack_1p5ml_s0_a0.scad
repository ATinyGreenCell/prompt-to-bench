// Dimensions of the bench rack
$fn = 64; // For better roundness

// Define dimensions for hole grid
hole_diameter_mm = 11.2;
hole_depth_mm = 25;
floor_thickness_mm = 5;

// Calculate center-to-center distance between holes
center_to_center_distance_mm = hole_diameter_mm + floor_thickness_mm;

// Create the rectangular block
block {
    translate([0, 0, 0]) cube([106, 72, 30]);
}

// Define the hole grid
for (i in range(4)) { // 4 rows of holes
    for (j in range(6)) { // 6 columns of holes
        translate([(center_to_center_distance_mm * j), 0, 0]) cube([hole_diameter_mm, hole_depth_mm, floor_thickness_mm]);
    }
}

// Define the bottom floor
translate([0, 30, 0]) cube([106, 72, floor_thickness_mm]);

// Define the top surface (open)
translate([0, 45.8, 0]) cube([106, 72, hole_depth_mm]);