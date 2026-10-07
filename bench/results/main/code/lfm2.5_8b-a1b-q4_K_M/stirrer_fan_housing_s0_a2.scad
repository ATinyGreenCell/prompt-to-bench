// dimensions in mm
$top_width = 45;
$top_depth = 45;
$wall_thickness = 2.5;
$top_plate_thickness = 2;
$hole_diameter = 4.5; // for screw holes

// top plate with screw hole pockets
top_plate = cube([$top_width, $top_depth, $top_plate_thickness]);

// create cylindrical voids for M4 screw holes
hole_shape = cylinder([0, 0, $top_plate_thickness], [hole_diameter/2, hole_diameter/2, $top_plate_thickness]);

// four screw hole pockets
hole1 = translate(hole_shape, [-$top_width/2, 0, 0]);
hole2 = translate(hole_shape, [ $top_width/2, 0, 0]);
hole3 = translate(hole_shape, [-$top_width/2, 0, 0]);
hole4 = translate(hole_shape, [ 0, -$top_depth/2, 0]);

top_plate = difference(top_plate, hole1);
top_plate = difference(top_plate, hole2);
top_plate = difference(top_plate, hole3);
top_plate = difference(top_