// Pinch clamp for silicone tubing (up to 6.4 mm across)
// Printed flat: 2-D profile in XY, extruded 8 mm along Z.
// Rests on XY plane at z = 0, builds upward (+Z). Centred on origin in X and Y.

$fn = 64;

// ---- Global dimensions (mm) ----
extrude_h   = 8;    // print thickness along Z

// Lower jaw
lower_bar_x0 = 0;   // left end of lower bar
lower_bar_x1 = 50;  // right end of lower bar (start of tongue)
lower_bar_y0 = 0;   // bottom face of lower bar
lower_bar_y1 = 4;   // top face of lower bar
lower_tongue_x0 = 50; // left end of tongue
lower_tongue_x1 = 56; // right end of tongue
lower_tongue_y0 = 2.5; // bottom face of tongue
lower_tongue_y1 = 4;   // top face of tongue

// Upper jaw
upper_bar_x0 = 0;   // left end of upper bar
upper_bar_x1 = 60;  // right end of upper bar
upper_bar_y0 = 12;  // bottom face of upper bar
upper_bar_y1 = 16;  // top face of upper bar

// Living hinge (half-ring on x < 0 side, centred at (0, 8))
hinge_cx = 0;
hinge_cy = 8;
hinge_r_inner = 7.2; // inner radius
hinge_r_outer = 8.0; // outer radius (0.8 mm thick)

// Pinch ridges (half-round, 1.5 mm radius, on inner faces at x = 27.5)
ridge_x = 27.5;
ridge_r = 1.5;
lower_ridge_cy = 4;  // centred on lower jaw inner face (y = 4)
upper_ridge_cy = 12; // centred on upper jaw inner face (y = 12)

// Snap latch (hangs from upper jaw right end)
latch_leg_x0 = 57;   // left end of latch leg
latch_leg_x1 = 60;   // right end of latch leg
latch_leg_y0 = 4.5;  // bottom face of latch leg
latch_leg_y1 = 12;   // top face of latch leg (meets upper bar bottom)
latch_nose_x0 = 54.5; // left end of nose
latch_nose_x1 = 57;   // right end of nose
latch_nose_y0 = 4.5;  // bottom face of nose
latch_nose_y1 = 5.5;  // top face of nose (0.5 mm above tongue top at y = 5)

// ---- 2-D profile pieces (in XY plane) ----

// Lower jaw: bar + tongue
module lower_profile() { union() {
    square([lower_bar_x1 - lower_bar_x0, lower_bar_y1 - lower_bar_y0],
           center = [false, false]);
    square([lower_tongue_x1 - lower_tongue_x0, lower_tongue_y1 - lower_tongue_y0],
           center = [false, false]);
} }

// Upper jaw: bar
module upper_profile() { square([upper_bar_x1 - upper_bar_x0, upper_bar_y1 - upper_bar_y0],
                       center = [false, false]); }

// Hinge: half-ring on x < 0 side (left half of annulus centred at (0, 8))
module hinge_half() { intersection() {
    difference() {
        circle(d = hinge_r_outer * 2, $fn = $fn);
        circle(d = hinge_r_inner * 2, $fn = $fn);
    }
    square([100, 100], center = [false, false]); // x <= 0, all y
} }

// Lower pinch ridge: half-circle bulging into the gap (y > 4 side)
module lower_ridge() { intersection() {
    circle(d = ridge_r * 2, $fn = $fn);
    square([100, 100], center = [false, false]); // y >= 4
} }

// Upper pinch ridge: half-circle bulging into the gap (y < 12 side)
module upper_ridge() { intersection() {
    circle(d = ridge_r * 2, $fn = $fn);
    square([100, 100], center = [false, false]); // y <= 12
} }

// Latch leg
module latch_leg() { square([latch_leg_x1 - latch_leg_x0, latch_leg_y1 - latch_leg_y0],
                   center = [false, false]); }

// Latch nose
module latch_nose() { square([latch_nose_x1 - latch_nose_x0, latch_nose_y1 - latch_nose_y0],
                    center = [false, false]); }

// ---- Assemble 2-D profile ----
module profile() { union() {
    lower_profile();
    upper_profile();
    hinge_half();
    lower_ridge();
    upper_ridge();
    latch_leg();
    latch_nose();
} }

// ---- Extrude and centre on origin in X and Y ----
// Bounding box of the profile:
// x_min = -hinge_r_outer (leftmost point of hinge)
// x_max = upper_bar_x1 (rightmost point of upper bar / latch leg)
// y_min = lower_bar_y0
// y_max = upper_bar_y1
x_min = -hinge_r_outer;
x_max = upper_bar_x1;
y_min = lower_bar_y0;
y_max = upper_bar_y1;

translate([-(x_min + x_max) / 2, -(y_min + y_max) / 2, 0])
    linear_extrude(height = extrude_h, center = false)
        profile();