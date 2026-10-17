// Tubing/stand rod snap-on clip
// Print orientation: flat on bed, z = 0 up to z = 10

// ---------- Parameters ----------
stand_d      = 12.7;   // stand rod diameter
stand_wall   = 3;      // stand ring wall thickness
stand_open   = 10;     // stand ring opening width (y span)
stand_x0     = -18.35; // stand ring centre x (12.7+2*3)/2 offset for opening

tube_d       = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_x       = 15;     // tubing ring centre x
tube_open    = 4.5;    // tubing ring opening width (y span)

bridge_w     = 6;      // bridge width (Y)
bridge_x0    = 8;      // bridge start x
bridge_x1    = 12;     // bridge end x

h            = 10;     // extrusion height (Z)
eps          = 0.5;    // cutter overshoot

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Stand ring
        cylinder(d = stand_d + 2 * stand_wall, h = h);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_d + 2 * tube_wall, h = h);
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, h]);
    }
    // Stand opening (x < 0, -5 < y < 5)
    translate([stand_x0 - eps, -stand_open / 2, -eps])
        cube([eps + stand_x0 + tube_x, stand_open, h + 2 * eps]);
    // Tubing opening (x > 15, -2.25 < y < 2.25)
    translate([tube_x + tube_d / 2 + eps, -tube_open / 2, -eps])
        cube([eps + tube_d / 2 + 1, tube_open, h + 2 * eps]);
}