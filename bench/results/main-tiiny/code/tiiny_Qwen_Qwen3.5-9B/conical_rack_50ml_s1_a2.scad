// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Flat plate on bed (Z=0), walls rising up.
// Final orientation: Rack stands on walls, tubes inserted from top.

$fn = 128; // High resolution for smooth holes and walls

// --- Dimensions ---
// Plate dimensions
plate_length_X = 130; // mm
plate_width_Y = 90;   // mm
plate_thickness = 4;  // mm

// Hole dimensions
hole_diameter = 30.5; // mm (Falcon tube outer diameter)
hole_count_X = 3;     // 3 holes along X
hole_count_Y = 2;     // 2 holes along Y

// Hole spacing (centre-to-centre)
hole_spacing_X = 40;  // mm
hole_spacing_Y = 40;  // mm

// Wall dimensions
wall_length_X = 130;  // mm (matches plate length)
wall_thickness_Y = 4; // mm (matches plate width/thickness)
wall_height = 70;     // mm (total height from bed)

// --- Variables ---
// Calculate plate center
plate_center_X = plate_length_X / 2;
plate_center_Y = plate_width_Y / 2;

// Calculate hole positions (centered on plate)
// X positions: 3 holes, 40mm spacing, centered
hole_x_positions = [
    plate_center_X - (hole_spacing_X * (hole_count_X - 1)) / 2,
    plate_center_X,
    plate_center_X + (hole_spacing_X * (hole_count_X - 1)) / 2
];

// Y positions: 2 holes, 40mm spacing, centered
hole_y_positions = [
    plate_center_Y - (hole_spacing_Y * (hole_count_Y - 1)) / 2,
    plate_center_Y + (hole_spacing_Y * (hole_count_Y - 1)) / 2
];

// --- Construction ---

// 1. Base Plate
// A flat plate 130x90x4 lying on Z=0
base_plate = translate([0, 0, 0], 
    cube([plate_length_X, plate_width_Y, plate_thickness])
);

// 2. Through Holes
// Create a difference operation to cut holes through the plate
// Rule 5: Extend cutting shapes slightly past faces (0.01mm) to ensure clean cut
hole_cutting_shape = cylinder(
    h = plate_thickness + 0.01,
    r = hole_diameter / 2
);

// Loop to create holes at calculated positions
holes = for (x = hole_x_positions, y = hole_y_positions) {
    translate([x, y, 0], hole_cutting_shape)
};

// 3. Side Walls
// Two solid walls running along the long edges (X-axis).
// Each wall is 130mm long, 4mm thick, rising from Z=0 to Z=70.
// They are flush with the plate's long edge.
// Plate Y range: -45 to 45. Edge is at -45 and 45.
// Wall thickness is 4mm.
// Left Wall Y range: -47 to -43. Center Y = -45.
// Right Wall Y range: 43 to 47. Center Y = 45.

// Define wall geometry
wall_block = cube([wall_length_X, wall_thickness_Y, wall_height]);

// Position Left Wall
left_wall_pos = [plate_center_X, plate_center_Y - plate_width_Y/2 - wall_thickness_Y/2, 0];

// Position Right Wall
right_wall_pos = [plate_center_X, plate_center_Y + plate_width_Y/2 + wall_thickness_Y/2, 0];

// Combine everything
// Final object = (Plate with holes) UNION (Left Wall) UNION (Right Wall)
part = union([
    // Plate with holes
    difference([
        base_plate,
        holes
    ]),
    // Left Wall
    translate(left_wall_pos, wall_block),
    // Right Wall
    translate(right_wall_pos, wall_block)
]);

// Output the final part
part;