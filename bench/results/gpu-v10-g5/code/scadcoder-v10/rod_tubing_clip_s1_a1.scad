// Snap-on tubing clip for 12.7 mm stand rod
// Print orientation: flat on bed, builds upward in +Z

$fn = 96;

// ---- Dimensions (mm) ----
stand_d      = 12.7;  // stand rod diameter
stand_w      = 3;     // stand ring wall
stand_od     = stand_d + 2 * stand_w;  // 18.7 outer diameter
stand_open   = 10;    // stand opening width (-X side)

tube_d       = 6;     // tubing inner diameter
tube_w       = 2;     // tubing wall
tube_od      = tube_d + 2 * tube_w;    // 10 outer diameter
tube_x       = 15;    // tubing ring centre X
tube_open    = 4.5;   // tubing opening width (+X side)

bridge_x0    = 8;     // bridge start X
bridge_x1    = 12;    // bridge end X
bridge_w     = 6;     // bridge width (Y)

eps          = 0.5;   // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // Stand ring
        cylinder(d = stand_od, h = 10);
        translate([-stand_open, -stand_open/2, 0])
            cube([stand_open, stand_open, 10]);

        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10);
        translate([tube_x, -tube_open/2, 0])
            cube([tube_open, tube_open, 10]);

        // Bridge
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Stand rod hole
    translate([0, 0, -eps])
        cylinder(d = stand_d, h = 10 + 2 * eps);

    // Tubing hole
    translate([tube_x, 0, -eps])
        cylinder(d = tube_d, h = 10 + 2 * eps);
}