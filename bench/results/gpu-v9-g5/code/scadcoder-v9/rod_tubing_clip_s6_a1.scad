// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded along +Z

// ---------------- Parameters ----------------
ring_od      = 18.7;   // rod ring outer diameter
ring_id      = 12.7;   // rod ring inner diameter
ring_w       = 3;      // rod ring wall thickness

tubing_id    = 6;      // tubing ring inner diameter
tubing_od    = tubing_id + 2 * 2;  // tubing ring outer diameter (4 mm wall)
tubing_x     = 15;     // tubing ring centre X
tubing_y     = 0;      // tubing ring centre Y

bridge_w     = 6;      // bridge width along Y
bridge_x0    = 8;      // bridge start X
bridge_x1    = 12;     // bridge end X

opening_w    = 10;     // rod ring opening width (-X side)
opening_h    = 4.5;    // tubing ring opening height (+X side)

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = 10);
        // Tubing ring
        translate([tubing_x, tubing_y, 0])
            cylinder(d = tubing_od, h = 10);
        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Cut out the -X side of the rod ring (x < 0, -5 < y < 5)
    translate([-eps, -opening_h / 2, -eps])
        cube([opening_w + 2 * eps, opening_h, eps + 1]);

    // Cut out the +X side of the tubing ring (x > 15, -2.25 < y < 2.25)
    translate([tubing_x + eps, -opening_h / 2, -eps])
        cube([opening_w + 2 * eps, opening_h, eps + 1]);
}