// 15 mL conical tube rack – 5 tubes, 30° lean, solid block
// Units: mm. Print orientation: rests on XY plane (z=0), builds +Z, centred on origin in X,Y.

// ---- Block dimensions (measured with calipers) ----
L = 130;   // length along X
W = 60;    // depth  along Y
H = 45;    // height along Z

// ---- Hole parameters ----
n_tubes   = 5;          // number of tubes
spacing   = 24;         // hole spacing along X (centres)
hole_d    = 17.5;       // hole diameter, square to its axis
hole_r    = hole_d / 2; // 8.75
hole_depth= 40;         // depth measured along the axis, from the top face
y_top     = -10;        // Y coordinate where each axis meets the top face (z = H)
lean      = 30;         // tilt from vertical, in the YZ plane (down into block -> +Y)

// ---- Derived geometry ----
// Unit vector pointing DOWN into the block along a hole axis:
//   tilted 30° from vertical toward +Y  =>  (0, sin(30°), -cos(30°))
down_y = sin(lean);     // 0.5
down_z = -cos(lean);    // -0.8660254

// The axis meets the top face (z = H) at y = y_top.
// A point on the axis at distance t along the axis (downward) is:
//   P(t) = (x, y_top + t*down_y, H + t*down_z)
// The flat bottom of the hole is at t = hole_depth.
// The cylinder used for the cut is centred at the midpoint t = hole_depth/2,
// and is extended 1 mm past both ends so no faces are exactly coplanar.
cut_len   = hole_depth + 2;                 // 42 mm, 1 mm past each end
cut_mid_t = hole_depth / 2;                 // 20 mm
cut_mid_y = y_top + cut_mid_t * down_y;     // -10 + 20*0.5 = 0
cut_mid_z = H     + cut_mid_t * down_z;     // 45 + 20*(-0.8660254) = 27.6794919

// X positions of the five hole centres (centred on the block)
xs = [ (i - (n_tubes - 1) / 2) * spacing for (i = [0 : n_tubes - 1]) ];
// => [-48, -24, 0, 24, 48]

// ---- Build ----
$fn = 64;

difference() {
    // Solid block, centred on origin in X and Y, sitting on z = 0
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // Five blind holes, each a cylinder square to its tilted axis
    for (x = xs) {
        translate([x, cut_mid_y, cut_mid_z])
        rotate([0, lean, 0])          // tilt the cylinder axis 30° from vertical toward +Y
            cylinder(h = cut_len, r = hole_r, $fn = 64);
    }
}