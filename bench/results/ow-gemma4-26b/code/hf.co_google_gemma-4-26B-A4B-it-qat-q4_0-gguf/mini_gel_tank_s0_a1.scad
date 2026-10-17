// --- Dimensions (mm) ---
outer_x = 120;          // Total length of the tank
outer_y = 70;           // Total width of the tank
outer_z = 40;           // Total height of the tank

wall_thickness = 3;     // Thickness of the walls and floor
floor_thickness = 3;    // Thickness of the floor

platform_length = 60;   // Length of the central platform (X direction)
platform_height = 13;   // Height of the platform top from the inner floor
platform_width = outer_y - (2 * wall_thickness); // Spans full inner width

hole_diameter = 2;      // Diameter of electrode wire holes
hole_y_pos = 0;         // Y position of holes (centered on Y axis)
hole_z_pos = 30;        // Z position of holes (from bottom of tank)

// --- Resolution ---
$fn = 64;

// --- Model Construction ---

// We build the part by creating the solid shell and platform first,
// then subtracting the inner cavity and the electrode holes.

difference() {
    // 1. The Solid Body (Outer shell + Internal Platform)
    union() {
        // The main outer block
        cube([outer_x, outer_y, outer_z], center = true);

        // The Platform (Solid piece in the middle)
        // The platform top is 13mm above the inner floor.
        // Inner floor is at: -outer_z/2 + floor_thickness
        // Platform top is at: -outer_z/2 + floor_thickness + platform_height
        // We center the cube on its Z-midpoint.
        translate([0, 0, (-outer_z/2 + floor_thickness + platform_height/2)])
            cube([platform_length, platform_width, platform_height], center = true);
    }

    // 2. The Inner Cavity (The space where buffer goes)
    // We subtract this to create the hollow tank.
    // We extend it slightly in Z to ensure a clean cut at the top.
    translate([0, 0, -outer_z/2 + floor_thickness])
        cube([outer_x - 2*wall_thickness + 0.1, outer_y - 2*wall_thickness + 0.1, outer_z], center = true);

    // 3. The Electrode Holes
    // These are drilled through the X-end walls.
    // We extend the cylinder past the boundaries to ensure a clean cut.
    translate([0, hole_y_pos, hole_z_pos - outer_z/2])
        rotate([0, 90, 0])
            cylinder(d = hole_diameter, h = outer_x + 2, center = true);
}

// Note on coordinate system:
// The model is centered on the origin (0,0,0).
// The bottom of the tank is at Z = -20.
// The floor is at Z = -17.
// The electrode holes are at Z = 30 relative to the bottom, 
// which means Z = -20 + 30 = 10 in the global coordinate system.
// To match the user's "Z=30" instruction relative to the bottom:
// I have translated the hole to (hole_z_pos - outer_z/2).