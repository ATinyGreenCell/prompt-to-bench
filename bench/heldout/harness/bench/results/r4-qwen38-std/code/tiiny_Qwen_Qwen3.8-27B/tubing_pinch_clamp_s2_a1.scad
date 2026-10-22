// Pinch clamp for silicone tubing (up to 6.4 mm across)
// Printed flat: 2-D profile in XY plane, extruded 8 mm along Z.

$fn = 64;

// ---- Global dimensions (mm) ----
extrude_h   = 8;    // thickness of the part along Z

// Lower jaw
lower_bar_x0  = 0;
lower_bar_x1  = 50;
lower_bar_y0  = 0;
lower_bar_y1  = 4;

lower_tongue_x0 = 50;
lower_tongue_x1 = 56;
lower_tongue_y0 = 2.5;
lower_tongue_y1 = 4;

// Upper jaw
upper_bar_x0  = 0;
upper_bar_x1  = 60;
upper_bar_y0  = 12;
upper_bar_y1  = 16;

// Living hinge (half-ring on x < 0 side, centred at (0, 8))
hinge_cx      = 0;
hinge_cy      = 8;
hinge_r_out   = 8;
hinge_r_in    = 7.2;

// Pinch ridges (half-round, 1.5 mm radius, at x = 27.5)
ridge_x       = 27.5;
ridge_r       = 1.5;
lower_ridge_cy = 4;   // on lower jaw inner face
upper_ridge_cy = 12;  // on upper jaw inner face

// Snap latch (hangs from upper jaw right end)
latch_leg_x0  = 57;
latch_leg_x1  = 60;
latch_leg_y0  = 4.5;
latch_leg_y1  = 12;

latch_nose_x0 = 54.5;
latch_nose_x1 = 57;
latch_nose_y0 = 4.5;
latch_nose_y1 = 5.5;

// ---- 2-D profile pieces (in XY plane) ----

// Lower jaw: bar + thinner tongue
lower_profile = union() {
    square([lower_bar_x1 - lower_bar_x0, lower_bar_y1 - lower_bar_y0],
           origin=[lower_bar_x0, lower_bar_y0]);
    square([lower_tongue_x1 - lower_tongue_x0, lower_tongue_y1 - lower_tongue_y0],
           origin=[lower_tongue_x0, lower_tongue_y0]);
};

// Upper jaw: bar
upper_profile = square([upper_bar_x1 - upper_bar_x0, upper_bar_y1 - upper_bar_y0],
                       origin=[upper_bar_x0, upper_bar_y0]);

// Living hinge: half-ring on x < 0 side, centred at (0, 8)
hinge_profile = difference() {
    circle(hinge_r_out, center=[hinge_cx, hinge_cy]);
    circle(hinge_r_in,  center=[hinge_cx, hinge_cy]);
    // keep only the x < 0 half
    square([hinge_r_out + 1, 2 * hinge_r_out + 2],
           origin=[hinge_cx, hinge_cy - hinge_r_out - 1]);
};

// Pinch ridge on lower jaw inner face (bulges into the gap, y > 4)
lower_ridge = circle(ridge_r, center=[ridge_x, lower_ridge_cy]);

// Pinch ridge on upper jaw inner face (bulges into the gap, y < 12)
upper_ridge = circle(ridge_r, center=[ridge_x, upper_ridge_cy]);

// Snap latch: leg + nose
latch_profile = union() {
    square([latch_leg_x1 - latch_leg_x0, latch_leg_y1 - latch_leg_y0],
           origin=[latch_leg_x0, latch_leg_y0]);
    square([latch_nose_x1 - latch_nose_x0, latch_nose_y1 - latch_nose_y0],
           origin=[latch_nose_x0, latch_nose_y0]);
};

// ---- Assemble the full 2-D profile ----
full_profile = union() {
    lower_profile;
    upper_profile;
    hinge_profile;
    lower_ridge;
    upper_ridge;
    latch_profile;
};

// ---- Extrude 8 mm along Z (print orientation: rests on z = 0, builds +Z) ----
linear_extrude(height = extrude_h)
    full_profile;