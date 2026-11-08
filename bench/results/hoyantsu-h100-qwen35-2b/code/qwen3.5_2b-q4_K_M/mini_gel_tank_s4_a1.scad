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
// We cut from the bottom wall up to the top of the platform area at that specific X position
hole_cut = main_box_temp - cylinder([hole_diameter, 15], [platform_center_x, inner_depth, hole_z_position]);

// The final part is the union of the main tank body and the raised platform
// We use difference() here to cut out the hole in the side wall from the main body. 
// Note: In OpenSCAD, 'union' creates a solid volume by combining two objects. 
// To get a single solid with holes, we typically subtract the hole shape from the outer box.
// However, since the platform is on top of the floor (which was part of the original box),
// and the hole is in the side wall, we need to be careful about how we construct the final solid.

// Strategy:
// 1. Start with the full outer box.
// 2. Subtract the hole from the side wall.
// 3. Add the platform plate on top of the floor (which was already subtracted in step 2? No, wait).
//    The original box includes the floor. If we cut a hole through the floor at z=30, 
//    that's fine because the floor is part of the main body.
//    But the platform sits on top of this floor.
//    So: Main Box (with side wall hole) + Platform Plate (on top).

final_part = union(
  // The main tank body with a hole in the side wall
  box_outer - cylinder([hole_diameter, 15], [platform_center_x, inner_depth, hole_z_position]), 
  
  // The raised platform plate sitting on top of the floor
  cube([inner_width, inner_depth, (wall_thickness * 2) + platform_height_above_floor])
);

// Render to a valid solid with no errors.
rendering = final_part;