// Dimensions
rod_diameter = 12.7;
rod_wall = 3;
tubing_diameter = 6;
tubing_wall = 2;
opening_width = 10;
bridge_width = 6;
bridge_height = 10;

// Calculated dimensions
rod_outer_diameter = rod_diameter + 2 * rod_wall;
tubing_outer_diameter = tubing_diameter + 2 * tubing_wall;
opening_height = 10;

// Rod ring
rod_ring = cylinder2(rod_outer_diameter, rod_wall, opening_height, center=true);
opening = cylinder2(rod_diameter, rod_wall, opening_height, center=true, $fn=64) - cylinder2(rod_diameter - opening_width, rod_wall, opening_height, center=true, $fn=64);
rod_cutout = translate [-opening_width/2 + 0.015 * rod_diameter / 2 + rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall / 2 + 0.015 * rod_wall /