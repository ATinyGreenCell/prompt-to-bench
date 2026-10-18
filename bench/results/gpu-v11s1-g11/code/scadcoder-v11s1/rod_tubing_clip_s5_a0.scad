// Tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded in +Z

$fn = 96;

// ---- Ring 1: rod ring ----
ring1_id   = 12.7;   // inner diameter (rod clearance)
ring1_wall = 3;      // wall thickness
ring1_od   = ring1_id + 2 * ring1_wall; // outer diameter = 18.7
ring1_x0   = 0;      // centre X
ring1_y0   = 0;      // centre Y

// ---- Ring 2: tubing ring ----
ring2_id   = 6;      // inner diameter
ring2_wall = 2;      // wall thickness
ring2_od   = ring2_id + 2 * ring2_wall; // outer diameter = 10
ring2_x0   = 15;     // centre X
ring2_y0   = 0;      // centre Y

// ---- Opening cuts ----
open1_w = 10;        // rod ring opening width (-X side)
open2_w = 4.5;       // tubing ring opening width (+X side)

// ---- Bridge ----
bridge_x0 = 10;      // bridge centre X (between x = 8 and x = 12)
bridge_w  = 6;       // bridge width (Y)

// ---- Misc ----
eps = 0.5;           // cut overshoot past faces
ht  = 10;            // extrusion height (Z)

difference() {
    union() {
        // Rod ring
        cylinder(d = ring1_od, h = ht);
        // Tubing ring
        translate([ring2_x0, ring2_y0, 0])
            cylinder(d = ring2_od, h = ht);
        // Bridge
        translate([bridge_x0 - bridge_w / 2, -bridge_w / 2, 0])
            cube([bridge_w, bridge_w, ht]);
    }
    // Cut out rod ring opening (x < 0, -5 < y < 5)
    translate([-ring1_od - eps, -open1_w / 2, 0])
        cube([ring1_od + 2 * eps, open1_w, ht + eps]);
    // Cut out tubing ring opening (x > 15, -2.25 < y < 2.25)
    translate([ring2_x0, -open2_w / 2, 0])
        cube([ring2_od + 2 * eps, open2_w, ht + eps]);
}