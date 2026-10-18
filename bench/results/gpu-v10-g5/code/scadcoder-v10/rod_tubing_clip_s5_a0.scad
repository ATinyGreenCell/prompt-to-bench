// Tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

// ---- Stand rod ring ----
stand_id   = 12.7;   // stand rod inner diameter
stand_wall = 3;      // stand ring wall thickness
stand_od   = stand_id + 2 * stand_wall;  // 18.7 mm outer diameter
stand_open = 10;     // width of -X side opening

// ---- Tubing ring ----
tube_id    = 6;      // tubing inner diameter
tube_wall  = 2;      // tubing wall thickness
tube_od    = tube_id + 2 * tube_wall;    // 10 mm outer diameter
tube_x     = 15;     // ring centre X
tube_open  = 4.5;    // width of +X side opening

// ---- Bridge ----
bridge_w   = 6;      // bridge width in Y
bridge_x0  = 8;      // bridge start X
bridge_x1  = 12;     // bridge end X

// ---- Misc ----
eps        = 0.5;    // cutter overshoot
$fn        = 96;

difference() {
    union() {
        // Stand ring
        cylinder(d = stand_od, h = 10);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10);
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Stand rod opening
    translate([-stand_open / 2, -stand_open / 2, -eps])
        cube([stand_open, stand_open, 10 + 2 * eps]);
    // Tubing opening
    translate([tube_x + tube_open / 2, -tube_open / 2, -eps])
        cube([tube_open, tube_open, 10 + 2 * eps]);
}