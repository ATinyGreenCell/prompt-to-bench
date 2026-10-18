// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded upward in +Z

// ---------------- Parameters ----------------
rod_d        = 12.7;   // stand rod diameter
ring_w       = 3;      // rod ring wall thickness
ring_od      = rod_d + 2 * ring_w;  // rod ring outer diameter (18.7 mm)
ring_id      = rod_d;  // rod ring inner diameter (12.7 mm)

tub_d        = 6;      // tubing ring inner diameter
tub_w        = 2;      // tubing ring wall thickness
tub_od       = tub_d + 2 * tub_w;   // tubing ring outer diameter (10 mm)
tub_x        = 15;     // tubing ring centre X position

bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)
bridge_w     = 6;      // bridge width (Y)

opening_rod  = 10;     // rod ring opening width (-X side)
opening_tub  = 4.5;    // tubing ring opening width (+X side)

height       = 10;     // extrusion height (Z)
eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = height);

        // Tubing ring
        translate([tub_x, 0, 0])
            cylinder(d = tub_od, h = height);

        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, height]);
    }

    // Rod ring opening: removes everything with x < 0 and -5 < y < 5
    translate([-ring_od - eps, -opening_rod / 2, -eps])
        cube([ring_od + 2 * eps, opening_rod, height + 2 * eps]);

    // Tubing ring opening: removes x > 15 and -2.25 < y < 2.25
    translate([tub_x, -opening_tub / 2, -eps])
        cube([ring_od + 2 * eps, opening_tub, height + 2 * eps]);
}