// Design a straight hose-barb reducer for silicone tubing.
// Units: millimeters (mm).
// Orientation: Rests on XY plane at z=0, builds upward (+Z).

// Define dimensions in mm
diameter_8_mm_in = 7.5;      // Bottom OD of upper barb
diameter_9_mm_top = 9.5;     // Top OD of upper barb
height_upper_barb = 10;      // Height of upper barb
diameter_5_mm_in = 6.5;      // Bottom OD of lower barb
diameter_5_mm_top = 5.0;     // Top OD of lower barb
height_lower_barb = 8;       // Height of lower barb
collar_diameter = 12;        // Diameter of collar

// Create the upper barb profile (sawtooth)
// Bottom: 7.5mm, Top: 9.5mm, Height: 10mm
upper_barb_profile = linear_extrude(
    height = height_upper_barb + diameter_8_mm_in - diameter_9_mm_top // Total length including step back
);

// Create the lower barb profile (sawtooth)
// Bottom: 6.5mm, Top: 5.0mm, Height: 8mm
lower_barb_profile = linear_extrude(
    height = height_lower_barb + diameter_5_mm_in - diameter_5_mm_top // Total length including step back
);

// Create the collar (cylinder)
collar = cylinder(diameter_collar, height = 20);

// Define the main body as a union of the two barbs and the collar
main_body = union(
    upper_barb_profile,
    lower_barb_profile,
    collar
);

// Create the hole grid for the bore (8mm diameter)
// Radius is 4.0 mm
hole_radius = diameter_8_mm_in / 2;
num_holes = 16; // Even number to ensure symmetry and round holes
for(hole = 0; hole < num_holes; hole++) {
    translate([
        (h * hole_radius) - radius, // Center of the hole in X direction
        (hole % 2 == 0 ? 0 : height_upper_barb), // Offset vertically: even holes at top, odd at bottom
        0.5 // Halfway through the upper barb to center it horizontally
    ]) rotate(90) cylinder(hole_radius, hole_radius);
}

// Create the bore (hole) for the 8mm tubing
bore = cylinder(diameter_8_mm_in, height = main_body.length);

// Final assembly: Union of the body and the bore
final_part = union(main_body, bore);

print("Design complete. Print this file.");