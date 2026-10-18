// Snap clip for tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded upward in +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d      = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
ring_od    = rod_d + 2*ring_w; // rod ring outer diameter (18.7)
ring_h     = 10;     // clip height (Z)
ring_open  = 10;     // rod ring opening width on -X side

tub_d      = 6;      // tubing inner diameter
tub_w      = 2;      // tubing ring wall thickness
tub_od     = tub_d + 2*tub_w; // tubing ring outer diameter (10)
tub_x      = 15;     // tubing ring centre X
tub_h      = 10;     // clip height (Z)
tub_open   = 4.5;    // tubing ring opening width on +X side

bridge_x1  = 8;      // bridge start X
bridge_x2  = 12;     // bridge end X
bridge_w   = 6;      // bridge width (Y)

eps        = 0.5;    // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Rod ring
        difference() {
            cylinder(d = ring_od, h = ring_h);
            translate([0, -ring_open/2, -eps])
                cube([ring_open + eps, ring_open, ring_h + 2*eps]);
        }
        // Tubing ring
        translate([tub_x, 0, 0])
            difference() {
                cylinder(d = tub_od, h = tub_h);
                translate([0, -tub_open/2, -eps])
                    cube([tub_open + eps, tub_open, tub_h + 2*eps]);
            }
        // Bridge
        translate([bridge_x1, -bridge_w/2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, ring_h]);
    }
    // Rod inner hole, running through the full height
    translate([0, 0, -eps])
        cylinder(d = rod_d, h = ring_h + 2*eps);
}