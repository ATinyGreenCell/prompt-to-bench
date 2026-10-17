// Snap-on clip: holds a piece of tubing next to a 12.7 mm lab stand rod
// Printed flat: 2-D profile in XY, extruded 10 mm in +Z

$fn = 128;

// ---- Dimensions (mm) ----
rod_d      = 12.7;              // rod ring inner diameter
rod_wall   = 3;                 // rod ring wall thickness
rod_od     = rod_d + 2*rod_wall; // rod ring outer diameter (18.7)

tub_d      = 6;                 // tubing ring inner diameter
tub_wall   = 2;                 // tubing ring wall thickness
tub_od     = tub_d + 2*tub_wall; // tubing ring outer diameter (10)

rod_gap    = 10;                // width of opening in rod ring on -X side (y from -5 to 5)
tub_gap    = 4.5;               // width of opening in tubing ring on +X side (y from -2.25 to 2.25)

bridge_w   = 6;                 // bridge width in Y
bridge_x0  = 8;                 // bridge start in X
bridge_x1  = 12;                // bridge end in X

clip_h     = 10;                // extrusion height (Z)

eps        = 0.5;               // overshoot for clean cuts

// ---- Model ----
difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = clip_h);
        // Tubing ring
        translate([15, 0, 0]) cylinder(d = tub_od, h = clip_h);
        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, clip_h]);
    }

    // Opening in rod ring: x < 0, -5 < y < 5
    translate([-(rod_od/2 + eps), -rod_gap/2, -eps])
        cube([rod_od/2 + eps, rod_gap, clip_h + 2*eps]);

    // Opening in tubing ring: x > 15, -2.25 < y < 2.25
    translate([15, -tub_gap/2, -eps])
        cube([tub_od/2 + eps, tub_gap, clip_h + 2*eps]);
}