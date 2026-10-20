// Dimensions for mini horizontal gel-electrophoresis buffer tank
// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Platform dimensions
platform_length_x = 60;
platform_height_z = 10; // Height above inner floor
platform_y_span = outer_y - 2 * wall_thickness; // Spans full inner width

// Electrode hole dimensions
hole_diameter = 2;
hole_z_pos = 30; // Height from bottom
hole_y_pos = 0; // Centered on Y

// Calculate inner dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Calculate platform position
// Platform is centered in X, spans full inner Y, sits on inner floor + platform_height
platform_x_start = (outer_x - platform_length_x) / 2;
platform_y_start = (outer_y - platform_y_span) / 2;
platform_z_bottom = floor_thickness;
platform_z_top = floor_thickness + platform_height_z;

// Calculate chamber heights
// Chambers are at the ends, below the platform
chamber_height = platform_z_bottom; // 3mm

// Main tank body (outer box)
// We will build the final part by subtracting the voids from the outer cube
// Void 1: The main inner cavity (walls and floor)
void_cavity = translate([0, 0, floor_thickness]) *
              cube([inner_x, inner_y, inner_z], center = true);

// Void 2: The space occupied by the platform (to be subtracted from the cavity? No)
// The platform is a solid block. The cavity is the empty space.
// We want: Outer Cube - (Cavity - Platform).
// This is equivalent to: Outer Cube - Cavity + Platform.
// But we can't do + in difference.
// Correct logic:
// 1. Start with Outer Cube.
// 2. Subtract the "Cavity" (which includes the space where the platform will be).
// 3. Add the Platform (Union).
// But wait, if we subtract the cavity, the platform space becomes empty.
// Then we add the platform.
// So the final object is the tank walls + floor + platform.

// Let's construct the tank walls and floor first.
// We take the outer cube and subtract the inner cavity.
// This leaves the walls and floor.
tank_walls_floor = difference() {
    cube([outer_x, outer_y, outer_z], center = true);
    // The cavity is the empty space inside.
    // We need to make sure the cavity extends slightly past the walls to avoid coplanar issues.
    // The cavity is defined as inner_x, inner_y, inner_z.
    // The outer cube is outer_x, outer_y, outer_z.
    // The difference will leave walls of thickness wall_thickness.
    translate([0, 0, floor_thickness]) *
    cube([inner_x, inner_y, inner_z], center = true);
}

// Now add the platform.
// The platform is a solid block.
platform_block = translate([0, 0, platform_z_bottom]) *
                 cube([platform_length_x, platform_y_span, platform_height_z], center = true);

// Combine tank walls/floor and platform
tank_with_platform = union() {
    tank_walls_floor;
    platform_block;
}

// Now drill the electrode holes.
// Holes are at the ends of the tank, through the walls.
// Hole 1: Left end (X negative side)
// Hole 2: Right end (X positive side)
// We need to subtract cylinders from the tank_with_platform.
// The holes must extend past the walls to ensure clean cuts.
// Hole length needs to be sufficient to cut through the wall thickness.
// Wall thickness is 3mm. Hole diameter is 2mm.
// We'll make the cylinder length 10mm to be safe.

// Hole 1 (Left)
hole_left = translate([-outer_x/2 + wall_thickness, 0, hole_z_pos]) *
            cylinder(d = hole_diameter, h = 10, center = true);

// Hole 2 (Right)
hole_right = translate([outer_x/2 - wall_thickness, 0, hole_z_pos]) *
             cylinder(d = hole_diameter, h = 10, center = true);

// Final part: Tank with platform minus the holes
final_part = difference() {
    tank_with_platform;
    hole_left;
    hole_right;
}

// Render the final part
render() {
    final_part;
}