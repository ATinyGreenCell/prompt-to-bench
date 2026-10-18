// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded in +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d      = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
ring_od    = rod_d + 2*ring_w; // rod ring outer diameter (18.7)
opening_w  = 10;     // rod ring opening width (-X side)

tube_d     = 6;      // tubing inner diameter
tube_w     = 2;      // tubing wall thickness
tube_od    = tube_d + 2*tube_w; // tubing outer diameter (10)
tube_x     = 15;     // tubing ring centre X
opening_2  = 4.5;    // tubing opening width (+X side)

bridge_x   = 10;     // bridge X centre
bridge_w   = 6;      // bridge width (Y)
height     = 10;     // extrusion height

eps        = 0.5;    // cut overshoot

// ---- Model ----
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = height);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = height);
        // Bridge
        translate([bridge_x - 3, -bridge_w/2, 0])
            cube([6, bridge_w, height]);
    }
    // Rod ring opening
    translate([-ring_od/2 - eps, -opening_w/2, 0])
        cube([ring_od/2 + eps, opening_w, height + eps]);
    // Tubing opening
    translate([tube_x + eps, -opening_2/2, 0])
        cube([tube_od/2 + eps, opening_2, height + eps]);
}