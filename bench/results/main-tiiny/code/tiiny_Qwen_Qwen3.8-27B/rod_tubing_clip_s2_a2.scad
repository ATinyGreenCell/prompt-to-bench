// Snap-on clip for a 12.7 mm lab stand rod, holding a 6 mm ID tube.
// Printed flat: 10 mm tall extrusion (Z) of a 2-D profile in XY.

// ---- Dimensions (mm) ----
rod_id   = 12.7;   // rod ring inner diameter
rod_wall = 3.0;    // rod ring wall thickness
rod_od   = rod_id + 2*rod_wall;   // 18.7

tube_id  = 6.0;    // tubing ring inner diameter
tube_wall= 2.0;    // tubing ring wall thickness
tube_od  = tube_id + 2*tube_wall; // 10.0

rod_cx   = 0.0;    // rod ring centre X
rod_cy   = 0.0;    // rod ring centre Y

tube_cx  = 15.0;   // tubing ring centre X
tube_cy  = 0.0;    // tubing ring centre Y

rod_open_w = 10.0; // rod ring opening width (Y)
tube_open_w= 4.5;  // tubing ring opening width (Y)

bridge_x0  = 8.0;  // bridge start X
bridge_x1  = 12.0; // bridge end X
bridge_w   = 6.0;  // bridge width (Y)

extrude_h  = 10.0; // print height (Z)

$fn = 64;

// ---- 2-D profile (XY plane) ----
profile = difference(
    union(
        // (1) Rod ring: annulus centred at origin
        difference(
            circle(d = rod_od),
            circle(d = rod_id)
        ),
        // (2) Tubing ring: annulus centred at (15, 0)
        difference(
            translate([tube_cx, tube_cy]) circle(d = tube_od),
            translate([tube_cx, tube_cy]) circle(d = tube_id)
        ),
        // (3) Solid bridge joining the two rings
        translate([bridge_x0, -bridge_w/2])
        square([bridge_x1 - bridge_x0, bridge_w])
    ),
    union(
        // Rod ring opening: remove everything with x < 0 and -5 < y < 5
        // (extended 1 mm past the ring faces to avoid coplanar cuts)
        translate([-1, -rod_open_w/2])
        square([1, rod_open_w]),

        // Tubing ring opening: remove everything with x > 15 and -2.25 < y < 2.25
        // (extended 1 mm past the ring faces to avoid coplanar cuts)
        translate([tube_cx, -tube_open_w/2])
        square([1, tube_open_w])
    )
);

// ---- Extrude 10 mm in +Z, resting on z = 0 ----
linear_extrude(height = extrude_h, center = false)
    profile;