// Tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded upward in +Z

// ---------------- Parameters ----------------
rod_d        = 12.7;   // stand rod diameter
ring_wall    = 3;      // rod ring wall thickness
ring_od      = rod_d + 2 * ring_wall;  // rod ring outer diameter (18.7 mm)
opening_w    = 10;     // rod ring opening width (along Y)
opening_x0   = -5;     // opening centre X position

tube_d       = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing wall thickness
tube_od      = tube_d + 2 * tube_wall; // tubing outer diameter (10 mm)
tube_x       = 15;     // tubing ring centre X position
opening_t    = 4.5;    // tubing opening width (along Y)

bridge_w     = 6;      // bridge width (along Y)
bridge_x0    = 8;      // bridge left edge (X)
bridge_x1    = 12;     // bridge right edge (X)

eps          = 0.5;    // cutter overshoot past faces
$fn          = 128;    // circle resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = 10);

        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10);

        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Rod ring opening: removes everything with x < 0 and -5 < y < 5
    translate([opening_x0, -opening_w / 2, -eps])
        cube([opening_w / 2 + eps, opening_w, 10 + 2 * eps]);

    // Tubing opening: removes x > 15 and -2.25 < y < 2.25
    translate([tube_x, -opening_t / 2, -eps])
        cube([opening_t, opening_t, 10 + 2 * eps]);
}