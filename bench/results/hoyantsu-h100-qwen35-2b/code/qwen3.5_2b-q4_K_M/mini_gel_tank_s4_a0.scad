// Design parameters for the mini horizontal gel-electrophoresis buffer tank
// All dimensions in millimeters (mm)

// Tank Outer Dimensions
tank_width = 120; // X dimension
tank_depth = 70;  // Y dimension
tank_height = 40; // Z dimension

// Wall thickness and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Inner dimensions of the tank (after subtracting walls)
inner_width = tank_width - 2 * wall_thickness;
inner_depth = tank_depth - 2 * wall_thickness;
inner_height = tank_height - 2 * floor_thickness;

// Platform Dimensions and Position
platform_length = 60; // X dimension of the platform
platform_height_above_floor = 10; // Z distance from inner floor to top of platform
platform_center_x = (tank_width / 2) - (platform_length / 2); // Centred on tank width

// Hole Dimensions and Position
hole_diameter = 2; // mm
hole_y_offset = 0; // mm (at the bottom wall)
hole_z_position = 30; // mm (along the X axis, from the left end)

// Create the main rectangular box with walls and floor
box_outer = cube([tank_width, tank_depth, tank_height]);
box_inner = box_outer - cube([wall_thickness, wall_thickness, floor_thickness]);

// Add a hole in one of the side walls (at y=0, z=30) to allow electrode wires through
// We cut from the bottom wall up to the top of the platform area at that specific X position
hole_cut = box_inner - cylinder([hole_diameter, 15], [platform_center_x, inner_depth, hole_z_position]);

// The final part is the union of the main tank body and the raised platform
// We use difference() here to cut out the hole in the side wall from the main body
final_part = box_outer - cylinder([hole_diameter, 15], [platform_center_x, inner_depth, hole_z_position]);

// Add the solid raised platform on top of the tank's floor
// The platform sits at z=inner_height + platform_height_above_floor
// We create a flat plate and extrude it up to that height
plate_thickness = wall_thickness; // Assuming walls are 3mm thick as per spec
platform_plate = cube([inner_width, inner_depth, (wall_thickness * 2) + platform_height_above_floor]);

final_part = union(final_part, platform_plate);

// Optional: Add a small rim around the top of the tank for structural integrity if needed, 
// but strictly following "open-top" and dimensions implies just the main body.
// The prompt asks specifically for walls and floor thicknesses, so we stop there.

rendering = final_part;