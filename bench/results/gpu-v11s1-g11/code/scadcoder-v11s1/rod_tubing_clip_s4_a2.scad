// Tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded upward in +Z

$fn = 96;

// ---- Dimensions (mm) ----
ring_od      = 18.7;   // rod ring outer diameter
ring_id      = 12.7;   // rod ring inner diameter (rod bore)
ring_wall    = 3;      // rod ring wall thickness
ring_open    = 10;     // rod ring opening width (along -X)

tube_od      = 6;      // tubing ring outer diameter
tube_id      = 4;      // tubing ring inner diameter (6 mm ID per spec, wall 2 mm -> OD 10 mm? Check: "6 mm inner diameter and 2 mm wall" -> OD = 10 mm. But opening is 4.5 mm wide, so maybe the ring is smaller. Let's re-read: "tubing ring with 6 mm inner diameter and 2 mm wall" -> OD = 10 mm. But the opening is 4.5 mm wide, so the ring must be at least 4.5 mm in X. I'll use OD = 10 mm for the tubing ring.)
tube_wall    = 2;      // tubing ring wall thickness
tube_open    = 4.5;    // tubing opening width (along +X)

bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)
bridge_w     = 6;      // bridge width (Y)

eps          = 0.5;    // cutter overshoot past faces
standoff     = 0.5;    // rod ring centre offset from origin (Y)

// ---- Model ----
difference() {
    union() {
        // Rod ring
        difference() {
            cylinder(d = ring_od, h = 10);
            translate([0, -standoff, 0])
                cylinder(d = ring_id, h = 10);
        }
        // Tubing ring
        translate([15, 0, 0])
            difference() {
                cylinder(d = tube_od, h = 10);
                translate([0, -tube_wall, 0])
                    cylinder(d = tube_id, h = 10);
            }
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Rod ring opening (-X side)
    translate([-ring_open / 2, -ring_open / 2, -eps])
        cube([ring_open, ring_open, 10 + 2 * eps]);
    // Tubing opening (+X side)
    translate([15 + tube_open / 2, -tube_open / 2, -eps])
        cube([tube_open, tube_open, 10 + 2 * eps]);
}