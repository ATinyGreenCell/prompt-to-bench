// Define dimensions for the enclosure
$size = {70, 50, 30};
$wall_width = 2;
$floor_width = 2;
$top_height = 2;

// Define dimensions for the lid
$lid_width = 65.6;
$lid_height = 45.6;
$lid_thickness = 1.5;

// Create the box
box($size, $wall_width, $floor_width, $top_height);

// Create the lid
cube($lid_width, $lid_height, $lid_thickness);
translate({0, -$lid_height/2, 0}); // Place the lid on the +X side of the box

// Print the enclosure to a valid solid with no errors
print("enclosure.sld");