// Snap-on clip that holds a piece of tubing next to a 12.7 mm (1/2 inch) lab stand rod.
// Printed flat: a 10 mm tall extrusion (Z) of a 2-D profile in the XY plane.
//
// Profile (in the XY plane):
//   1) A rod ring with 12.7 mm inner diameter and 3 mm wall (18.7 mm outer diameter),
//      centred at the origin, with a 10 mm wide opening cut out of its -X side
//      (everything with x < 0 and -5 < y < 5 is removed from this ring).
//      This snaps onto the rod.
//   2) A tubing ring with 6 mm inner diameter and 2 mm wall, centred at x = 15, y = 0,
//      with a 4.5 mm wide opening cut out of its +X side (x > 15 and -2.25 < y < 2.25).
//   3) A solid bridge 6 mm wide (Y) between x = 8 and x = 12 that joins the two rings
//      without blocking either ring's hole.

// ---------- Parameters ----------
rod_id        = 12.7;   // stand rod inner diameter
rod_wall      = 3;      // stand rod ring wall thickness
ring_open     = 10;     // stand rod ring opening width (along Y)
ring_open_x   = -0;     // stand rod ring opening centre X

tubing_id     = 6;      // tubing inner diameter
tubing_wall   = 2;      // tubing ring wall thickness
tubing_open   = 4.5;    // tubing ring opening width (along Y)
tubing_x      = 15;     // tubing ring centre X

bridge_w      = 6;      // bridge width (along Y)
bridge_x1     = 8;      // bridge start X
bridge_x2     = 12;     // bridge end X

eps           = 0.5;    // cutter overshoot past faces
$fn           = 96;     // curve resolution

// ---------- Derived ----------
rod_od    = rod_id + 2 * rod_wall;   // 18.7 mm
tubing_od = tubing_id + 2 * tubing_wall; // 10 mm

// ---------- Profile ----------
difference() {
    union() {
        // Stand rod ring
        translate([0, 0, 0])
            cylinder(d = rod_od, h = 10);
        // Stand rod ring opening (x < 0, -ring_open/2 < y < ring_open/2)
        translate([ring_open_x - eps, -ring_open / 2, 0])
            cube([eps + 2 * rod_od, ring_open, 10 + eps]);

        // Tubing ring
        translate([tubing_x, 0, 0])
            cylinder(d = tubing_od, h = 10);
        // Tubing ring opening (x > tubing_x, -tubing_open/2 < y < tubing_open/2)
        translate([tubing_x + eps, -tubing_open / 2, 0])
            cube([eps + 2 * tubing_od, tubing_open, 10 + eps]);

        // Solid bridge between x = 8 and x = 12
        translate([bridge_x1, -bridge_w / 2, 0])
            cube([bridge_x2 - bridge_x1 + eps, bridge_w, 10 + eps]);
    }
}