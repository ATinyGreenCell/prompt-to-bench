// Snap-on clip: holds a piece of tubing next to a 12.7 mm (1/2") lab stand rod
// Printed flat: 2-D profile in XY, extruded 10 mm in +Z.

$fn = 128;

// ---------------- Parameters ----------------
rod_d      = 12.7;              // rod ring inner diameter
rod_wall   = 3;                 // rod ring wall thickness
rod_r      = rod_d / 2;         // rod ring radius (12.7/2)
outer_r    = rod_r + rod_wall;  // rod ring outer radius (18.7)

tub_d      = 6;                 // tubing ring inner diameter
tub_wall   = 2;                 // tubing ring wall thickness
tub_r      = tub_d / 2;         // tubing ring radius (6/2)
outer_tub_r = tub_r + tub_wall; // tubing ring outer radius (8)

bridge_w   = 6;                 // bridge width in X (from x = 8 to x = 12)
bridge_y   = 6;                 // bridge width in Y

clip_h     = 10;                // extrusion height (Z)

eps        = 0.5;               // overshoot for clean cuts

// ---------------- Derived ----------------
rod_open_w = 10;                // opening cut out of -X side (-5 < y < 5)
tub_open_w = 4.5;               // opening cut out of +X side (-2.25 < y < 2.25)

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring
        cylinder(d = outer_r, r = rod_r, h = clip_h);

        // Tubing ring
        translate([15, 0, 0])
            cylinder(d = outer_tub_r, r = tub_r, h = clip_h);

        // Solid bridge between the rings
        translate([8, -bridge_y / 2, 0])
            cube([bridge_w, bridge_y, clip_h]);
    }

    // Rod opening: remove everything with x < 0 and -5 < y < 5 from the rod ring
    translate([-(outer_r + eps), -5, -eps])
        cube([rod_open_w + 2 * eps, 10, clip_h + 2 * eps]);

    // Tubing opening: remove x > 15 and -2.25 < y < 2.25 from the tubing ring
    translate([15, -tub_open_w / 2, -eps])
        cube([outer_tub_r - 15 + eps, tub_open_w, clip_h + 2 * eps]);
}