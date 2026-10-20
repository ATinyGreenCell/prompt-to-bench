// ---------- Parameters ----------
rod_inner_d = 12.7;          // inner diameter of the rod ring (mm)
rod_wall = 3;                // wall thickness of the rod ring (mm)
rod_outer_d = rod_inner_d + 2*rod_wall; // outer diameter of the rod ring (mm)

tubing_inner_d = 6;          // inner diameter of the tubing ring (mm)
tubing_wall = 2;             // wall thickness of the tubing ring (mm)
tubing_outer_d = tubing_inner_d + 2*tubing_wall; // outer diameter of the tubing ring (mm)

rod_center = [0,0];          // centre of the rod ring (mm)
tubing_center = [15,0];      // centre of the tubing ring (mm)

bridge_x_start = 8;          // left x‑edge of the bridge (mm)
bridge_x_end   = 12;         // right x‑edge of the bridge (mm)
bridge_width_y = 6;          // total width in Y direction (mm)

height = 10;                 // extrusion height (mm)

$fn = 64;                    // resolution for circles/cylinders

// ---------- Helper: translation to centre whole part ----------
min_x = -rod_outer_d/2;                     // leftmost point of the whole part
max_x = tubing_center[0] + tubing_outer_d/2; // rightmost point of the whole part
center_shift_x = -( (max_x + min_x)/2 );    // shift needed to centre on origin

// ---------- Modules ----------
module rod_ring() {
    // Ring (outer cylinder minus inner cylinder)
    difference(){
        // outer cylinder
        cylinder(r=rod_outer_d/2, h=height, center=true);
        // inner cylinder (cut a little extra in Z)
        cylinder(r=rod_inner_d/2, h=height+0.02, center=true);
        // opening on the -X side (x < 0, -5 < y < 5)
        translate([-200, -5, -height/2-0.01])
            cube([200, 10.02, height+0.02]); // extends far beyond the ring
    }
    translate(rod_center) {} // centre is already at origin
}

module tubing_ring() {
    // Ring (outer cylinder minus inner cylinder)
    difference(){
        // outer cylinder
        cylinder(r=tubing_outer_d/2, h=height, center=true);
        // inner cylinder (cut a little extra in Z)
        cylinder(r=tubing_inner_d/2, h=height+0.02, center=true);
        // opening on the +X side (x > 15, -2.25 < y < 2.25)
        translate([tubing_center[0], -2.25, -height/2-0.01])
            cube([200, 4.52, height+0.02]); // extends far beyond the ring
    }
    translate(tubing_center) {} // already placed
}

module bridge() {
    // Solid bridge 6 mm wide (Y) between x = 8 and x = 12
    translate([ (bridge_x_start+bridge_x_end)/2, 0, 0])
        cube([bridge_x_end-bridge_x_start, bridge_width_y, height], center=true);
}

// ---------- Assembly ----------
translate([center_shift_x, 0, 0])  // centre whole part on the origin
union() {
    rod_ring();
    tubing_ring();
    bridge();
}