// Snap-on clip for a 12.7 mm lab stand rod, holding a 6 mm tube.
// Printed flat: 10 mm tall extrusion (Z) of a 2-D profile in XY.

// ---- Dimensions (mm) ----
rod_id   = 12.7;   // rod ring inner diameter
rod_wall = 3.0;    // rod ring wall thickness
rod_od   = rod_id + 2*rod_wall;   // 18.7 outer diameter

tube_id  = 6.0;    // tubing ring inner diameter
tube_wall= 2.0;    // tubing ring wall thickness
tube_od  = tube_id + 2*tube_wall; // 10.0 outer diameter

tube_cx  = 15.0;   // tubing ring centre X (Y = 0)

rod_open_w = 10.0; // rod ring opening width (Y)
rod_open_h = 10.0; // rod ring opening height (Z)

tube_open_w = 4.5; // tubing ring opening width (Y)
tube_open_h = 10.0; // tubing ring opening height (Z)

bridge_x0 = 8.0;   // bridge start X
bridge_x1 = 12.0;  // bridge end X
bridge_w  = 6.0;   // bridge width (Y)

extrude_h = 10.0;  // part height (Z)

$fn = 64;

// ---- 2-D profile in XY ----
module profile() { union() {
    // (1) Rod ring: annulus with a 10 mm wide opening on the -X side
    difference() {
        difference() {
            circle(d = rod_od);
            circle(d = rod_id);
        }
        // opening: everything with x < 0 and -5 < y < 5
        translate([-10, 0]) square([10, rod_open_w], center = [true, true]);
    }

    // (2) Tubing ring: annulus with a 4.5 mm wide opening on the +X side
    difference() {
        difference() {
            translate([tube_cx, 0]) circle(d = tube_od);
            translate([tube_cx, 0]) circle(d = tube_id);
        }
        // opening: x > 15 and -2.25 < y < 2.25
        translate([tube_cx, 0]) square([10, tube_open_w], center = [false, true]);
    }

    // (3) Solid bridge joining the two rings (does not block either hole)
    translate([bridge_x0, 0]) square([bridge_x1 - bridge_x0, bridge_w], center = [false, true]);
} }

// ---- Extrude 10 mm in Z (print orientation: rests on XY plane, builds +Z) ----
linear_extrude(height = extrude_h) profile();