//---------------------------
//  Parameters (mm)
//---------------------------
rod_inner_d   = 12.7;   // inner diameter of the stand rod
rod_wall      = 3;      // wall thickness of the rod ring
rod_outer_d   = rod_inner_d + 2*rod_wall; // outer diameter of the rod ring

tube_inner_d  = 6;      // inner diameter of the tubing
tube_wall     = 2;      // wall thickness of the tubing ring
tube_outer_d  = tube_inner_d + 2*tube_wall; // outer diameter of the tubing ring

rod_center    = [0,0];          // centre of the rod ring
tube_center   = [15,0];         // centre of the tubing ring

bridge_x_start = 8;            // left x‑edge of the bridge
bridge_x_end   = 12;           // right x‑edge of the bridge
bridge_width_y = 6;            // total Y width of the bridge (full height)

height        = 10;            // extrusion height (Z direction)

// small over‑extension for cut shapes (to avoid coplanar faces)
over_cut = 0.02;

// set resolution for circles
$fn = 64;

//---------------------------
//  2‑D geometry
//---------------------------

// Rod ring with opening on its -X side
module rod_with_opening() {
    difference() {
        // full ring
        translate(rod_center)
            difference() {
                circle(d = rod_outer_d);
                circle(d = rod_inner_d);
            }
        // opening rectangle (x < 0, -5 < y < 5)
        translate([-1000, -5 - over_cut])
            square([1000 + over_cut, 10 + 2*over_cut]);
    }
}

// Tubing ring with opening on its +X side
module tube_with_opening() {
    difference() {
        // full ring
        translate(tube_center)
            difference() {
                circle(d = tube_outer_d);
                circle(d = tube_inner_d);
            }
        // opening rectangle (x > 15, -2.25 < y < 2.25)
        translate([tube_center[0], -2.25 - over_cut])
            square([1000 + over_cut, 4.5 + 2*over_cut]);
    }
}

// Solid bridge joining the two rings
module bridge() {
    translate([bridge_x_start, -bridge_width_y/2 - over_cut])
        square([bridge_x_end - bridge_x_start, bridge_width_y + 2*over_cut]);
}

//---------------------------
//  Assemble 2‑D profile
//---------------------------
module profile_2d() {
    union() {
        rod_with_opening();
        tube_with_opening();
        bridge();
    }
}

//---------------------------
//  Extrude to 3‑D part
//---------------------------
linear_extrude(height = height)
    profile_2d();