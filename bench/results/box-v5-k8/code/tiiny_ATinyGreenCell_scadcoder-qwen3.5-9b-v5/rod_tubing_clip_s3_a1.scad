// Tubing and stand-rod snap-on clip (printed flat)
// Units: mm. Stand rod 12.7 mm (1/2 inch).

$fn = 96;

// ---- Stand rod ring ----
rod_id     = 12.7;   // rod inner diameter
rod_wall   = 3;       // ring wall thickness
rod_od     = rod_id + 2 * rod_wall;   // 18.7 mm outer diameter
rod_open   = 10;      // width of opening cut on -X side

// ---- Tubing ring ----
tube_id    = 6;       // tubing inner diameter
tube_wall  = 2;       // ring wall thickness
tube_od    = tube_id + 2 * tube_wall; // 10 mm outer diameter
tube_x     = 15;      // tubing ring centre X
tube_open  = 4.5;     // width of opening cut on +X side

// ---- Bridge ----
bridge_w   = 6;       // bridge width (Y)
bridge_x1  = 8;       // bridge left X
bridge_x2  = 12;      // bridge right X

// ---- Cut overlap ----
eps        = 0.5;     // extension past faces to avoid coplanar surfaces

difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = 10, $fn = 96);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10, $fn = 96);
        // Solid bridge
        translate([bridge_x1, -bridge_w / 2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, 10]);
    }

    // Opening in rod ring: x < 0 and -5 < y < 5
    translate([-rod_open / 2, -5, -eps])
        cube([rod_open, 10, 2 * eps]);

    // Opening in tubing ring: x > 15 and -2.25 < y < 2.25
    translate([tube_x + tube_open / 2, -tube_open / 2, -eps])
        cube([tube_open, tube_open, 2 * eps]);
}