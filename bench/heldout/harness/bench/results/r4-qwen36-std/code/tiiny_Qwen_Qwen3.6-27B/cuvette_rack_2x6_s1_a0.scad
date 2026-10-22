// Dimensions (mm)
base_x = 112;
base_y = 44;
base_z = 3;
deck_z_start = 22;
deck_z_end = 25;
deck_thickness = deck_z_end - deck_z_start;
wall_end_thickness = 3;
wall_rib_thickness = 2.5;
wall_depth = base_y;
wall_height = 25;
rib_positions = [-36, -18, 0, 18, 36];
hole_size = 13;
hole_spacing_x = 18;
hole_spacing_y = 18;
$fn = 64;

// Base plate
translate([0, 0, 0])
  cube([base_x, base_y, base_z], center = true);

// Deck plate
translate([0, 0, deck_z_start + deck_thickness / 2])
  cube([base_x, base_y, deck_thickness], center = true);

// End walls (flush with short ends, i.e., at y = +/- base_y/2)
// Left end wall
translate([0, -base_y / 2 + wall_end_thickness / 2, wall_height / 2])
  cube([base_x, wall_end_thickness, wall_height], center = true);

// Right end wall
translate([0, base_y / 2 - wall_end_thickness / 2, wall_height / 2])
  cube([base_x, wall_end_thickness, wall_height], center = true);

// Five ribs
for (x = rib_positions) {
  translate([x, 0, wall_height / 2])
    cube([wall_rib_thickness, wall_depth, wall_height], center = true);
}

// 12 square through-holes in deck: 2 rows (Y) x 6 columns (X)
// Centred on deck, spacing 18 mm
// X positions: -45, -27, -9, 9, 27, 45 (since 6 holes * 18 = 108 span, centred)
// Y positions: -9, 9 (since 2 holes * 18 = 36 span, centred)
hole_x_positions = [-45, -27, -9, 9, 27, 45];
hole_y_positions = [-9, 9];

for (hx = hole_x_positions) {
  for (hy = hole_y_positions) {
    translate([hx, hy, deck_z_start + deck_thickness / 2])
      cube([hole_size, hole_size, deck_thickness + 0.02], center = true);
  }
}