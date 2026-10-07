// Dimensions in millimetres
Z_height      = 10;          // 10 mm tall extrusion (Z)
rod_inner_d   = 12.7;        // 12.7 mm inner diameter of lab stand rod
rod_wall_thick= 3;           // 3 mm wall thickness -> outer diameter = 18.7 mm
tube_ring_i   = 6;           // 6 mm inner diameter of tubing ring
tube_ring_w   = 2;           // 2 mm wall thickness
bridge_width  = 6;            // bridge is 6 mm wide in Y direction (total span)
opening_rod_x = -5;          // y range for rod opening: [-5, 5]
opening_tube_y_low = -2.25;   // tube opening low bound (-2.25 <= y <= 2.25)
opening_tube_y_high= 2.25;    // tube opening high bound

// Build the clip as a flat extrusion in XY plane at Z = 0 to Z = Z_height (10 mm).
// The part is centered on the origin in X and Y, resting on the XY plane (z=0) and extending upward (+Z).

// Define the rod ring: outer radius = (rod_inner_d/2 + rod_wall_thick) = 9.35 mm.
// We model it as a solid cylinder of height Z_height, centered at origin in XY plane.
rod_ring = translate([0,0,0]) * cylinder(h=Z_height, r=(rod_inner_d/2 + rod_wall_thick), $fn=64);

// Define the tubing ring: outer radius = (tube_ring_i/2 + tube_ring_w) = 4 mm.
// Centered at x=15, y=0 in XY plane; we translate it appropriately.
tube_ring = translate([15,0,0]) * cylinder(h=Z_height, r=(tube_ring_i/2 + tube_ring_w), $fn=64);

// Define the bridge: a solid rectangular prism that joins the two rings between x = 8 and x = 12.
// Bridge spans X from 8 to 12 (width = 4 mm) and Y from -2.25 to +2.25 (total span = 4.5 mm), height Z_height.
bridge = translate([8, -opening_tube_y_low, 0]) * cube([4, opening_tube_y_high - (-opening_tube_y_low), Z_height], $fn=64);

// Combine all parts: union of rod ring, tube ring, and bridge.
clip = union([rod_ring, tube_ring, bridge]);