// Snap-on tubing and stand rod clip (printed flat)
// Units: mm

// ---- Stand rod ring ----
stand_d     = 12.7;   // inner diameter of stand rod ring
stand_wall  = 3;       // wall thickness of stand rod ring
stand_r     = stand_d/2 + stand_wall;  // outer radius (18.7)
stand_open  = 10;      // width of opening on -X side

// ---- Tubing ring ----
tube_d      = 6;       // inner diameter of tubing ring
tube_wall   = 2;       // wall thickness of tubing ring
tube_r      = tube_d/2 + tube_wall;    // outer radius (5)
tube_x      = 15;      // centre X of tubing ring
tube_open   = 4.5;     // width of opening on +X side

// ---- Bridge ----
bridge_w    = 6;       // bridge width (Y)
bridge_x0   = 8;       // bridge start (X)
bridge_x1   = 12;      // bridge end (X)

// ---- Misc ----
eps         = 0.5;     // cutter overshoot
$fn         = 96;

difference() {
    union() {
        // Stand rod ring
        cylinder(r = stand_r, h = 10, $fn = 128);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(r = tube_r, h = 10, $fn = 64);
        // Bridge
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Openings
    translate([-stand_open/2, -5, -eps])
        cube([stand_open, 10, 2*eps]);              // stand -X opening
    translate([tube_x + tube_open/2, -tube_open/2, -eps])
        cube([tube_open, 2*tube_open/2, 10]);       // tubing +X opening
}