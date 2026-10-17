// Snap-on clip for tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded along +Z

// ---------------- Parameters ----------------
rod_id        = 12.7;   // stand rod inner diameter (1/2 inch)
rod_wall      = 3;      // stand rod ring wall thickness
ring_open     = 10;     // width of opening cut from the -X side of the rod ring

tube_id       = 6;      // tubing inner diameter
tube_wall     = 2;      // tubing ring wall thickness
tube_x        = 15;     // tubing ring centre X position
tube_open     = 4.5;    // width of opening cut from the +X side of the tubing ring

bridge_x1     = 8;      // bridge start X position
bridge_x2     = 12;     // bridge end X position
bridge_w      = 6;      // bridge width along Y

eps           = 0.5;    // cutter overshoot past faces
$fn           = 96;     // curve resolution

// ---------------- Derived ----------------
rod_od    = rod_id + 2 * rod_wall;   // 18.7 mm outer diameter of rod ring
tube_od   = tube_id + 2 * tube_wall; // 10 mm outer diameter of tubing ring

// ---------------- Profile (in XY) ----------------
module rod_ring() {
    difference() {
        translate([0, 0])
            cylinder(d = rod_od, h = 1);
        // Opening: everything with x < 0 and -5 < y < 5
        translate([-eps, -ring_open / 2, -eps])
            cube([eps + rod_id / 2, ring_open, 2 * eps]);
    }
}

module tube_ring() {
    difference() {
        translate([tube_x, 0])
            cylinder(d = tube_od, h = 1);
        // Opening: x > 15 and -2.25 < y < 2.25
        translate([tube_x + eps, -tube_open / 2, -eps])
            cube([eps + tube_id / 2, tube_open, 2 * eps]);
    }
}

module bridge() {
    // Solid block between x = 8 and x = 12, 6 mm wide in Y, 1 mm tall
    translate([bridge_x1, -bridge_w / 2, 0])
        cube([bridge_x2 - bridge_x1, bridge_w, 1]);
}

// ---------------- Assembly ----------------
union() {
    rod_ring();
    tube_ring();
    bridge();
}