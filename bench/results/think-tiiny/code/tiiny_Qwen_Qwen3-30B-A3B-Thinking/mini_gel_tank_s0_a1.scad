$fn = 64;

// Dimensions in mm
outer_x = 120;      // Outer X dimension (length)
outer_y = 70;        // Outer Y dimension (width)
outer_z = 40;        // Outer Z dimension (height)
wall_thickness = 3;  // Wall thickness (3mm)
floor_thickness = 3; // Floor thickness (3mm)
platform_length = 60; // Platform length (X direction, centred)
platform_width = outer_y - 2 * wall_thickness; // Platform spans full inner width (Y)
platform_height = 10; // Platform height (10mm above inner floor)
hole_diameter = 2;     // Hole diameter (2mm)
hole_length = wall_thickness + 0.02; // Hole length (wall thickness + 0.01 beyond each side)

// Build outer box (centred at origin, bottom at z=0)
outer_box = translate([-outer_x/2, -outer_y/2, 0])
             cube([outer_x, outer_y, outer_z]);

// Build inner box (hollow part, from floor thickness up)
inner_box = translate([-outer_x/2 + wall_thickness, -outer_y/2 + wall_thickness, floor_thickness])
              cube([outer_x - 2 * wall_thickness, outer_y - 2 * wall_thickness, outer_z - floor_thickness]);

// Build tank walls (outer minus inner)
tank_walls = difference() {
  outer_box;
  inner_box;
}

// Build platform (solid, centred in X, spans full inner Y, from floor to 10mm above)
platform = translate([-platform_length/2, -platform_width/2, floor_thickness])
            cube([platform_length, platform_width, platform_height]);

// Build left hole (through left end wall, horizontal at y=0, z=30)
hole_left = translate([-outer_x/2 - 0.01, 0, 30])
             rotate([90, 0, 0])
             cylinder(r = hole_diameter/2, h = hole_length, $fn=64);

// Build right hole (through right end wall, horizontal at y=0, z=30)
hole_right = translate([outer_x/2 - wall_thickness + 0.01, 0, 30])
             rotate([90, 0, 0])
             cylinder(r = hole_diameter/2, h = hole_length, $fn=64);

// Assemble final tank: walls with holes, plus platform
final_tank = union() {
  difference() {
    tank_walls;
    hole_left;
    hole_right;
  }
  platform;
}

final_tank;