// Define dimensions in millimeters
$fn = 64; // for round holes

// Dimensions of the plate
X = 130;
Y = 90;
Z_plate = 4;

// Hole diameter
D_hole = 30.5;

// Wall thickness and height
T_wall = 4;
H_wall = 70;

// Center-to-center distance between holes
C2C = 40;

// Calculate plate center coordinates
X_center = X / 2;
Y_center = Y / 2;

// Define variables for the wall extrusions
Z_wall_1 = Z_plate + T_wall;
Z_wall_2 = Z_wall_1 + H_wall - T_wall;

// Create the rack structure
rack = union() with() {
    // Wall on one side of plate
    cube([X, Y, T_wall], center: true);
    translate([0, 0, Z_wall_1]) {
        cylinder(diameter: D_hole, height: C2C * 2 + T_wall, center: true);
    }
    translate([0, 0, Z_wall_1 - T_wall]) {
        cube([X, Y, T_wall], center: true);
    }

    // Wall on the other side of plate
    cube([X, Y, T_wall], center: true);
    translate([0, 0, Z_wall_2]) {
        cylinder(diameter: D_hole, height: C2C * 2 + T_wall, center: true);
    }
    translate([0, 0, Z_wall_2 - T_wall]) {
        cube([X, Y, T_wall], center: true);
    }

    // Short ends of the rack
    translate([0, 0, H_wall / 2]) {
        cube([X, Y, T_wall], center: true);
    }
};

// Print orientation: rack stands on walls and tubes pass through holes