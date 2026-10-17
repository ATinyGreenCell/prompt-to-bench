// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded along +Z

// ---------------- Parameters ----------------
rod_d        = 12.7;   // stand rod diameter
rod_wall     = 3;      // rod ring wall thickness
rod_open     = 10;     // rod ring opening width (along Y)
rod_open_h   = 5;      // rod ring opening half-height (y = +/- 5)

tube_d       = 6;      // tubing ring inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_open    = 4.5;    // tubing ring opening width (along Y)
tube_open_h  = 2.25;   // tubing ring opening half-height

bridge_w     = 6;      // solid bridge width (along Y)
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---------------- Profile (in XY) ----------------
module rod_ring() {
    difference() {
        cylinder(d = rod_d + 2 * rod_wall, h = 10);
        translate([-eps, -rod_open_h, 0])
            cube([eps + rod_open, 2 * rod_open_h, 10 + eps]);
    }
}

module tube_ring() {
    difference() {
        translate([15, 0, 0])
            cylinder(d = tube_d + 2 * tube_wall, h = 10);
        translate([15 + eps, -tube_open_h, 0])
            cube([eps + tube_open, 2 * tube_open_h, 10 + eps]);
    }
}

module bridge() {
    translate([bridge_x0, -bridge_w / 2, 0])
        cube([bridge_x1 - bridge_x0, bridge_w, 10]);
}

// ---------------- Assembly ----------------
union() {
    rod_ring();
    tube_ring();
    bridge();
}