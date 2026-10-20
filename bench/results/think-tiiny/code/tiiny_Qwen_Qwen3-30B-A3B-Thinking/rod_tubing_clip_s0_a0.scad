// Snap-on clip for 12.7 mm lab stand rod and 6 mm tubing
// Units: millimetres

// Define dimensions
rod_inner_dia = 12.7;      // inner diameter of the rod ring (for the rod)
rod_wall = 3;               // wall thickness of the rod ring
rod_outer_dia = rod_inner_dia + 2 * rod_wall; // 18.7 mm
rod_outer_radius = rod_outer_dia / 2;

tube_inner_dia = 6;           // inner diameter of the tubing ring (for the tubing)
tube_wall = 2;                // wall thickness of the tubing ring
tube_outer_dia = tube_inner_dia + 2 * tube_wall; // 10 mm
tube_outer_radius = tube_outer_dia / 2;

// Opening dimensions (for the rod ring: 10 mm wide in Y, and the X extent is from -rod_outer_radius to 0)
rod_opening_width_Y = 10;     // from y = -5 to y = 5 (10 mm)
rod_opening_width_X = rod_outer_radius; // from x = -rod_outer_radius to x = 0 (9.35 mm, but we use the radius for the cut)

// For the tubing ring: 4.5 mm wide in Y (from -2.25 to 2.25)
tube_opening_width_Y = 4.5; // 4.5 mm in Y
tube_opening_width_X = tube_outer_radius; // from x = 15 to x = 15 + tube_outer_radius (5 mm)

// Bridge dimensions
bridge_x_start = 8;         // x from 8 to 12
bridge_x_end = 12;
bridge_width_Y = 6;            // from y = -3 to y = 3 (6 mm)

// Safety extension for cuts (to avoid coplanar faces)
cut_extension = 0.01;

// Set for smooth circles
$fn = 64;

// Rod ring with opening
rod_ring = difference() {
  // Outer circle of the rod ring
  circle(r = rod_outer_radius);
  // Inner circle (hole for the rod)
  circle(r = rod_inner_dia / 2);
  // Cut the opening: rectangle for the rod ring's opening, extended by cut_extension
  translate([ -rod_outer_radius - cut_extension, -5 - cut_extension, 0 ])
    square([rod_outer_radius + cut_extension + 0.01, 10 + 2 * cut_extension], center = false);
};

// Tubing ring with opening (centered at (15, 0))
tube_ring = difference() {
  // Outer circle of the tubing ring
  translate([15, 0, 0])
    circle(r = tube_outer_radius);
  // Inner circle (hole for the tubing)
  translate([15, 0, 0])
    circle(r = tube_inner_dia / 2);
  // Cut the opening: rectangle for the tubing ring's opening, extended by cut_extension
  translate([15 - cut_extension, -2.25 - cut_extension, 0])
    square([tube_outer_radius + 2 * cut_extension, tube_opening_width_Y + 2 * cut_extension], center = false);
};

// Bridge (solid rectangle between the rings)
bridge = translate([ (bridge_x_start + bridge_x_end) / 2, 0, 0 ])
  square([bridge_x_end - bridge_x_start, bridge_width_Y], center = true);

// Combine the rod ring, tubing ring, and bridge
union() {
  rod_ring;
  tube_ring;
  bridge;
}

// Extrude the 2D profile 10 mm in Z (the Z-axis)
linear_extrude(height = 10) {
  // The entire profile is in the XY plane at Z=0, so we don't need to translate in Z for the extrusion.
  // The union() above is the 2D profile.
  union() {
    rod_ring;
    tube_ring;
    bridge;
  }
}