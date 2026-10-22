// 15 mL conical tube rack – 5 tubes, 30° lean, for volume reading / supernatant pipetting
// Units: mm. Part rests on the XY plane (z = 0) and is centred on the origin in X and Y.

// ---- Block dimensions (measured with calipers) ----
L = 130;   // block length along X
W = 60;    // block depth along Y
H = 45;    // block height along Z

// ---- Hole / tube parameters ----
n_tubes   = 5;    // number of tubes
spacing   = 24;   // centre-to-centre spacing of hole axes along X
hole_d    = 17.5; // hole diameter, measured square to its axis
hole_depth= 40;   // hole depth measured along its axis, from the top face
y_top     = -10;  // Y coordinate where each hole axis meets the top face (z = H)
tilt      = 30;   // lean angle from vertical, in the YZ plane (down into block -> +Y)

// ---- Derived geometry ----
// A 30° tilt from vertical means the axis makes 60° with the +Z axis,
// so the unit vector pointing down into the block is (0, sin60, -cos60).
down_vec  = [0, sin(60), -cos(60)];   // direction from top face into the block
top_pt    = [0, y_top, H];            // point where the axis meets the top face
bot_pt    = top_pt + hole_depth * down_vec; // flat bottom of the blind hole

// ---- Build ----
$fn = 64;

difference() {
    // Solid block, centred on the origin in X and Y, resting on z = 0
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // Five blind holes, each a cylinder with a flat end square to its axis
    for (i = [0 : n_tubes - 1]) {
        x = (i - (n_tubes - 1) / 2) * spacing;   // centred on the block in X
        translate([x, 0, 0])
            rotate([0, tilt, 0])                 // tilt the axis 30° in the YZ plane
            translate([0, y_top, H])             // axis meets the top face at y = -10
            cylinder(h = hole_depth, r = hole_d / 2, $fn = 64);
    }
}