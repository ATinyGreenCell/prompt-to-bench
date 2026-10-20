// Snap-on clip for a 12.7 mm lab stand rod, printed flat (10 mm Z extrusion).
// Rests on the XY plane at z = 0 and builds upward (+Z), centred on the origin in X/Y.

// ---- Named dimensions (mm) ----
rod_id   = 12.7;   // rod ring inner diameter
rod_wall = 3.0;    // rod ring wall thickness
rod_od   = rod_id + 2 * rod_wall;   // 18.7 outer diameter

tube_id  = 6.0;    // tubing ring inner diameter
tube_wall = 2.0;   // tubing ring wall thickness
tube_od  = tube_id + 2 * tube_wall; // 10.0 outer diameter

rod_open_w  = 10.0;   // rod ring opening width (Y)
rod_open_h  = 10.0;   // rod ring opening height (X)

tube_open_w = 4.5;    // tubing ring opening width (Y)
tube_open_h = 10.0;   // tubing ring opening height (X)

bridge_x0 = 8.0;      // bridge start X
bridge_x1 = 12.0;     // bridge end X
bridge_w  = 6.0;      // bridge width (Y)

tube_cx   = 15.0;     // tubing ring centre X
tube_cy   = 0.0;      // tubing ring centre Y

height    = 10.0;     // extrusion height (Z)

$fn = 64;

// ---- 2-D profile in the XY plane ----
profile = union() {
    // (1) Rod ring: annulus with a 10 mm wide opening cut from its -X side
    difference() {
        difference() {
            circle(d = rod_od);
            circle(d = rod_id);
        }
        // Opening: everything with x < 0 and -5 < y < 5
        translate([-10, -5]) square([10, 10], center = false);
    }

    // (2) Tubing ring: annulus with a 4.5 mm wide opening cut from its +X side
    difference() {
        difference() {
            translate([tube_cx, tube_cy]) circle(d = tube_od);
            translate([tube_cx, tube_cy]) circle(d = tube_id);
        }
        // Opening: x > 15 and -2.25 < y < 2.25
        translate([15, -2.25]) square([10, 4.5], center = false);
    }

    // (3) Solid bridge joining the two rings (6 mm wide in Y, x = 8..12)
    translate([bridge_x0, -bridge_w / 2])
        square([bridge_x1 - bridge_x0, bridge_w], center = false);
};

// ---- Extrude 10 mm in +Z, resting on z = 0 ----
linear_extrude(height = height, center = false)
    profile;