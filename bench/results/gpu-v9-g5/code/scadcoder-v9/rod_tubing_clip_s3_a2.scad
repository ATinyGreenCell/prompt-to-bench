// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d        = 12.7;   // stand rod diameter
rod_wall     = 3;      // rod ring wall thickness
rod_open     = 10;     // rod ring opening width (-X side)

tube_d       = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_open    = 4.5;    // tubing ring opening width (+X side)

bridge_w     = 6;      // solid bridge width (Y)
bridge_x0    = 8;      // solid bridge start (X)
bridge_x1    = 12;     // solid bridge end (X)

height       = 10;     // extrusion height (Z)
eps          = 0.5;    // cutter overshoot past faces

// ---- Derived ----
rod_od = rod_d + 2 * rod_wall;

module rod_ring() {
    difference() {
        translate([0, 0, 0])
            cylinder(d = rod_od, h = height);
        // Opening on -X side (x < 0, -5 < y < 5)
        translate([-rod_open / 2, -5, -eps])
            cube([rod_open / 2 + eps, 10, height + 2 * eps]);
    }
}

module tube_ring() {
    difference() {
        translate([15, 0, 0])
            cylinder(d = tube_d + 2 * tube_wall, h = height);
        // Opening on +X side (x > 15, -2.25 < y < 2.25)
        translate([15 + tube_open / 2, -tube_open / 2, -eps])
            cube([tube_open / 2 + eps, tube_open, height + 2 * eps]);
    }
}

module solid_bridge() {
    translate([bridge_x0, -bridge_w / 2, 0])
        cube([bridge_x1 - bridge_x0, bridge_w, height]);
}

union() {
    rod_ring();
    tube_ring();
    solid_bridge();
}