// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d      = 12.7;   // rod diameter
ring_w     = 3;      // rod ring wall
rod_od     = rod_d + 2*ring_w; // rod ring outer diameter (18.7)
opening_w  = 10;     // rod ring opening width
rod_x      = 0;      // rod ring centre X
rod_y      = 0;      // rod ring centre Y

tub_d      = 6;      // tubing inner diameter
tub_w      = 2;      // tubing wall
tub_od     = tub_d + 2*tub_w; // tubing outer diameter (10)
tub_open   = 4.5;    // tubing opening width
tub_x      = 15;     // tubing ring centre X
tub_y      = 0;      // tubing ring centre Y

bridge_x1  = 8;      // bridge start X
bridge_x2  = 12;     // bridge end X
bridge_w   = 6;      // bridge width (Y)

h          = 10;     // extrusion height
eps        = 0.5;    // cut overshoot

// ---- Model ----
difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = h);
        // Tubing ring
        translate([tub_x, tub_y, 0])
            cylinder(d = tub_od, h = h);
        // Bridge
        translate([bridge_x1, -bridge_w/2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, h]);
    }
    // Rod opening
    translate([rod_x - opening_w, -opening_w/2, -eps])
        cube([opening_w, opening_w, h + 2*eps]);
    // Tubing opening
    translate([tub_x, -tub_open/2, -eps])
        cube([tub_open, tub_open, h + 2*eps]);
}