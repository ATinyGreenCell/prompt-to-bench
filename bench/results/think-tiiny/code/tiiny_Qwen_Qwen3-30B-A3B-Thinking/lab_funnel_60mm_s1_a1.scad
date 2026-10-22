$fn = 64;

// Dimensions in millimeters
spout_height = 20;          // Height of the straight spout (z=0 to z=20)
cone_height = 30;             // Height of the conical section (z=20 to z=50)
outer_diameter_spout = 10;       // Outer diameter of the spout (10 mm)
outer_diameter_cone_bottom = 10; // Outer diameter at base of cone (z=20)
outer_diameter_cone_top = 60;      // Outer diameter at rim (z=50)
wall_thickness = 1.6;              // Constant wall thickness (1.6 mm)

// Derived inner diameters (outer - 2 * wall_thickness)
inner_diameter_spout = outer_diameter_spout - 2 * wall_thickness;
inner_diameter_cone_bottom = outer_diameter_cone_bottom - 2 * wall_thickness;
inner_diameter_cone_top = outer_diameter_cone_top - 2 * wall_thickness;

// Outer shape: spout + cone
outer = union() {
  cylinder(h = spout_height, d = outer_diameter_spout, center = false);
  translate([0, 0, spout_height]) {
    cylinder(h = cone_height, d1 = outer_diameter_cone_bottom, d2 = outer_diameter_cone_top, center = false);
  }
};

// Inner hole: spout hole + cone hole (continuous hole)
inner_hole = union() {
  cylinder(h = spout_height, d = inner_diameter_spout, center = false);
  translate([0, 0, spout_height]) {
    cylinder(h = cone_height, d1 = inner_diameter_cone_bottom, d2 = inner_diameter_cone_top, center = false);
  }
};

// Final funnel (outer shape minus inner hole)
difference() {
  outer;
  inner_hole;
}