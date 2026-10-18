// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded upward in +Z

$fn = 96;

// ---- Rod ring ----
rod_d      = 12.7;   // rod diameter (inner)
ring_w     = 3;      // ring wall thickness
ring_od    = rod_d + 2*ring_w; // outer diameter = 18.7
ring_h     = 10;     // extrusion height
ring_open  = 10;     // opening width on -X side

// ---- Tubing ring ----
tub_d      = 6;      // tubing inner diameter
tub_w      = 2;      // tubing wall thickness
tub_od     = tub_d + 2*tub_w; // outer diameter = 10
tub_x      = 15;     // ring centre X position
tub_h      = 10;     // extrusion height
tub_open   = 4.5;    // opening width on +X side

// ---- Bridge ----
bridge_x1  = 8;      // bridge start X
bridge_x2  = 12;     // bridge end X
bridge_w   = 6;      // bridge width in Y

// ---- Misc ----
eps        = 0.5;    // cutter overshoot past faces

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