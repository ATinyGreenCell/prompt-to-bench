// Stand rod and tubing clip - printed flat, 10 mm tall extrusion
// Units: mm. Snap-on ring for a 12.7 mm (1/2") lab stand rod and a
// 6 mm inner-diameter tubing ring, joined by a solid bridge.

$fn = 96;

// ---- Dimensions ----
extrusion_height   = 10;     // Z height of the 2-D profile
stand_d            = 12.7;   // stand rod diameter
stand_wall         = 3;      // stand ring wall thickness
stand_outer        = stand_d + 2 * stand_wall; // 18.7 mm
stand_opening_w    = 10;     // width of the -X side cutout
tubing_d           = 6;      // tubing ring inner diameter
tubing_wall        = 2;      // tubing ring wall thickness
tubing_opening_w   = 4.5;    // width of the +X side cutout
bridge_x0          = 8;      // bridge start (X)
bridge_x1          = 12;     // bridge end (X)
bridge_y           = 6;      // bridge width (Y)

// ---- Cutting overlap ----
eps = 0.5;   // extension past cut faces to avoid coplanar faces

// ---- Model ----
difference() {
    union() {
        // Stand ring, centred at origin
        cylinder(d = stand_outer, h = extrusion_height);
        // Tubing ring, centred at x = 15, y = 0
        translate([15, 0, 0])
            cylinder(d = tubing_d + 2 * tubing_wall, h = extrusion_height);
        // Solid bridge between x = 8 and x = 12
        translate([bridge_x0, -bridge_y / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_y, extrusion_height]);
    }
    // Stand opening: x < 0, -5 < y < 5
    translate([-stand_opening_w / 2 - eps, -5, 0])
        cube([stand_opening_w + 2 * eps, 10, extrusion_height + eps]);
    // Tubing opening: x > 15, -2.25 < y < 2.25
    translate([15 - tubing_opening_w / 2, -tubing_opening_w / 2, 0])
        cube([tubing_opening_w + 2 * eps, tubing_opening_w + 2 * eps,
               extrusion_height + eps]);
}