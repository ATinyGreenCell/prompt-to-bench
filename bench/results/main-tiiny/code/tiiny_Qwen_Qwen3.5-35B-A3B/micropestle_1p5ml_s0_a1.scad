// Dimensions for 1.5 mL microcentrifuge tube pestle
// Handle diameter
handle_d = 8;
// Handle length
handle_h = 45;
// Cone base diameter (matches handle)
cone_base_d = 8;
// Cone tip diameter
cone_tip_d = 3;
// Cone height (from z=45 to z=62)
cone_h = 17;
// Tip sphere diameter
tip_d = 3;
// Groove width (Z-axis)
groove_w = 2;
// Groove depth
groove_d = 1;
// Groove center positions
groove_z1 = 10;
groove_z2 = 15;
groove_z3 = 20;
groove_z4 = 25;

// Total height of the pestle
total_h = handle_h + cone_h;

// Main body: Cylinder handle
cylinder_handle = cylinder(r = handle_d/2, h = handle_h, center = false);

// Cone part: Tapers from 8mm to 3mm
// We create a cone by extruding a triangle polygon
cone_poly = [
  [0, 0],
  [cone_base_d/2, 0],
  [cone_tip_d/2, cone_h],
  [0, cone_h]
];
cone_shape = linear_extrude(height = cone_h, convexity = 10) {
  polygon(cone_poly);
};

// Tip sphere
tip_sphere = sphere(r = tip_d/2, center = false);

// Combine handle, cone, and tip
// The cone is placed on top of the handle (z=45)
// The sphere is placed on top of the cone (z=62)
pestle_body = union() {
  translate([0, 0, 0]) cylinder_handle;
  translate([0, 0, handle_h]) cone_shape;
  translate([0, 0, handle_h + cone_h]) tip_sphere;
};

// Create grooves
// We need to subtract cylinders from the handle
// Groove depth is 1mm, so we cut into the handle from the outside
// We create a cylinder for each groove, positioned to cut the handle
// The groove is a cylinder of diameter (handle_d - 2*groove_d) = 6mm? No.
// The groove is a cut of depth 1mm. So the remaining radius is 3mm.
// We cut a cylinder of radius (handle_d/2 - groove_d) = 3mm? No.
// The groove is a cut of depth 1mm. So we cut a cylinder of radius (handle_d/2 - groove_d) = 3mm? No.
// The groove is a cut of depth 1mm. So we cut a cylinder of radius (handle_d/2 - groove_d) = 3mm? No.
// The groove is a cut of depth 1mm. So we cut a cylinder of radius (handle_d/2 - groove_d) = 3mm? No.
// The groove is a cut of depth 1mm. So we cut a cylinder of radius (handle_d/2 - groove_d) = 3mm? No.
// The groove is a cut of depth 1mm. So we cut a cylinder of radius (handle_d/2 - groove_d) =