// Dimensions
plate_width = 130;  // X dimension of the plate
plate_length = 90;  // Y dimension of the plate
plate_thickness = 4;  // Thickness of the plate
hole_diameter = 30.5;  // Diameter of the through-holes
hole_spacing = 40;  // Center-to-center spacing of the holes
wall_height = 70;  // Height of the walls
wall_thickness = 4;  // Thickness of the walls

$fn = 64;  // Number of fragments for circular shapes

// Plate with holes
plate = difference() {
    cube([plate_width, plate_length, plate_thickness]);
    for (x = [-hole_spacing, 0, hole_spacing]) {
        for (y = [-hole_spacing, hole_spacing]) {
            translate([x, y, -0.01])
            cylinder(h = plate_thickness + 0.02, d = hole_diameter);
        }
    }
}

// Walls
walls = union() {
    translate([0, -wall_thickness/2, plate_thickness])
    cube([plate_width, wall_thickness, wall_height - plate_thickness]);
    translate([0, plate_length - wall_thickness/2, plate_thickness])
    cube([plate_width, wall_thickness, wall_height - plate_thickness]);
}

// Final assembly
union() {
    plate;
    walls;
}