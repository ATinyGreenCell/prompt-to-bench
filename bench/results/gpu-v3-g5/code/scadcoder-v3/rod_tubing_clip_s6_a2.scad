// Snap-on clip: holds a piece of tubing next to a 12.7 mm (1/2") lab stand rod
// Printed flat: 10 mm tall extrusion (Z) of a 2-D profile in XY.

$fn = 128;

// ---------------- Parameters ----------------
rod_d      = 12.7;              // rod ring inner diameter
rod_wall   = 3;                 // rod ring wall thickness
rod_od     = rod_d + 2*rod_wall; // rod ring outer diameter (18.7)

tub_d      = 6;                 // tubing ring inner diameter
tub_wall   = 2;                 // tubing ring wall thickness
tub_od     = tub_d + 2*tub_wall; // tubing ring outer diameter (10)

bridge_w   = 6;                 // bridge width in X (from x = 8 to x = 12)
bridge_y   = 6;                 // bridge width in Y

clip_h     = 10;                // extrusion height (Z)

// Opening half-widths (y from centre line)
rod_open_h = 5;                 // rod opening: -5 < y < 5
tub_open_h = 2.25;              // tubing opening: -2.25 < y < 2.25

eps        = 0.5;               // cutter overshoot past cut faces

// ---------------- Derived ----------------
rod_r_out  = rod_od / 2;
rod_r_in   = rod_d / 2;
tub_r_out  = tub_od / 2;
tub_r_in   = tub_d / 2;

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        difference() {
            cylinder(d = rod_od, h = clip_h);
            // hole for rod (x < 0, -rod_open_h < y < rod_open_h)
            translate([-(rod_r_in + eps), -rod_open_h])
                cube([rod_d + 2*eps, 2*rod_open_h, clip_h]);
        }

        // Tubing ring, centre at x = 15
        translate([15, 0, 0])
            difference() {
                cylinder(d = tub_od, h = clip_h);
                translate([eps, -tub_open_h])
                    cube([tub_d + 2*eps, 2*tub_open_h, clip_h]);
            }

        // Solid bridge between x = 8 and x = 12
        translate([8, -bridge_y / 2, 0])
            cube([bridge_w, bridge_y, clip_h]);
    }
}