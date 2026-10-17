// Tubing clip for 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on bed, builds up in +Z

// ---- Parameters ----
stand_d      = 12.7;   // stand rod inner diameter
stand_wall   = 3;      // stand ring wall thickness
stand_od     = stand_d + 2 * stand_wall;  // stand ring outer diameter (18.7)

tube_d       = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_od      = tube_d + 2 * tube_wall;    // tubing ring outer diameter (10)

bridge_w     = 6;      // bridge width in Y
bridge_x0    = 8;      // bridge start in X
bridge_x1    = 12;     // bridge end in X

opening1_w   = 10;     // stand ring opening width (X < 0, -5 < y < 5)
opening2_w   = 4.5;    // tubing ring opening width (X > 15, -2.25 < y < 2.25)

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---- Model ----
height = 10;  // extrusion height in Z

difference() {
    union() {
        // Stand ring
        cylinder(d = stand_od, h = height);
        // Tubing ring
        translate([15, 0, 0]) cylinder(d = tube_od, h = height);
        // Solid bridge
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, height]);
    }
    // Stand ring opening
    translate([-stand_od/2 - eps, -opening1_w/2, -eps])
        cube([opening1_w, opening1_w, height + 2*eps]);
    // Tubing ring opening
    translate([15, -opening2_w/2, -eps])
        cube([opening2_w, opening2_w, height + 2*eps]);
}