// ---------------------------
// Parameters (mm)
// ---------------------------
rod_inner_d   = 12.7;          // inner diameter of the stand‑rod ring
rod_wall      = 3;            // wall thickness of the stand‑rod ring
rod_outer_d   = rod_inner_d + 2*rod_wall; // outer diameter of the stand‑rod ring
rod_open_w    = 10;           // width of the opening on the -X side of the rod ring

tube_inner_d  = 6;            // inner diameter of the tubing ring
tube_wall     = 2;            // wall thickness of the tubing ring
tube_outer_d  = tube_inner_d + 2*tube_wall; // outer diameter of the tubing ring
tube_center_x = 15;          // X‑position of the tubing ring centre
tube_open_w   = 4.5;          // width of the opening on the +X side of the tubing ring

part_h        = 10;           // total height (extrusion Z)

bridge_x_start = 8;           // left X of the solid bridge
bridge_x_end   = 12;          // right X of the solid bridge
bridge_y_w    = 6;            // Y width of the bridge

// Rendering quality for circles/cylinders
$fn = 64;

// ---------------------------
// Modules
// ---------------------------

// Stand‑rod ring with its snap‑on opening
module rod_ring() {
    difference() {
        // Outer cylinder (solid)
        cylinder(d = rod_outer_d, h = part_h);
        // Inner hole (extends 0.2 mm beyond top/bottom)
        cylinder(d = rod_inner_d, h = part_h + 0.2);
        // Opening cut on the -X side
        translate([-rod_outer_d/2 - 0.1, -rod_open_w/2, -0.1])
            cube([rod_outer_d + 0.2, rod_open_w, part_h + 0.2]);
    }
}

// Tubing ring with its snap‑on opening
module tubing_ring() {
    translate([tube_center_x, 0, 0])  // centre the ring at (tube_center_x,0)
    difference() {
        // Outer cylinder
        cylinder(d = tube_outer_d, h = part_h);
        // Inner hole (extends 0.2 mm beyond top/bottom)
        cylinder(d = tube_inner_d, h = part_h + 0.2);
        // Opening cut on the +X side
        translate([tube_outer_d/2 + 0.1, -tube_open_w/2, -0.1])
            cube([tube_outer_d + 0.2, tube_open_w, part_h + 0.2]);
    }
}

// Solid bridge joining the two rings
module bridge() {
    translate([bridge_x_start, -bridge_y_w/2, 0])
        cube([bridge_x_end - bridge_x_start, bridge_y_w, part_h]);
}

// ---------------------------
// Assembly
// ---------------------------
union() {
    rod_ring();
    tubing_ring();
    bridge();
}