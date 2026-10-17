// Snap-on clip for tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded along +Z

$fn = 96;

// ---- Rod ring ----
rod_id     = 12.7;   // rod inner diameter
rod_wall   = 3;      // rod ring wall thickness
rod_od     = rod_id + 2 * rod_wall;  // 18.7 mm outer diameter
rod_open   = 10;     // opening width on the -X side
rod_h      = 10;     // extrusion height (Z)

// ---- Tubing ring ----
tube_id    = 6;      // tubing inner diameter
tube_wall  = 2;      // tubing ring wall thickness
tube_od    = tube_id + 2 * tube_wall; // 10 mm outer diameter
tube_x     = 15;     // tubing ring centre X
tube_open  = 4.5;    // opening width on the +X side

// ---- Bridge ----
bridge_w   = 6;      // bridge width in Y
bridge_x0  = 8;      // bridge start X
bridge_x1  = 12;     // bridge end X

// ---- Cutting overlap ----
eps        = 0.5;    // extension of cutters past faces

difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = rod_h);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = rod_h);
        // Solid bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, rod_h]);
    }
    // Rod ring opening (removes everything with x < 0 and -5 < y < 5)
    translate([-eps, -rod_open / 2, -eps])
        cube([rod_open + 2 * eps, rod_open, rod_h + 2 * eps]);
    // Tubing ring opening (removes x > 15 and -2.25 < y < 2.25)
    translate([tube_x + eps, -tube_open / 2, -eps])
        cube([rod_h + 2 * eps, tube_open, eps + rod_h + 2 * eps]);
}