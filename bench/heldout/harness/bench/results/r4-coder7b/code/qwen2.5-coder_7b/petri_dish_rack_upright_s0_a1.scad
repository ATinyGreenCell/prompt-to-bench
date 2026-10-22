// Dimensions
petri_dish_height = 90;
base_length = 203;
base_width = 80;
base_height = 20;
cradle_radius = 46;
cradle_y_position = 0;
cradle_z_position = 52;
divider_thickness = 3;
divider_spacing = 20;
num_dividers = 11;

// Base
base = cube([base_length, base_width, base_height]);

// Cradle
cradle = cylinder(r=cradle_radius, h=6, center=true) - 
          translate([0, cradle_y_position, cradle_z_position]) -
          linear_extrude(height=0.1) (circle(r=cradle_radius));

// Divider plates
dividers = union() {
  for (x = [-100:divider_spacing:100]) {
    cube([divider_thickness, base_width, 60])
      translate([x, base_width/2 - divider_thickness/2, 0]);
  }
};

// Final model
difference() {
  base;
  cradle;
  dividers;
}