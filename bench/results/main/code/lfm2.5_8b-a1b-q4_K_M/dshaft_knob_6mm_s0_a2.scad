// Knob for hotplate stirrer
$cyl_diameter = 30 mm;
$cyl_height = 15 mm;

$blind_diameter = 6.2 mm;
$blind_depth = 12 mm;

// Base cylinder (knob body)
$c = linear_extrude($cyl_diameter, $cyl_height);

// D-shaped blind bore (rectangular hole) from z=0 to 12 mm
$rect = polygon($blind_diameter, $blind_depth, 0, 0, $blind_diameter, $blind_depth, 0, $blind_depth);
$blind_shape = linear_extrude($rect, $cyl_height);
$knob = $difference