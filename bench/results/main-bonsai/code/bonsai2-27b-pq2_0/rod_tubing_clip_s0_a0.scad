// Snap-on clip for a 12.7 mm lab-stand rod and a 6 mm tube.
// Printed flat: 10 mm tall extrusion of a 2-D profile in the XY plane.
// The part rests on the XY plane at z = 0 and builds upward (+Z).

// ---- Dimensions (mm) ----
rod_id        = 12.7;   // inner diameter of rod ring
rod_wall      = 3.0;    // wall thickness of rod ring
rod_od        = rod_id + 2 * rod_wall; // 18.7
rod_open_w    = 10.0;   // width of snap opening on -X side
rod_open_h    = 10.0;   // height of snap opening (y extent)

tube_id       = 6.0;    // inner diameter of tubing ring
tube_wall     = 2.0;    // wall thickness of tubing ring
tube_od       = tube_id + 2 * tube_wall; // 10.0
tube_cx       = 15.0;   // centre x of tubing ring
tube_open_w   = 4.5;    // width of opening on +X side
tube_open_h   = 4.5;    // height of opening (y extent)

bridge_x0     = 8.0;    // left edge of bridge (x)
bridge_x1     = 12.0;   // right edge of bridge (x)
bridge_w      = 6.0;    // width of bridge (y)

height        = 10.0;   // extrusion height (Z)

// ---- Curvature resolution ----
$fn = 64;

// ---- 2-D profile (XY plane) ----
// (1) Rod ring: annulus centred at origin, with a 10 mm opening on the -X side.
// (2) Tubing ring: annulus centred at (15, 0), with a 4.5 mm opening on the +X side.
// (3) Solid bridge: 6 mm wide (Y) rectangle from x = 8 to x = 12.

// Rod ring (annulus)
rod_ring = difference(
    circle(d = rod_od),
    circle(d = rod_id)
);

// Tubing ring (annulus)
tube_ring = difference(
    circle(d = tube_od),
    circle(d = tube_id)
);

// Bridge (solid rectangle)
bridge = square([bridge_x1 - bridge_x0, bridge_w], center = false);

// Combine the three profile elements
profile = union(
    rod_ring,
    translate([tube_cx, 0]) * tube_ring,
    translate([bridge_x0, -bridge_w / 2]) * bridge
);

// Snap opening on the -X side of the rod ring:
// remove everything with x < 0 and -5 < y < 5.
// The cutting block extends 0.5 mm past the x = 0 face and 0.5 mm past y = ±5.
rod_opening = square([0.5 + 5, rod_open_h + 1], center = false);
profile = difference(
    profile,
    translate([-5.5, -5.5]) * rod_opening
);

// Opening on the +X side of the tubing ring:
// remove everything with x > 15 and -2.25 < y < 2.25.
// The cutting block extends 0.5 mm past the x = 15 face and 0.5 mm past y = ±2.25.
tube_opening = square([0.5 + 2.25, tube_open_h + 1], center = false);
profile = difference(
    profile,
    translate([tube_cx + 2.25, -2.75]) * tube_opening
);

// ---- Extrude the profile to 10 mm height ----
linear_extrude(height = height) profile;