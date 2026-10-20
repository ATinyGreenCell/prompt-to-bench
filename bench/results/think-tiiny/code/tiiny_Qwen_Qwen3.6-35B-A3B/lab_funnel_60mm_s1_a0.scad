// Lab funnel dimensions
spout_od = 10;            // Outer diameter of straight spout
spout_bottom_z = 0;       // Z position of spout bottom
spout_top_z = 20;         // Z position where spout meets cone
cone_top_od = 10;         // Outer diameter at cone top (matches spout)
cone_bottom_od = 60;      // Outer diameter at cone rim
cone_top_z = 20;          // Z position of cone top
cone_bottom_z = 50;       // Z position of cone rim
wall_thickness = 1.6;     // Wall thickness everywhere

// Calculate radii
spout_or = spout_od / 2;
spout_ir = (spout_od - 2 * wall_thickness) / 2;
cone_or = cone_bottom_od / 2;
cone_ir = (cone_bottom_od - 2 * wall_thickness) / 2;

// Define 2D cross-section of the wall (r, z)
// Traces the material from inner bottom, up inner wall, across top rim, down outer wall, across bottom rim
pts = [
  [spout_ir, spout_bottom_z],
  [spout_ir, spout_top_z],
  [cone_ir, cone_bottom_z],
  [cone_or, cone_bottom_z],
  [cone_or, spout_top_z],
  [spout_or, spout_top_z],
  [spout_or, spout_bottom_z]
];

// Revolve the cross-section to create the solid funnel
rotate_extrude($fn = 64) polygon(pts);