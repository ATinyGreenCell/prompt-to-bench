// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Printed flat: extrusion of 10 mm (Z) of a 2-D profile in XY
// Units: mm

$fn = 96;

// ---- Rod ring ----
rod_id     = 12.7;   // rod inner diameter
rod_wall   = 3;      // ring wall thickness
rod_od     = rod_id + 2 * rod_wall;  // 18.7 mm outer diameter
rod_h      = 10;     // extrusion height (Z)
rod_open   = 10;     // opening width cut from -X side
rod_ylim   = rod_open / 2;  // -5 < y < 5 for the cut

// ---- Tubing ring ----
tube_id    = 6;      // tubing inner diameter
tube_wall  = 2;      // ring wall thickness
tube_od    = tube_id + 2 * tube_wall; // 10 mm outer diameter
tube_h     = rod_h;  // same extrusion height
tube_open  = 4.5;    // opening width cut from +X side
tube_x     = 15;     // ring centre X
tube_ylim  = tube_open / 2;  // -2.25 < y < 2.25

// ---- Bridge ----
bridge_w   = 6;      // bridge width in Y
bridge_x0  = 8;      // bridge start X
bridge_x1  = 12;     // bridge end X

// ---- Cutting overlap ----
eps        = 0.5;    // extension past cut faces to avoid coplanar faces

difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = rod_h);
        translate([-rod_od / 2, -rod_ylim, 0])
            cube([rod_od / 2 + eps, 2 * rod_ylim, rod_h]);

        // Tubing ring
        translate([tube_x - tube_od / 2, -tube_ylim, 0])
            cylinder(d = tube_od, h = tube_h);
        translate([tube_x - tube_od / 2 + eps, -tube_ylim, 0])
            cube([eps, 2 * tube_ylim, tube_h]);

        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, rod_h]);
    }

    // Rod ring opening (x < 0 and -5 < y < 5)
    translate([-rod_od / 2, -rod_ylim, -eps])
        cube([rod_od / 2 + eps, 2 * rod_ylim, rod_h + 2 * eps]);

    // Tubing ring opening (x > 15 and -2.25 < y < 2.25)
    translate([tube_x, -tube_ylim, -eps])
        cube([eps + rod_h, 2 * tube_ylim, rod_h + 2 * eps]);
}