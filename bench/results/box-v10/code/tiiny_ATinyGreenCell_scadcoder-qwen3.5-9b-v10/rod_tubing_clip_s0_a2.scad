// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on bed, extrusion along +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_id      = 12.7;   // rod ring inner diameter
rod_wall    = 3;      // rod ring wall thickness
rod_od      = rod_id + 2 * rod_wall;    // 18.7 mm outer diameter

tube_id     = 6;      // tubing ring inner diameter
tube_wall   = 2;      // tubing ring wall thickness
tube_od     = tube_id + 2 * tube_wall;  // 10 mm outer diameter

bridge_w    = 6;      // bridge width in Y
bridge_x0   = 8;      // bridge start in X
bridge_x1   = 12;     // bridge end in X

eps         = 0.5;    // cutter overshoot past faces

// ---- Model ----
union() {
    // Rod ring with 10 mm opening cut out of -X side
    difference() {
        translate([0, 0, 0])
            cylinder(d = rod_od, h = rod_wall);
        translate([-eps, 0, -eps])
            hull() {
                for (y = [-5, 5])
                    translate([0, y, 0])
                        cube([10 + 2 * eps, 1, 1 + 2 * eps]);
            }
    }

    // Tubing ring with 4.5 mm opening cut out of +X side
    difference() {
        translate([15, 0, 0])
            cylinder(d = tube_od, h = tube_wall);
        translate([15, 0, -eps])
            hull() {
                for (y = [-2.25, 2.25])
                    translate([0, y, 0])
                        cube([4.5 + 2 * eps, 1, 1 + 2 * eps]);
            }
    }

    // Solid bridge between x = 8 and x = 12
    translate([bridge_x0, -bridge_w / 2, 0])
        cube([bridge_x1 - bridge_x0 + eps, bridge_w, rod_wall + eps]);
}