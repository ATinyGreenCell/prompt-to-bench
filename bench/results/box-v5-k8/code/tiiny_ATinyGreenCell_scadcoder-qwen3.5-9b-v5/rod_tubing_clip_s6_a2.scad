// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, z = 0 up to z = 10

// ---- Stand rod ----
stand_d     = 12.7;   // stand rod diameter
stand_open  = 10;      // width of the opening cut into the stand ring
stand_r     = stand_d / 2 + 3;  // stand ring outer radius (3 mm wall)

// ---- Tubing ring ----
tube_d      = 6;       // tubing inner diameter
tube_r      = tube_d / 2 + 2;   // tubing ring outer radius (2 mm wall)
tube_x      = 15;      // tubing ring centre X
tube_open_w = 4.5;     // width of the opening cut into the tubing ring

// ---- Bridge ----
bridge_w    = 6;       // bridge width (Y)
bridge_x0   = 8;       // bridge start (X)
bridge_x1   = 12;      // bridge end (X)

// ---- Misc ----
eps         = 0.5;     // cutter overshoot past faces
$fn         = 96;      // smoothness of curved shapes

difference() {
    union() {
        // Stand ring
        cylinder(r = stand_r, h = 10);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(r = tube_r, h = 10);
        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Opening in the stand ring (-X side)
    translate([-stand_open / 2, -stand_open / 2, -eps])
        cube([stand_open, stand_open, 10 + 2 * eps]);

    // Opening in the tubing ring (+X side)
    translate([tube_x + tube_open_w / 2, -tube_open_w / 2, -eps])
        cube([tube_open_w, tube_open_w, 10 + 2 * eps]);
}