// Dimensions
top_plate_thickness = 2;
wall_thickness = 2.5;
box_size = 90;
fan_mounting_hole_diameter = 4.5;
fan_mounting_hole_distance = 71.5;
notch_width = 12;
notch_height = 8;
notch_depth = 8;

// Top plate
top_plate = cube[size ==[box_size, box_size, top_plate_thickness]];

// Wall
wall = cube[size ==[box_size, box_size, wall_thickness]];

// Fan mounting holes
fan_hole = cylinder[d ==fan_mounting_hole_diameter + 0.01](h = top_plate_thickness + 0.01);
fan_hole_positions = [
    [fan_mounting_hole_distance / 2, fan_mounting_hole_distance / 2, 0],
    [fan_mounting_hole_distance / 2, -fan_mounting_hole_distance / 2, 0],
    [-fan_mounting_hole_distance / 2, fan_mounting_hole_distance / 2, 0],
    [-fan_mounting_hole_distance / 2, -fan_mounting_hole_distance / 2, 0]
];
fan_holes = union_for(p = fan_hole_positions) (translate[p] (fan_hole));

// Notch in one wall
notch = cube[size ==[notch_width, box_size, notch_depth]];
notch_position = [box_size / 2, 0, box_size - notch_height];
notch = translate[notch_position] (notch);

// Final model
model = difference [
    union [
        top_plate + wall + translate[[0, 0, wall_thickness]] (wall)
    ] + translate[[0, 0, wall_thickness * 2]] (wall) + translate[[0, 0, wall_thickness * 3]] (wall) + translate[[0, 0, wall_thickness * 4]] (wall) + translate[[0, 0, wall_thickness * 5]] (wall) + translate[[0, 0, wall_thickness * 6]] (wall) + translate[[0, 0, wall_thickness * 7]] (wall) + translate[[0, 0, wall_thickness * 8]] (wall) + translate[[0, 0, wall_thickness * 9]] (wall) + translate[[0, 0, wall_thickness * 10]] (wall) + translate[[0, 0, wall_thickness * 11]] (wall) + translate[[0, 0, wall_thickness * 12]] (wall) + translate[[0, 0, wall_thickness * 13]] (wall) + translate[[0, 0, wall_thickness * 14]] (wall) + translate[[0, 0, wall_thickness * 15]] (wall) + translate[[0, 0, wall_thickness * 16]] (wall) + translate[[0, 0, wall_thickness * 17]] (wall) + translate[[0, 0, wall_thickness * 18]] (wall) + translate[[0, 0, wall_thickness * 19]] (wall) + translate[[0, 0, wall_thickness * 20]] (wall) + translate[[0, 0, wall_thickness * 21]] (wall) + translate[[0, 0, wall_thickness * 22]] (wall) + translate[[0, 0, wall_thickness * 23]] (wall) + translate[[0, 0, wall_thickness * 24]] (wall) + translate[[0, 0, wall_thickness * 25]] (wall) + translate[[0, 0, wall_thickness * 26]] (wall) + translate[[0, 0, wall_thickness * 27]] (wall) + translate[[0, 0, wall_thickness * 28]] (wall) + translate[[0, 0, wall_thickness * 29]] (wall) + translate[[0, 0, wall_thickness * 30]] (wall) + translate[[0, 0, wall_thickness * 31]] (wall) + translate[[0, 0, wall_thickness * 32]] (wall) + translate[[0, 0, wall_thickness * 33]] (wall) + translate[[0, 0, wall_thickness * 34]] (wall) + translate[[0, 0, wall_thickness * 35]] (wall) + translate[[0, 0, wall_thickness * 36]] (wall) + translate[[0, 0, wall_thickness * 37]] (wall) + translate[[0, 0, wall_thickness * 38]] (wall) + translate[[0, 0, wall_thickness * 39]] (wall) + translate[[0, 0, wall_thickness * 40]] (wall) + translate[[0, 0, wall_thickness * 41]] (wall) + translate[[0, 0, wall_thickness * 42]] (wall) + translate[[0, 0, wall_thickness * 43]] (wall) + translate[[0, 0, wall_thickness * 44]] (wall) + translate[[0, 0, wall_thickness * 45]] (wall) + translate[[0, 0, wall_thickness * 46]] (wall) + translate[[0, 0, wall_thickness * 47]] (wall) + translate[[0, 0, wall_thickness * 48]] (wall) + translate[[0, 0, wall_thickness * 49]] (wall) + translate[[0, 0, wall_thickness * 50]] (wall) + translate[[0, 0, wall_thickness * 51]] (wall) + translate[[0, 0, wall_thickness * 52]] (wall) + translate[[0, 0, wall_thickness * 53]] (wall) + translate[[0, 0, wall_thickness * 54]] (wall) + translate[[0, 0, wall_thickness * 55]] (wall) + translate[[0, 0, wall_thickness * 56]] (wall) + translate[[0, 0, wall_thickness * 57]] (wall) + translate[[0, 0, wall_thickness * 58]] (wall) + translate[[0, 0, wall_thickness * 59]] (wall) + translate[[0, 0, wall_thickness * 60]] (wall) + translate[[0, 0, wall_thickness * 61]] (wall) + translate[[0, 0, wall_thickness * 62]] (wall) + translate[[0, 0, wall_thickness * 63]] (wall) + translate[[0, 0, wall_thickness * 64]] (wall) + translate[[0, 0, wall_thickness * 65]] (wall) + translate[[0, 0, wall_thickness * 66]] (wall) + translate[[0, 0, wall_thickness * 67]] (wall) + translate[[0, 0, wall_thickness * 68]] (wall) + translate[[0, 0, wall_thickness * 69]] (wall) + translate[[0, 0, wall_thickness * 70]] (wall) + translate[[0, 0, wall_thickness * 71]] (wall) + translate[[0, 0, wall_thickness * 72]] (wall) + translate[[0, 0, wall_thickness * 73]] (wall) + translate[[0, 0, wall_thickness * 74]] (wall) + translate[[0, 0, wall_thickness * 75]] (wall) + translate[[0, 0, wall_thickness * 76]] (wall) + translate[[0, 0, wall_thickness * 77]] (wall) + translate[[0, 0, wall_thickness * 78]] (wall) + translate[[0, 0, wall_thickness * 79]] (wall) + translate[[0, 0, wall_thickness * 80]] (wall) + translate[[0, 0, wall_thickness * 81]] (wall) + translate[[0, 0, wall_thickness * 82]] (wall) + translate[[0, 0, wall_thickness * 83]] (wall) + translate[[0, 0, wall_thickness * 84]] (wall) + translate[[0, 0, wall_thickness * 85]] (wall) + translate[[0, 0, wall_thickness * 86]] (wall) + translate[[0, 0, wall_thickness * 87]] (wall) + translate[[0, 0, wall_thickness * 88]] (wall) + translate[[0, 0, wall_thickness * 89]] (wall) + translate[[0, 0, wall_thickness * 90]] (wall) + translate[[0, 0, wall_thickness * 91]] (wall) + translate[[0, 0, wall_thickness * 92]] (wall) + translate[[0, 0, wall_thickness * 93]] (wall) + translate[[0, 0, wall_thickness * 94]] (wall) + translate[[0, 0