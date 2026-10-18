// Tubing clip for 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on bed, extruded upward in +Z

// ---------- Parameters ----------
rod_d        = 12.7;   // stand rod diameter
ring_w       = 3;      // rod ring wall thickness
ring_od      = rod_d + 2 * ring_w;  // rod ring outer diameter (18.7 mm)
ring_h       = 10;     // clip height (Z)

tub_d        = 6;      // tubing ring inner diameter
tub_w        = 2;      // tubing ring wall thickness
tub_od       = tub_d + 2 * tub_w;  // tubing ring outer diameter (10 mm)
tub_x        = 15;     // tubing ring centre X
tub_y        = 0;      // tubing ring centre Y

bridge_x0    = 8;      // bridge start X
bridge_x1    = 12;     // bridge end X
bridge_w     = 6;      // bridge width (Y)

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Rod ring
        translate([0, 0, 0])
            cylinder(d = ring_od, h = ring_h);

        // Tubing ring
        translate([tub_x, tub_y, 0])
            cylinder(d = tub_od, h = ring_h);

        // Solid bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, ring_h]);
    }

    // Rod ring opening on -X side (x < 0, -5 < y < 5)
    translate([0, -5, -eps])
        cube([ring_od + 2 * eps, 10, ring_h + 2 * eps]);

    // Tubing ring opening on +X side (x > 15, -2.25 < y < 2.25)
    translate([tub_x, -2.25, -eps])
        cube([ring_od + 2 * eps, 4.5, ring_h + 2 * eps]);
}