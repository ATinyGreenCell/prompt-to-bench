// Dimensions in millimetres
top_thickness = 2; // Thickness of the top plate
wall_thickness = 2.5; // Thickness of the walls
outer_size = 90; // Outer size of the box (X and Y)
height = 40; // Height of the walls
hole_diameter = 4.5; // Diameter of the screw holes
hole_spacing = 71.5; // Spacing of the screw holes
notch_width = 12; // Width of the power cable notch
notch_height = 8; // Height of the power cable notch

$fn = 64; // Number of fragments for curved shapes

// Top plate with screw holes
top_plate = difference() {
    cube([outer_size, outer_size, top_thickness], center=true);
    for (x = [-hole_spacing/2, hole_spacing/2], y = [-hole_spacing/2, hole_spacing/2]) {
        translate([x, y, top_thickness/2])
            cylinder(h=top_thickness+0.02, d=hole_diameter, center=true);
    }
}

// Walls of the box
walls = difference() {
    union() {
        // Front and back walls
        translate([0, outer_size/2 - wall_thickness/2, top_thickness])
            cube([outer_size, wall_thickness, height - top_thickness], center=true);
        translate([0, -outer_size/2 + wall_thickness/2, top_thickness])
            cube([outer_size, wall_thickness, height - top_thickness], center=true);
        // Left and right walls
        translate([outer_size/2 - wall_thickness/2, 0, top_thickness])
            cube([wall_thickness, outer_size, height - top_thickness], center=true);
        translate([-outer_size/2 + wall_thickness/2, 0, top_thickness])
            cube([wall_thickness, outer_size, height - top_thickness], center=true);
    }
    // Notch for power cable in one wall
    translate([outer_size/2 - wall_thickness/2, 0, height - notch_height])
        cube([notch_width, outer_size, notch_height + 0.01], center=true);
}

// Combine top plate and walls
union() {
    top_plate;
    walls;
}