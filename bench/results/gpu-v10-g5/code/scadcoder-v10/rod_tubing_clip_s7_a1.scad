// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, builds upward in +Z

// ---------- Dimensions (mm) ----------
stand_d      = 12.7;   // stand rod inner diameter
stand_wall   = 3;      // stand rod ring wall
stand_od     = stand_d + 2 * stand_wall;  // 18.7 outer diameter

tube_d       = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing ring wall
tube_od      = tube_d + 2 * tube_wall;    // 10 outer diameter

bridge_w     = 6;      // bridge width in Y
bridge_x0    = 8;      // bridge start X
bridge_x1    = 12;     // bridge end X

opening_s    = 10;     // stand rod opening width (-X side)
tube_open    = 4.5;    // tubing opening width (+X side)
eps          = 0.5;    // cutter overshoot

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Stand rod ring
        translate([0, 0, 0])
            cylinder(d = stand_od, h = 10);

        // Tubing ring
        translate([15, 0, 0])
            cylinder(d = tube_od, h = 10);

        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Stand rod opening (extends past -X face)
    translate([-opening_s / 2, -opening_s / 2, -eps])
        cube([opening_s, opening_s, 10 + 2 * eps]);

    // Tubing opening (extends past +X face)
    translate([15 - tube_open / 2, -tube_open / 2, -eps])
        cube([tube_open, tube_open, 10 + 2 * eps]);
}