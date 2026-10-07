// Define dimensions in millimeters
$fn = 64; // Number of points for fine rendering

// Tank outer dimensions
length_X = 120;
length_Y = 70;
depth_Z = 40;

// Platform dimensions and position
platform_length_X = length_X;
platform_width_Y = length_Y;
platform_height_Z = depth_Z - 3; // Subtract the tank floor thickness
platform_center_X = length_X / 2;
platform_top_z = platform_height_Z + 10;

// Hole positions
hole_x_start = 0.5 * (length_X - 6); // Halfway along X, 3 mm from wall

// Define variables for dimensions and position
var $x = length_X;
var $y = length_Y;
var $z = depth_Z;
var $w = 3; // Wall thickness
var $f = 10; // Floor thickness
var $p = platform_length_X;
var $t = platform_height_Z + 10;

// Tank outer dimensions in OpenSCAD format
translate([0, 0, -depth_Z]) cube([length_X, length_Y, depth_Z]);

// Platform and buffer chambers
translate([platform_center_X, 0, platform_top_z]) box([p, y, z]);
translate([0, p/2, t + z]) box([x, y, f]);

// Hole in the wall at each end of the tank
for (var $i = 1; $i < 3; $i++) {
    translate([(hole_x_start - w / 2), 0, i * depth_Z])
        hole(translate([0, 0, t + z]) box([w, y, f]);
}

// Electrode holes
for (var $j = 1; $j < 3; $j++) {
    translate([(hole_x_start - w / 2), 0, j * depth_Z])
        hole(translate([0, 0, t + z]) box([w, y, f]);
}

// Display the tank
display();