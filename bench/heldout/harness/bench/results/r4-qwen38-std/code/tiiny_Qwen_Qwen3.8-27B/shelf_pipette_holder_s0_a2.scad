// ---- Dimensions (mm) ----
shelf_t   = 18;      // shelf thickness
gap       = 18.4;    // clamp opening for the shelf
spine_x0  = 0;       // spine left edge (against shelf)
spine_x1  = 5;       // spine right edge
spine_y0  = 0;       // spine bottom edge
spine_y1  = 28.4;    // spine top edge
jaw_x0    = -25;     // jaw outer edge (forward)
jaw_x1    = 5;       // jaw inner edge (against shelf)
bot_y0    = 0;       // bottom jaw bottom edge
bot_y1    = 5;       // bottom jaw top edge
top_y0    = 23.4;    // top jaw bottom edge
top_y1    = 28.4;    // top jaw top edge
arm_x0    = -25;     // arm left edge
arm_x1    = 65;      // arm right edge (forward tip)
extrude   = 105;     // print length along Z (pipette length in use)
hole_d    = 20;      // pipette bore diameter
hole_x    = 42;      // bore centre in X (forward from shelf)
hole_z    = [17.5, 52.5, 87.5];  // bore centres along Z

$fn = 64;

// ---- C-shaped 2-D profile in the XY plane (print orientation) ----
profile = union() {
    // spine: x 0..5, y 0..28.4
    translate([spine_x0, spine_y0])
        square([spine_x1 - spine_x0, spine_y1 - spine_y0]);
    // bottom jaw: x -25..5, y 0..5
    translate([jaw_x0, bot_y0])
        square([jaw_x1 - jaw_x0, bot_y1 - bot_y0]);
    // top jaw + forward arm: x -25..65, y 23.4..28.4
    translate([arm_x0, top_y0])
        square([arm_x1 - arm_x0, top_y1 - top_y0]);
};

// ---- Extrude the profile 105 mm along Z (print axis) ----
body = linear_extrude(height = extrude) profile;

// ---- Three 20 mm bores through the arm, axis along Y (vertical in use) ----
// Each cutter is a cylinder whose axis is Y, extended 1 mm past each face.
holes = for (z = hole_z)
    translate([hole_x, -1, z])
        rotate([90, 0, 0])
        cylinder(h = extrude + 2, r = hole_d / 2, $fn = $fn);

// ---- Final solid ----
difference() {
    body;
    holes;
}