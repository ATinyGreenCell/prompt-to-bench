// Tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d      = 12.7;   // rod diameter
ring_w     = 3;      // rod ring wall thickness
rod_r      = rod_d/2 + ring_w; // rod ring outer radius (18.7/2)
opening_w  = 10;     // rod ring opening width
rod_h      = 10;     // clip height

tub_d      = 6;      // tubing inner diameter
tub_w      = 2;      // tubing wall thickness
tub_r      = tub_d/2 + tub_w; // tubing outer radius
tub_x      = 15;     // tubing ring centre X
tub_open   = 4.5;    // tubing opening width
tub_h      = rod_h;  // tubing ring height

bridge_x1  = 8;      // bridge start X
bridge_x2  = 12;     // bridge end X
bridge_w   = 6;      // bridge width (Y)

eps        = 0.5;    // cut overshoot

// ---- Model ----
difference() {
    union() {
        // Rod ring
        cylinder(r = rod_r, h = rod_h);
        // Tubing ring
        translate([tub_x, 0, 0])
            cylinder(r = tub_r, h = tub_h);
        // Bridge
        translate([bridge_x1, -bridge_w/2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, rod_h]);
    }
    // Rod opening
    translate([-rod_r - eps, -opening_w/2, 0])
        cube([rod_r + eps, opening_w, rod_h]);
    // Tubing opening
    translate([tub_x + eps, -tub_open/2, 0])
        cube([rod_h + 2*eps, tub_open, rod_h]);
}