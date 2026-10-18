// Tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded upward along +Z

// ---------------- Parameters ----------------
ring_id      = 12.7;   // rod ring inner diameter (stand rod clearance)
ring_wall    = 3;      // rod ring wall thickness
ring_od      = ring_id + 2 * ring_wall; // rod ring outer diameter (18.7)
ring_x       = 0;      // rod ring centre X
ring_y       = 0;      // rod ring centre Y

tub_id       = 6;      // tubing ring inner diameter
tub_wall     = 2;      // tubing ring wall thickness
tub_od       = tub_id + 2 * tub_wall; // tubing ring outer diameter (10)
tub_x        = 15;     // tubing ring centre X
tub_y        = 0;      // tubing ring centre Y

bridge_x1    = 8;      // bridge start X
bridge_x2    = 12;     // bridge end X
bridge_w     = 6;      // bridge width in Y

opening_w    = 10;     // rod ring opening width (-X side)
open_x       = -0.5;   // opening cut overshoot past the X face

height       = 10;     // extrusion height (Z)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = height);
        // Tubing ring
        translate([tub_x, tub_y, 0])
            cylinder(d = tub_od, h = height);
        // Solid bridge between the rings
        translate([bridge_x1, -bridge_w / 2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, height]);
    }

    // Rod ring opening cut out of the -X side
    translate([ring_x - opening_w / 2, ring_y - opening_w / 2, -open_x])
        cube([opening_w, opening_w, height + 2 * open_x]);

    // Tubing ring opening cut out of the +X side
    translate([tub_x + tub_wall, tub_y - tub_id / 2, -open_x])
        cube([opening_w, tub_id, height + 2 * open_x]);
}