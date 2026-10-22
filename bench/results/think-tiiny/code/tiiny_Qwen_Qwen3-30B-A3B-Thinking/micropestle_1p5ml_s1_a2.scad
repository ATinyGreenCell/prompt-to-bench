$fn = 64;

// Dimensions in millimeters
handle_diameter = 8;
handle_height = 45;
cone_start_z = 45;
cone_end_z = 62;
cone_bottom_diameter = 8;
cone_top_diameter = 3;
sphere_diameter = 3;
sphere_center_z = 62;
groove_depth = 1;
groove_width_z = 2;
groove_height = groove_width_z + 0.02; // Extend 0.01mm beyond top/bottom for non-coplanar faces
groove_centers = [10, 15, 20, 25];

union() {
  // Handle with grooves (cylinder from z=0 to z=45 with grooves subtracted)
  difference() {
    cylinder(r = handle_diameter / 2, h = handle_height, center = false);
    for (z_center = groove_centers) {
      translate([0, 0, z_center - groove_height / 2])
        cylinder(r = handle_diameter / 2 - groove_depth, h = groove_height, center = false);
    }
  }
  
  // Cone (tapering from 8mm to 3mm, from z=45 to z=62)
  translate([0, 0, cone_start_z])
    cylinder(r1 = cone_bottom_diameter / 2, r2 = cone_top_diameter / 2, h = cone_end_z - cone_start_z, center = false);
  
  // Rounded tip (3mm diameter sphere centered at z=62)
  translate([0, 0, sphere_center_z])
    sphere(r = sphere_diameter / 2);
}