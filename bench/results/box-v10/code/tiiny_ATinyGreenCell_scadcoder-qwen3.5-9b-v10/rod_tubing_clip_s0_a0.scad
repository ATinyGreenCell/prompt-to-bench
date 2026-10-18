// Tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded along +Z

$fn = 96;

// ---- Dimensions (mm) ----
ring_od      = 18.7;   // rod ring outer diameter
ring_id      = 12.7;   // rod ring inner diameter
ring_wall    = 3;      // rod ring wall thickness
rod_opening  = 10;     // width of the cut out of the -X side of the rod ring

tube_id      = 6;      // tubing ring inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_od      = tube_id + 2 * tube_wall;  // tubing ring outer diameter (8 mm)
tube_x       = 15;     // centre of the tubing ring (X)
tube_opening = 4.5;    // width of the cut out of the +X side of the tubing ring

bridge_w     = 6;      // width of the solid bridge (Y)
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)

eps          = 0.5;    // overcut so cutting shapes are not coplanar with faces

// ---- Model ----
union() {
    // Rod ring with a 10 mm wide opening on the -X side
    difference() {
        cylinder(h = ring_wall, d = ring_od);
        translate([0, 0, -eps])
            hull() {
                for (y = [-ring_od / 2, ring_od / 2])
                    translate([-ring_od / 2 - eps, y, 0])
                        cube([ring_od / 2 + eps + 1, 1, ring_wall + 2 * eps]);
            }
    }

    // Tubing ring with a 4.5 mm wide opening on the +X side
    difference() {
        translate([tube_x, 0, 0])
            cylinder(h = tube_wall, d = tube_od);
        translate([tube_x, 0, -eps])
            hull() {
                for (y = [-tube_opening / 2, tube_opening / 2])
                    translate([tube_x + tube_opening / 2 + eps, y, 0])
                        cube([tube_opening / 2 + eps + 1, 1, tube_wall + 2 * eps]);
            }
    }

    // Solid bridge between the two rings (X = 8 to X = 12)
    translate([bridge_x0, -bridge_w / 2, 0])
        cube([bridge_x1 - bridge_x0 + eps, bridge_w, ring_wall + 2 * eps]);
}