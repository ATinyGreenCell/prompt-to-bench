// Snap-on clip that holds a piece of tubing next to a 12.7 mm (1/2 inch) lab stand rod.
// Printed flat: a 10 mm tall extrusion (Z) of a 2-D profile in the XY plane.
//
// Profile (counter-clockwise):
//   1) Rod ring: 12.7 mm inner diameter, 3 mm wall (18.7 mm outer diameter),
//      centred at origin, with a 10 mm wide opening cut from its -X side
//      (everything with x < 0 and -5 < y < 5 is removed).
//   2) Tubing ring: 6 mm inner diameter, 2 mm wall, centred at x = 15, y = 0,
//      with a 4.5 mm wide opening cut from its +X side (x > 15, -2.25 < y < 2.25).
//   3) Solid bridge: 6 mm wide (Y) between x = 8 and x = 12, joining the two rings
//      without blocking either ring's hole.

// ---------------- Parameters ----------------
rod_id        = 12.7;   // rod inner diameter (1/2 inch)
rod_wall      = 3;      // rod ring wall thickness
rod_open      = 10;     // width of opening cut from -X side of rod ring
rod_open_h    = 10;     // height of opening cut (Y span)

tub_id        = 6;      // tubing inner diameter
tub_wall      = 2;      // tubing ring wall thickness
tub_open      = 4.5;    // width of opening cut from +X side of tubing ring
tub_open_h    = 4.5;    // height of tubing opening (Y span)

bridge_x1     = 8;      // bridge start (X)
bridge_x2     = 12;     // bridge end (X)
bridge_w      = 6;      // bridge width (Y)

eps           = 0.5;    // cutter overshoot past faces
$fn           = 96;     // curve resolution

// ---------------- Profile ----------------
// 2-D outline (X, Y), counter-clockwise
profile_pts = concat(
    // Rod ring
    [
        [0, -rod_open_h/2],
        [0, rod_open_h/2],
        for (a = [0 : 10 : 90])
            [ (a > 0 ? rod_open : 0) + (rod_id/2 + rod_wall) * cos(a),
              (rod_id/2 + rod_wall) * sin(a) ],
        [ 18.7, 0 ]
    ],
    // Tubing ring
    [
        [15, -tub_open_h/2],
        [15, tub_open_h/2],
        for (a = [0 : 10 : 90])
            [ 15 + (tub_id/2 + tub_wall) * cos(a),
              (tub_id/2 + tub_wall) * sin(a) ],
        [ 21, 0 ]
    ],
    // Bridge between the two rings
    [ [bridge_x2, -bridge_w/2], [bridge_x2, bridge_w/2] ]
);

// ---------------- Model ----------------
difference() {
    // Profile extrusion
    linear_extrude(height = 10)
        polygon(points = profile_pts);

    // Rod ring opening (extends past -X face)
    translate([-eps, -rod_open_h/2, 0])
        cube([eps, rod_open_h, 10 + 2*eps]);

    // Tubing ring opening (extends past +X face)
    translate([15, -tub_open_h/2, 0])
        cube([tub_open + 2*eps, tub_open_h, 10 + 2*eps]);
}