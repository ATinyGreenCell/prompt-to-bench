// Snap-on tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded in +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d        = 12.7;   // stand rod diameter
wall_r       = 3;      // rod ring wall thickness
opening_w    = 10;     // rod ring opening width (-X side)
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)
bridge_w     = 6;      // bridge width (Y)
tube_d       = 6;      // tubing ring diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_open_w  = 4.5;    // tubing opening width (+X side)
tube_offset  = 15;     // tubing ring centre X
height       = 10;     // extrusion height (Z)
eps          = 0.5;    // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // Rod ring
        cylinder(d = rod_d + 2 * wall_r, h = height);
        // Opening in rod ring
        translate([-opening_w / 2, -opening_w / 2, -eps])
            cube([opening_w, opening_w, height + 2 * eps]);
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, height]);
        // Tubing ring
        translate([tube_offset, 0, 0])
            cylinder(d = tube_d + 2 * tube_wall, h = height);
        // Opening in tubing ring
        translate([tube_offset + tube_open_w / 2 - tube_d - 2 * tube_wall,
                   -tube_open_w / 2, -eps])
            cube([tube_open_w + tube_d + 2 * tube_wall,
                  tube_open_w,
                  height + 2 * eps]);
    }
    // Remove overlapping bridge material from rings
    translate([bridge_x0 - eps, -bridge_w / 2, -eps])
        cube([bridge_x1 - bridge_x0 + 2 * eps,
              bridge_w,
              height + 2 * eps]);
}