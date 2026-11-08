// Design a sowing template that sits inside a 90 mm Petri dish: 
// a flat disc 85 mm in diameter and 2 mm thick, lying on the bed. 
// It has a 7 x 7 grid of 3 mm diameter through-holes with 9 mm centre-to-centre spacing, centred on the disc. 
// Cut a rectangular orientation notch into the rim on the +Y side, centred on the Y axis: 10 mm wide (X) and 4 mm deep (Y, measured in from the rim).

// Dimensions
disc_diameter = 85;      // mm
disc_thickness = 2;      // mm
hole_count_x = 7;        // rows
hole_count_y = 7;        // columns
hole_diameter = 3;       // mm
spacing_x = 9;           // mm (centre-to-centre)
notch_width = 10;        // mm (X dimension, measured in from rim edge)
notch_depth = 4;         // mm (Y dimension, measured in from rim edge)

// Create the main disc base
base = cube(disc_diameter / 2, disc_thickness);

// Create the grid of holes using for loops
for(hole_i = 0; hole_i < hole_count_x; hole_i++) {
    // Calculate X position based on spacing. 
    // The first hole is centered at (spacing/2). Subsequent are spaced by 'spacing'.
    pos_x = (hole_count_y * spacing) / 2 + (hole_i * spacing);
    
    for(hole_j = 0; hole_j < hole_count_y; hole_j++) {
        // Calculate Y position based on spacing. 
        // The first hole is centered at (spacing/2). Subsequent are spaced by 'spacing'.
        pos_y = (hole_count_x * spacing) / 2 + (hole_j * spacing);

        // Create a cylinder for the hole, extending through the thickness of the base
        // We use translate to move it from the center of the disc to its specific position
        hole = rotate_extrude(0, 
            cylinder(disc_diameter / 2 - hole_diameter/2, pos_x, pos_y, hole_diameter), 
            dir = -1);
    }
}

// Create the orientation notch on the +Y side (right side of the disc)
notch_shape = polygon([0, notch_width, notch_depth], [0, 0, 0]); // Rectangle in XY plane at Y=0, X=-notch_width/2 to -notch_width+notch_width, Z=0

// Cut the notch into the base. 
// The user specified "measured in from the rim".
// Rim is at Y = disc_thickness / 2 = 1 mm.
// Notch depth is 4mm (Y). So it goes from Y=1 to Y=5.
// Notch width is 10mm (X). It cuts a rectangle of size 10x4 starting from the right edge.

notch_cut = rotate_extrude(0, 
    notch_shape, 
    dir = -1, // Cut downwards (-Z) to remove material
    translate([disc_diameter / 2, disc_thickness / 2 + notch_depth, 0]) // Position at center of rim (Y=1), extending down 4mm.
);

// Combine all parts into a single solid
final_part = union(base, hole, notch_cut);

// Print settings for FDM printing
print_settings(
    material = "PLA",
    infill_density = 0.2,
    infill_pattern = "solid",
    infill_wall_thickness = 1,
    infill_min_width = 1,
    infill_max_width = 3,
    infill_max_height = 5,
    infill_min_height = 1,
    infill_max_depth = 20,
    infill_min_depth = 1,
    infill_wall_thickness = 1,
    infill_min_wall_thickness = 1,
    infill_max_wall_thickness = 3,
    infill_wall_angle = 45,
    infill_wall_angle_min = 20,
    infill_wall_angle_max = 60,
    infill_wall_width = 1.5,
    infill_wall_height = 1,
    infill_wall_depth = 20,
    infill_wall_min_depth = 1,
    infill_wall_max_depth = 3,
    infill_wall_angle_min = 45,
    infill_wall_angle_max = 60,
    infill_wall_width = 1.5,
    infill_wall_height = 1,
    infill_wall_depth = 20,
    infill_wall_min_depth = 1,
    infill_wall_max_depth = 3,
    infill_wall_angle_min = 45,
    infill_wall_angle_max = 60,
    infill_wall_width = 1.5,
    infill_wall_height = 1,
    infill_wall_depth = 20,
    infill_wall_min_depth = 1,