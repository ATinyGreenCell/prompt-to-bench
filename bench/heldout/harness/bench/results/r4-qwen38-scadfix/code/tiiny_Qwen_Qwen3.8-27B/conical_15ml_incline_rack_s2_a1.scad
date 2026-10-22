// 15 mL conical tube rack – 5 tubes, 30° lean, for volume reading / supernatant pipetting
// Units: millimetres. Print orientation: rests on XY plane (z = 0), builds +Z, centred on origin in X & Y.

// ---- Block dimensions (measured with calipers) ----
L = 130;   // block length along X
W = 60;    // block depth along Y
H = 45;    // block height along Z

// ---- Hole / tube parameters ----
n_tubes   = 5;          // number of tubes
spacing   = 24;         // centre-to-centre spacing along X
hole_d    = 17.5;       // hole diameter (square to its axis)
hole_r    = hole_d / 2; // hole radius
hole_depth= 40;         // depth measured along the hole axis, from the top face
lean      = 30;         // lean angle from vertical, in the YZ plane
y_top     = -10;        // Y coordinate where each hole axis meets the top face (z = H)

// ---- Derived geometry (for the for-loop) ----
// X positions of the 5 hole axes, centred on the block
xs = [for (i = 0; i < n_tubes; i++) (i - (n_tubes - 1) / 2) * spacing];

// Unit vector pointing DOWN into the block along a hole axis.
// Tilted 30° from vertical in the YZ plane, moving toward +Y as it goes down.
// (cos(lean) in -Z, sin(lean) in +Y)
dirY = sin(lean * $pi / 180);
dirZ = -cos(lean * $pi / 180);

// ---- Solid block, centred on origin in X and Y, sitting on z = 0 ----
module block() {
    translate([-L / 2, -W / 2, 0])
        cube([L, W, H]);
}

// ---- Five blind holes, each a cylinder square to its axis with a flat end ----
// Each cutter is a cylinder of radius hole_r and length hole_depth,
// whose axis starts at (x, y_top, H) and runs down into the block.
// The cylinder is rotated so its local +Z aligns with the hole axis,
// then translated to the top-face entry point.
// The cylinder extends 1 mm past the flat end (into the block) so the
// difference() cut is clean and no faces are exactly coplanar.
difference() {
    block();

    for (x = xs) {
        translate([x, y_top, H])
        rotate([lean, 0, 0])
        cylinder(
            h = hole_depth + 1,   // 1 mm extra so the flat end is fully inside the block
            r = hole_r,
            $fn = 64
        );
    }
}