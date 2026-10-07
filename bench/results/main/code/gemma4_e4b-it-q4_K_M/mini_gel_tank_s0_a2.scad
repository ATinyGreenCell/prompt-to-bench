// Buffer Tank Dimensions
tank_outer_x = 120; // Outer length in X (mm)
tank_outer_y = 70;  // Outer width in Y (mm)
tank_outer_z = 40;  // Outer height in Z (mm)

wall_thickness = 3; // Wall thickness (mm)
floor_thickness = 3; // Floor thickness (mm)

// Inner dimensions calculation
inner_x = tank_outer_x - 2 * wall_thickness;
inner_y = tank_outer_y - 2 * wall_thickness;
inner_z_space = tank_outer_z - floor_thickness;

// Platform Dimensions
platform_length_x = 60; // Length of the platform in X (mm)
platform_width_y = inner_y; // Spans full inner width Y
platform_height = 10;  // Height of the platform top above inner floor (mm)

// Electrode Wire Hole Dimensions
hole_diameter = 2;    // Diameter of electrode wire hole (mm)
hole_z_level = 30;    // Z level for holes (mm)

$fn = 64;

// --- Main Tank Structure ---

// 1. Outer Shell (Solid block representing the outer boundary)
outer_tank = cube([tank_outer_x, tank_outer_y, tank_outer_z]);

// 2. Inner Void (The space inside the tank)
// We create a solid shape that represents the material removed from the interior.
// The height of the void needs to account for the floor thickness at the bottom and open top.
inner_void = translate([wall_thickness, wall_thickness, floor_thickness])
    cube([inner_x, inner_y, inner_z_space]);

// 3. Tank Body (Outer shell minus the interior void)
tank_body = difference(outer_tank, inner_void);


// --- Platform Structure ---

// The platform sits on top of the floor (Z=floor_thickness).
platform_base_z = floor_thickness;
// The height of the platform is 10mm above the inner floor. Since the inner floor starts at Z=3, the platform base is at Z=3.
// The total height of the platform block itself is 10mm.
platform_height_block = platform_height;

// Platform dimensions: centered in X, spans full inner Y
platform_x_offset = (tank_outer_x - platform_length_x) / 2;
// The platform must be positioned inside the walls. Since it spans inner_y, its Y position should be wall_thickness.
platform_y_position = wall_thickness;

// The platform is a solid block placed inside the tank.
platform = translate([platform_x_offset, platform_y_position, platform_base_z])
    cube([platform_length_x, inner_y, platform_height_block]);


// --- Cutting Holes for Electrodes ---

// Hole location: At the two X ends (X=0 and X=tank_outer_x), at Y=wall_thickness/2 (center of wall thickness)
// The holes must pass through the side walls.

// Define the cutting cylinder shape (must extend slightly past the wall faces)
hole_cutter = cylinder(r = hole_diameter / 2, h = tank_outer_z + 1); // Make it tall enough to cut through the entire height

// Hole 1: Left End Wall (X=0 plane)
// Positioned at Y=wall_thickness/2 and Z=hole_z_level.
// We translate it so its center is at X = -0.5 (to ensure it cuts past X=0)
hole1 = translate([-(wall_thickness / 2) + 0.5, wall_thickness / 2, hole_z_level])
    cylinder(r = hole_diameter / 2, h = tank_outer_z + 1);

// Hole 2: Right End Wall (X=tank_outer_x plane)
// Positioned at Y=wall_thickness/2 and Z=hole_z_level.
// We translate it so its center is at X = tank_outer_x + 0.5 (to ensure it cuts past X=tank_outer_x)
hole2 = translate([tank_outer_x + (wall_thickness / 2) - 0.5, wall_thickness / 2, hole_z_level])
    cylinder(r = hole_diameter / 2, h = tank_outer_z + 1);


// --- Final Assembly ---

// The final object is the Tank Body MINUS the volume occupied by the platform AND MINUS the holes.
final_tank = difference(tank_body, platform);

// Now cut the holes through the resulting structure.
// We use difference() sequentially.
final_result = difference(final_tank, hole1);
final_result = difference(final_result, hole2);

// Render the result
final_result;