// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded upward in +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d        = 12.7;   // stand rod diameter
ring_w       = 3;      // rod ring wall thickness
ring_od      = rod_d + 2 * ring_w;  // rod ring outer diameter (18.7)
opening_w    = 10;     // rod ring opening width along -X
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)
bridge_w     = 6;      // bridge width (Y)
tubing_id    = 6;      // tubing inner diameter
tubing_w     = 2;      // tubing ring wall thickness
tubing_od    = tubing_id + 2 * tubing_w;  // tubing outer diameter (10)
tubing_x     = 15;     // tubing ring centre (X)
tubing_open  = 4.5;    // tubing opening width along +X
height       = 10;     // extrusion height (Z)
eps          = 0.5;    // cutter overshoot past faces

difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = height);
        // Tubing ring
        translate([tubing_x, 0, 0])
            cylinder(d = tubing_od, h = height);
        // Solid bridge between rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, height]);
    }
    // Rod ring opening: x < 0, -5 < y < 5
    translate([-ring_od - eps, -opening_w / 2, -eps])
        cube([ring_od + 2 * eps, opening_w, height + 2 * eps]);
    // Tubing opening: x > 15, -2.25 < y < 2.25
    translate([tubing_x, -tubing_open / 2, -eps])
        cube([ring_od + 2 * eps, tubing_open, height + 2 * eps]);
}