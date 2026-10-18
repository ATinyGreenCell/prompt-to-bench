// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

// ---------- Parameters ----------
stand_d      = 12.7;   // stand rod diameter
stand_wall   = 3;      // stand ring wall thickness
stand_open   = 10;     // stand ring opening width (along -X)
tube_d       = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing wall thickness
tube_open    = 4.5;    // tubing opening width (along +X)
bridge_w     = 6;      // bridge width (Y)
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)
eps          = 0.5;    // cutter overshoot

$fn = 96;

// ---------- Derived ----------
stand_od = stand_d + 2 * stand_wall;   // 18.7
tube_od  = tube_d + 2 * tube_wall;     // 10

// ---------- Model ----------
union() {
    // Stand ring
    difference() {
        cylinder(d = stand_od, h = 10);
        translate([-stand_open / 2, -stand_open / 2, -eps])
            cube([stand_open, stand_open, 2 * eps]);
    }

    // Tubing ring
    translate([15, 0, 0])
        difference() {
            cylinder(d = tube_od, h = 10);
            translate([0, -tube_open / 2, -eps])
                cube([tube_open, tube_open, 2 * eps]);
        }

    // Bridge
    translate([bridge_x0, -bridge_w / 2, 0])
        cube([bridge_x1 - bridge_x0, bridge_w, 10]);
}