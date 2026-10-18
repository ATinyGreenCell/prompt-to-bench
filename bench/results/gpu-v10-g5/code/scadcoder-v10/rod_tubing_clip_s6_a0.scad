// Tubing clip for 12.7 mm stand rod
// Print orientation: flat on bed, extrusion along +Z

// ---- Stand rod ring ----
stand_id   = 12.7;   // stand rod inner diameter
stand_wall = 3;      // stand ring wall thickness
stand_od   = stand_id + 2 * stand_wall;  // 18.7 mm outer diameter

// ---- Tubing ring ----
tube_id    = 6;      // tubing inner diameter
tube_wall  = 2;      // tubing wall thickness
tube_od    = tube_id + 2 * tube_wall;    // 10 mm outer diameter

// ---- Bridge ----
bridge_w   = 6;      // bridge width in Y
bridge_x0  = 8;      // bridge start (X)
bridge_x1  = 12;     // bridge end (X)

// ---- Misc ----
eps        = 0.5;    // cutter overshoot past faces
$fn        = 96;     // curve resolution

difference() {
    union() {
        // Stand rod ring
        cylinder(d = stand_od, h = 10);
        // Tubing ring
        translate([15, 0, 0])
            cylinder(d = tube_od, h = 10);
        // Solid bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Stand rod opening (x < 0, -5 < y < 5)
    translate([-stand_od / 2 - eps, -5, 0])
        cube([stand_od / 2 + 2 * eps, 10, 10]);
    // Tubing opening (x > 15, -2.25 < y < 2.25)
    translate([15 + tube_od / 2 - eps, -2.25, 0])
        cube([tube_od / 2 + 2 * eps, 4.5, 10]);
}