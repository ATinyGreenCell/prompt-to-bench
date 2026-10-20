// Buffer tank for mini horizontal gel-electrophoresis box
// Units: millimetres

// --- Outer Dimensions ---
outer_x = 120;
outer_y = 70;
outer_z = 40;

// --- Wall and Floor Thickness ---
wall_thickness = 3;
floor_thickness = 3;

// --- Platform Dimensions ---
platform_length_x = 60;
platform_height_from_floor = 10;
platform_width_y = outer_y - 2 * wall_thickness; // Spans full inner width

// --- Hole Dimensions ---
hole_diameter = 2;
hole_z_pos = 30;
hole_y_pos = 0;

// --- Calculated Inner Dimensions ---
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// --- Platform Position ---
// Centered in X, spans full Y, top at z = floor_thickness + platform_height_from_floor
platform_top_z = floor_thickness + platform_height_from_floor;
platform_bottom_z = floor_thickness;
platform_center_x = 0;
platform_center_y = 0;

// --- Main Tank Body (Hollow Rectangular Box) ---
// Base plate
base_plate = cube([outer_x, outer_y, floor_thickness], center = true);

// Side walls (Left/Right)
left_wall = cube([wall_thickness, outer_y, outer_z], center = true);
right_wall = translate([outer_x/2 - wall_thickness/2, 0, 0], [wall_thickness, outer_y, outer_z], center = true);
// Actually, simpler to build union of walls and base, then subtract interior
// Let's build the shell directly using difference

// Create the solid outer block
outer_block = cube([outer_x, outer_y, outer_z], center = true);

// Create the inner void (the cavity)
// The cavity is defined by the inner dimensions, starting from floor_thickness up to outer_z
inner_cavity = translate([0, 0, floor_thickness], [inner_x, inner_y, outer_z - floor_thickness], center = true);

// Create the platform
// It sits on the floor, spans full inner Y, length 60mm centered in X
platform_block = translate([0, 0, floor_thickness], [platform_length_x, platform_width_y, platform_height_from_floor], center = true);

// Combine the tank shell and the platform
// We need to subtract the inner cavity from the outer block, but keep the platform
// Strategy:
// 1. Start with outer_block.
// 2. Subtract the main cavity (the space above the floor that is empty).
// 3. Subtract the platform space? No, the platform is solid.
// 4. The cavity is the space NOT occupied by the tank walls, floor, or platform.
// Let's build the tank as a union of walls and floor, then subtract the platform if it was part of the void, 
// but actually the platform is a solid feature inside.

// Better approach:
// 1. Create the outer shell (walls + floor).
// 2. Create the platform.
// 3. Union them.
// 4. Subtract the "air" space? No, we want a solid tank.
// The tank is a hollow box with a solid platform inside.
// So:
// Tank = (Outer Block) - (Inner Cavity) + (Platform)
// But the platform is inside the cavity.
// So: Tank = (Outer Block - Inner Cavity) + Platform
// Wait, if we subtract the inner cavity, we remove the space where the platform is.
// So we need to subtract (Inner Cavity - Platform).

// Let's define the void space that needs to be removed from the outer block.
// The void is the space inside the walls, above the floor, excluding the platform.
// Void = Inner Cavity - Platform
void_space = difference(
    translate([0, 0, floor_thickness], [inner_x, inner_y, outer_z - floor_thickness], center = true),
    translate([0, 0, floor_thickness], [platform_length_x, platform_width_y, platform_height_from_floor], center = true)
);

// Construct the tank
tank_shell = difference(
    outer_block,
    void_space
);

// Add the platform?
// The void_space calculation subtracted the platform from the cavity, so the platform is still part of the outer_block?
// No, difference(Outer, Void) removes the void. If Void = Cavity - Platform, then Outer - (Cavity - Platform) = (Outer - Cavity) + Platform.
// This logic holds if the platform is fully contained within the cavity.
// Let's verify:
// Outer Block: 120x70x40
// Cavity: 114x64x37 (starts at z=3)
// Platform: 60x64x10 (starts at z=3)
// Void = Cavity - Platform.
// Tank = Outer - Void.
// This results in the walls, floor, and the platform.

// Now add the holes for electrodes
// Holes are drilled through the end walls (X ends) at y=0, z=30.
// Hole 1: Left wall (x = -60)
// Hole 2: Right wall (x = 60)
// We need to subtract cylinders from the tank.

hole_cylinder = cylinder(d = hole_diameter, h = outer_y + 10, center = true); // Long enough to cut through

// Position the holes
// Left hole: x = -outer_x/2, y = 0, z = hole_z_pos
hole_left = translate([-outer_x/2, 0, hole_z_pos], [hole_diameter, outer_y, 10], center = true);
// Right hole: x = outer_x/2, y = 0, z = hole_z_pos
hole_right = translate([outer_x/2, 0, hole_z_pos], [hole_diameter, outer_y, 10], center = true);

// Final assembly
final_part = difference(
    tank_shell,
    union(
        hole_left,
        hole_right
    )
);

// Render
render() {
    color("LightBlue")
    final_part;
}