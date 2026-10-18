// Stand rod and tubing clip - printed flat, snaps onto a 12.7 mm stand rod and holds a small
// piece of tubing next to it. A solid bridge joins the two rings without blocking either hole.
//

// ---------------- Parameters ----------------
stand_d      = 12.7;   // stand rod diameter
stand_wall   = 3;      // stand ring wall thickness
stand_open_w = 10;     // stand ring opening width (x < 0, -5 < y < 5)

tub_d        = 6;      // tubing inner diameter
tub_wall     = 2;      // tubing ring wall thickness
tub_open_w   = 4.5;    // tubing ring opening width (x > 15, -2.25 < y < 2.25)

bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)
bridge_w     = bridge_x1 - bridge_x0; // bridge width (Y), 6 mm

h            = 10;     // extrusion height (Z)

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---------------- Derived ----------------
stand_od = stand_d + 2 * stand_wall;        // 18.7 mm
tub_od   = tub_d + 2 * tub_wall;            // 10 mm

// ---------------- Model ----------------
difference() {
    union() {
        // Stand ring
        cylinder(d = stand_od, h = h);
        // Tubing ring, centred at x = 15
        translate([15, 0, 0])
            cylinder(d = tub_od, h = h);
        // Solid bridge between x = 8 and x = 12
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_w, bridge_w, h]);
    }
    // Stand opening: x < 0, -5 < y < 5
    translate([-eps, -5, 0])
        cube([eps + 0.01, 10, h + 1]);
    // Tubing opening: x > 15, -2.25 < y < 2.25
    translate([15 + eps, -tub_open_w / 2, 0])
        cube([eps + 0.01, tub_open_w, h + 1]);
}