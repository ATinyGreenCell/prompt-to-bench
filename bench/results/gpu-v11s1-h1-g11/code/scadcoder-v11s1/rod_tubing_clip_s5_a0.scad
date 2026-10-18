// Tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded upward along +Z

// ---------------- Parameters ----------------
ring_id      = 12.7;   // rod ring inner diameter (stand rod clearance)
ring_wall    = 3;      // rod ring wall thickness
ring_od      = ring_id + 2 * ring_wall; // rod ring outer diameter (18.7)
ring_x0      = 0;      // rod ring centre X
ring_y0      = 0;      // rod ring centre Y

tube_id      = 6;      // tubing ring inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_od      = tube_id + 2 * tube_wall; // tubing ring outer diameter (10)
tube_x0      = 15;     // tubing ring centre X
tube_y0      = 0;      // tubing ring centre Y

bridge_x0    = 10;     // bridge centre X (between x = 8 and x = 12)
bridge_x1    = 8;      // bridge start X
bridge_x2    = 12;     // bridge end X
bridge_w     = 6;      // bridge width along Y

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = ring_id / 2);
        // Tubing ring
        translate([tube_x0, tube_y0, 0])
            cylinder(d = tube_od, h = ring_id / 2);
        // Solid bridge
        translate([bridge_x1, -bridge_w / 2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, ring_id / 2]);
    }

    // Rod ring opening: full -X side where x < 0 and -5 < y < 5
    translate([ring_x0 - eps, ring_y0 - 5, -eps])
        cube([ring_id / 2 + eps, 10, ring_id / 2 + eps]);

    // Tubing ring opening: +X side where x > 15 and -2.25 < y < 2.25
    translate([tube_x0, tube_y0 - 2.25, -eps])
        cube([tube_od - tube_x0 + eps, 4.5, tube_od + 2 * eps]);
}