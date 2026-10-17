// Tubing organiser clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, builds up in +Z

// ---------------- Parameters ----------------
rod_d      = 12.7;   // stand rod diameter
rod_wall   = 3;      // stand rod wall thickness
ring_open  = 10;     // opening width on the -X side of the rod ring
bridge_w   = 6;      // solid bridge width (Y) between the two rings
tub_d      = 6;      // tubing ring inner diameter
tub_wall   = 2;      // tubing ring wall thickness
tub_open   = 4.5;    // opening width on the +X side of the tubing ring
h          = 10;     // extrusion height (Z)
eps        = 0.5;    // cutter overshoot past faces

$fn = 96;

// Derived dimensions
rod_r      = rod_d / 2 + rod_wall;              // outer radius of rod ring
tub_r      = tub_d / 2 + tub_wall;              // outer radius of tubing ring
tub_x      = 15;                                 // tubing ring centre X

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring: centred at origin, opening on the -X side
        if (ring_open > 0)
            circle(r = rod_r, $fn = 128);
        else
            circle(r = rod_r - rod_wall, $fn = 128);

        // Tubing ring: centred at x = 15, y = 0, opening on the +X side
        translate([tub_x, 0, 0])
            if (tub_open > 0)
                circle(r = tub_r, $fn = 128);
            else
                circle(r = tub_r - tub_wall, $fn = 128);

        // Solid bridge: runs from x = 8 to x = 12, width 6 in Y
        translate([8, -bridge_w / 2, 0])
            cube([bridge_w, bridge_w, h]);
    }

    // Cut out the -X side opening of the rod ring (-5 < y < 5)
    translate([-rod_r, -ring_open / 2, -eps])
        cube([rod_r + eps, ring_open, h + 2 * eps]);

    // Cut out the +X side opening of the tubing ring (x > 15, -2.25 < y < 2.25)
    translate([tub_x, -tub_open / 2, -eps])
        cube([tub_open, tub_open, h + 2 * eps]);
}