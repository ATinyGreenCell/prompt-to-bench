// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

// ---------- Dimensions (mm) ----------
stand_id     = 12.7;   // stand rod inner diameter
stand_wall   = 3;      // stand ring wall thickness
stand_od     = stand_id + 2 * stand_wall;  // 18.7 outer diameter
stand_open   = 10;     // width of -X side opening

tube_id      = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing wall thickness
tube_od      = tube_id + 2 * tube_wall;    // 10 outer diameter
tube_x       = 15;     // tubing ring centre X
tube_open    = 4.5;    // width of +X side opening

bridge_w     = 6;      // bridge width (Y)
bridge_x0    = 8;      // bridge start X
bridge_x1    = 12;     // bridge end X

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // 1) Stand rod ring
        cylinder(d = stand_od, h = 10);

        // 2) Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10);

        // 3) Solid bridge between rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // 4) Openings
    // Stand ring -X opening (everything with x < 0 and -5 < y < 5)
    translate([-stand_open / 2, -stand_open / 2, -eps])
        cube([stand_open, stand_open, 10 + 2 * eps]);

    // Tubing ring +X opening (x > 15 and -2.25 < y < 2.25)
    translate([tube_x + tube_open / 2, -tube_open / 2, -eps])
        cube([tube_open, tube_open, 10 + 2 * eps]);
}