$fn = 64;

plate_x = 130;        // X dimension of plate (mm)
plate_y = 90;         // Y dimension of plate (mm)
plate_z = 4;          // Z thickness of plate (mm)
hole_diameter = 30.5;   // Diameter of through-holes (mm)
hole_radius = hole_diameter / 2;
hole_z_extension = 0.02;  // Total extension beyond plate in Z (0.01 beyond each face)
hole_cylinder_height = plate_z + hole_z_extension;
wall_length = plate_x;    // Length of walls (X dimension, mm)
wall_thickness = 4;     // Thickness of walls (Y dimension, mm)
wall_height = 70;       // Height of walls (Z dimension, mm)

plate = 
    translate([-plate_x/2, -plate_y/2, 0])
    cube([plate_x, plate_y, plate_z], center=false);

holes = 
    for (i = [-1, 1]) 
    for (j = [-1, 0, 1]) 
        translate([40*j, 20*i, 2.0]) 
        cylinder(h=hole_cylinder_height, r=hole_radius, $fn=64);

plate_with_holes = 
    difference() {
        plate;
        holes;
    };

wall_bottom = 
    translate([0, -47, wall_height/2])
    cube([wall_length, wall_thickness, wall_height], center=true);

wall_top = 
    translate([0, 47, wall_height/2])
    cube([wall_length, wall_thickness, wall_height], center=true);

rack = 
    union() {
        plate_with_holes;
        wall_bottom;
        wall_top;
    };