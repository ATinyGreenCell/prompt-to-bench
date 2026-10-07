// Dimensions in millimetres
$fn = 64;
width_plate = 130;      // Long edge (X)
height_plate = 90;     // Short edge (Y)
thickness_plate = 4;   // Plate thickness (Z)

hole_diameter = 30.5;  // Tube hole diameter
tube_hole_spacing_x = 40; // Centre-to-centre spacing along X
tube_hole_spacing_y = 40; // Centre-to-centre spacing along Y

wall_height = 70;      // Wall height (Z)

module plate_with_walls() {
    // Create the base plate
    cube([width_plate, height_plate, thickness_plate]);

    // Create six tube holes in two rows of three
    for (x in [1:3]) {
        for (y in [1:2]) {
            translate([(x-1)*tube_hole_spacing_x/2 + tube_hole_spacing_x/4,
                      (y-1)*tube_hole_spacing_y/2 + tube_hole_spacing_y/4, 0])
                difference() {
                    cylinder(diameter=hole_diameter+0.5, height=thickness_plate+1);
                };
        }
    }

    // Create the two walls along the long edges
    translate([-width_plate/2 - 0.3, -height_plate/2 + thickness_plate/2, 0])
        rotate([90, 0, 0]) {
            cube([width_plate+0.6, thickness_plate+1, wall_height]);
        };

    translate([-width_plate/2 - 0.3, height_plate/2 + thickness_plate/2, 0])
        rotate([90, 0, 0]) {
            cube([width_plate+0.6, thickness_plate+1, wall_height]);
        };
}

// Mirror the plate to create the final rack
mirror([1, 1, 0]) {
    translate([0, 0, -thickness_plate])
        rotate([0, 180, 0])
            plate_with_walls();
}