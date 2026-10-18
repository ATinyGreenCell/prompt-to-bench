// Snap-on clip: rod ring + tubing ring + bridge
// Print orientation: flat on bed, extrusion along +Z

$fn = 96;

// ---- Rod ring ----
rod_id     = 12.7;   // rod inner diameter
rod_wall   = 3;      // ring wall thickness
rod_od     = rod_id + 2 * rod_wall; // 18.7 mm outer diameter
rod_open   = 10;     // opening width on -X side

// ---- Tubing ring ----
tube_id    = 6;      // tubing inner diameter
tube_wall  = 2;      // ring wall thickness
tube_od    = tube_id + 2 * tube_wall; // 10 mm outer diameter
tube_x     = 15;     // ring centre X
tube_open  = 4.5;    // opening width on +X side

// ---- Bridge ----
bridge_w   = 6;      // bridge width in Y
bridge_x0  = 8;      // bridge start X
bridge_x1  = 12;     // bridge end X

// ---- Misc ----
eps        = 0.5;    // cutter overshoot past faces

difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = 10);
        translate([-rod_od / 2 - eps, -rod_open / 2, 0])
            cube([eps, rod_open, 10]);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10);
        translate([tube_x + tube_od / 2 - eps, -tube_open / 2, 0])
            cube([eps, tube_open, 10]);
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
}