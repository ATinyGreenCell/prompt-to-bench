// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded along +Z

$fn = 96;

// ---- Rod ring ----
rod_id   = 12.7;   // rod inner diameter
rod_wall = 3;      // rod ring wall thickness
rod_od   = rod_id + 2 * rod_wall;  // 18.7 mm outer diameter

// ---- Tubing ring ----
tube_id  = 6;      // tubing inner diameter
tube_wall = 2;     // tubing ring wall thickness
tube_od  = tube_id + 2 * tube_wall;  // 10 mm outer diameter
tube_x   = 15;     // tubing ring centre X
tube_y   = 0;      // tubing ring centre Y

// ---- Opening cuts ----
cut_rod_w = 10;    // rod opening width along -X
cut_tube_w = 4.5;  // tubing opening width along +X

// ---- Bridge ----
bridge_w = 6;      // bridge width along Y
bridge_x0 = 8;     // bridge start X
bridge_x1 = 12;    // bridge end X

// ---- Clearance for clean booleans ----
eps = 0.5;

difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = 10, $fn = 96);
        // Tubing ring
        translate([tube_x, tube_y, 0])
            cylinder(d = tube_od, h = 10, $fn = 96);
        // Bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Cut out the -X side of the rod ring
    translate([-cut_rod_w - eps, -cut_rod_w / 2, -eps])
        cube([cut_rod_w + eps, cut_rod_w, 11]);
    // Cut out the +X side of the tubing ring
    translate([tube_x + cut_tube_w - eps, -cut_tube_w / 2, -eps])
        cube([cut_tube_w + eps, cut_tube_w, 11]);
}