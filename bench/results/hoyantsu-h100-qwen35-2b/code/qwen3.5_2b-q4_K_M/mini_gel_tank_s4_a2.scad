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

// Create a temporary variable for the main box to avoid overwrite warnings later
main_box_temp = cube([tank_width, tank_depth, tank_height]);

// Add a hole in one of the side walls (at y=0, z=30) to allow electrode wires through
// We cut from the bottom wall up to the top of the platform area at that specific X position.
// Note: The cylinder radius is half the diameter.
hole_cut = main_box_temp - cylinder([hole_diameter / 2, 15], [platform_center_x, inner_depth, hole_z_position]);

// Constructing the final part logic step-by-step to avoid "undefined operation" errors:
// 1. Start with the full outer box (main_box_temp).
// 2. Subtract the hole from the side wall. This creates a solid with an internal cavity.
//    The floor is still intact at z=0.
final_part = main_box_temp - cylinder([hole_diameter / 2, 15], [platform_center_x, inner_depth, hole_z_position]);

// 3. Add the raised platform plate sitting on top of the tank's floor (z=inner_height).
//    The total height of this plate is: wall_thickness + wall_thickness + platform_height_above_floor.
plate_total_height = wall_thickness * 2 + platform_height_above_floor;
platform_plate = cube([inner_width, inner_depth, plate_total_height]);

// 4. Combine the main tank body and the platform using union().
final_part = union(final_part, platform_plate);

rendering = final_part;