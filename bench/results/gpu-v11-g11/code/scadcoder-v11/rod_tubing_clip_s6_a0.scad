// Tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded upward in +Z

// ---------------- Parameters ----------------
rod_d      = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
ring_od    = rod_d + 2 * ring_w;  // rod ring outer diameter (18.7 mm)
ring_id    = rod_d;  // rod ring inner diameter (12.7 mm)

tub_d      = 6;      // tubing ring inner diameter
tub_w      = 2;      // tubing ring wall thickness
tub_od     = tub_d + 2 * tub_w;  // tubing ring outer diameter (10 mm)
tub_x      = 15;     // tubing ring centre X position

bridge_x0  = 8;      // bridge start (X)
bridge_x1  = 12;     // bridge end (X)
bridge_w   = 6;      // bridge width (Y)

eps        = 0.5;    // overcut for clean boolean differences

$fn = 96;            // curve resolution

// ---------------- Profile ----------------
// 2-D profile drawn in the XY plane (y = 0), counter-clockwise
profile_pts = [
    // Rod ring: outer circle centred at origin
    [0, 0, ring_od / 2],
    // Tubing ring: outer circle centred at x = 15
    [tub_x, 0, tub_od / 2],
    // Solid bridge between the two rings
    [bridge_x1, 0, ring_od / 2],
    // Return along the top face (over the bridge)
    [bridge_x0, 0, ring_od / 2]
];

// ---------------- Model ----------------
difference() {
    // Extrude the profile along Z, then rotate so the profile lies in XY
    translate([0, 0, 0])
        linear_extrude(height = 10)
            polygon(points = profile_pts);

    // Rod ring opening: inner circle (10 mm wide, centred at origin)
    translate([0, 0, -eps])
        cylinder(d = ring_id, h = 10 + 2 * eps);

    // Tubing ring opening: 4.5 mm wide slot on the +X side
    translate([tub_x, 0, -eps])
        linear_extrude(height = 10 + 2 * eps)
            polygon(points = [
                [tub_x + tub_w, -tub_d / 2],
                [tub_x + tub_w,  tub_d / 2],
                [tub_x,          tub_d / 2],
                [tub_x,         -tub_d / 2]
            ]);
}