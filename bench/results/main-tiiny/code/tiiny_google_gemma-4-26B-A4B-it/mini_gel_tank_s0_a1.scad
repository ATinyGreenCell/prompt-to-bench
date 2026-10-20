// --- Dimensions (mm) ---
outer_x = 120;          // Total length of the tank
outer_y = 70;           // Total width of the tank
outer_z = 40;           // Total height of the tank
wall_thickness = 3;     // Thickness of the side walls
floor_thickness = 3;    // Thickness of the bottom floor

platform_length = 60;    // Length of the central platform along X
platform_height_from_floor = 13; // Height of the platform top relative to the inner floor
platform_width = outer_y - 2*wall_thickness; // Platform spans the full inner width (Y)

hole_diameter = 2;      // Diameter of the electrode wire holes
hole_y_pos = 0;         // Y position of the holes (centered on Y)
hole_z_pos = 30;        // Z position of the holes

// --- Constants ---
$fn = 64;

// --- Implementation ---

// The tank is built in one piece. 
// We start with the outer shell and subtract the interior volume.
// Then we add the platform inside.

module buffer_tank() {
    difference() {
        // Main Outer Body
        cube([outer_x, outer_y, outer_z]);

        // Interior Cavity
        // We subtract the cavity from the main body.
        // The cavity starts at floor_thickness and goes to the top.
        translate([wall_thickness, wall_thickness, floor_thickness]) {
            cube([outer_x - 2*wall_thickness, outer_y - 2*wall_thickness, outer_z]);
        }

        // Electrode Wire Holes
        // Holes are drilled through the X-walls at the ends.
        // The user specified y = 0 (center of Y) and z = 30.
        // To ensure a clean cut, we make the cylinder longer than the tank.
        // We use a small offset to ensure it cuts through the faces.
        translate([-1, outer_y/2, hole_z_pos])
            rotate([0, 90, 0])
                cylinder(d = hole_diameter, h = outer_x + 2);
    }

    // The Platform
    // The platform is inside the tank. 
    // It is centered in X.
    // Its top is at z = floor_thickness + platform_height_from_floor.
    // Its width is the inner width (outer_y - 2*wall_thickness).
    
    translate([
        (outer_x / 2) - (platform_length / 2), 
        wall_thickness, 
        floor_thickness
    ]) {
        cube([
            platform_length, 
            platform_width, 
            platform_height_from_floor
        ]);
    }
}

// Render the part
// The part is centered on the XY plane as requested.
// The bounding box will be X: -60 to 60, Y: -35 to 35, Z: 0 to 40.
translate([-outer_x/2, -outer_y/2, 0])
    buffer_tank();