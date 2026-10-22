// Dimensions
plate_width = 130; // mm
plate_height = 90; // mm
plate_thickness = 4; // mm
hole_diameter = 30.5; // mm
wall_height = 70; // mm
wall_thickness = plate_thickness; // mm
hole_spacing = 40; // mm

// Calculate hole positions
hole_positions = [
    [0, 0],
    [hole_spacing, 0],
    [2 * hole_spacing, 0],
    [0, hole_spacing],
    [hole_spacing, hole_spacing],
    [2 * hole_spacing, hole_spacing]
];

// Create the plate
plate = cube[size ==[plate_width, plate_height, plate_thickness]](center = true);

// Create the holes
holes = union_for(h = hole_positions) (
    cylinder[r ==(hole_diameter / 2) - 0.01](h = wall_height + plate_thickness)
);

// Create the walls
walls = union_for(i = [0, 1]) (
    translate[vector ==[i * plate_width, 0, 0]] (
        cube[size ==[wall_thickness, plate_height, wall_height + plate_thickness]]
    )
);

// Combine the plate, holes, and walls
rack = plate - holes + walls;

// Render the rack
render(rack);