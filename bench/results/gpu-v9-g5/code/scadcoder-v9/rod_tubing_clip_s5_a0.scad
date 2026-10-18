// Tubing clip for 12.7 mm stand rod
// Print orientation: flat on bed, extruded in +Z

$fn = 96;

// ---- Ring dimensions ----
rod_id   = 12.7;   // stand rod inner diameter
rod_wall = 3;      // rod ring wall thickness
ring_od  = rod_id + 2 * rod_wall; // 18.7 mm outer diameter

tube_id  = 6;      // tubing inner diameter
tube_wall = 2;     // tubing ring wall thickness
tube_od  = tube_id + 2 * tube_wall; // 10 mm outer diameter

// ---- Opening dimensions ----
rod_open_w = 10;   // rod ring -X opening width (y = +/-5)
tube_open_w = 4.5; // tubing ring +X opening width (y = +/-2.25)

// ---- Bridge ----
bridge_x0 = 8;     // bridge start (x)
bridge_x1 = 12;    // bridge end (x)
bridge_w  = 6;     // bridge width in Y

// ---- Extrusion ----
height = 10;       // Z height of 2-D profile

difference() {
    union() {
        // Rod ring
        cylinder(h = height, d = ring_od);
        // Tubing ring
        translate([15, 0, 0])
            cylinder(h = height, d = tube_od);
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, height]);
    }
    // Cut out the stand rod opening (-X side)
    translate([-ring_od - 1, -rod_open_w / 2, -1])
        cube([rod_open_w + 2, rod_open_w, height + 2]);

    // Cut out the tubing opening (+X side)
    translate([15 + tube_open_w / 2 - tube_od - 1, -tube_open_w / 2, -1])
        cube([tube_open_w + 2, tube_open_w, height + 2]);
}