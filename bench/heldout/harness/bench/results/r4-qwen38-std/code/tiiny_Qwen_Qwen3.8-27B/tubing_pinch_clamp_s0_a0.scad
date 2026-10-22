// Pinch clamp for silicone tubing (up to 6.4 mm across)
// Printed flat: 2-D profile in XY plane, extruded 8 mm along Z.

// ---- Global / shared dimensions ----
$fn = 64;                       // high resolution for round features

extrude_h   = 8;                // print thickness (Z)

// Lower jaw
lower_bar_x0 = 0;               // left end of lower bar
lower_bar_x1 = 50;              // right end of lower bar (before tongue)
lower_bar_y0 = 0;               // lower bar bottom edge
lower_bar_y1 = 4;               // lower bar top edge

lower_tongue_x0 = 50;           // tongue left end
lower_tongue_x1 = 56;           // tongue right end
lower_tongue_y0 = 2.5;          // tongue bottom edge
lower_tongue_y1 = 4;            // tongue top edge

// Upper jaw
upper_bar_x0 = 0;               // left end of upper bar
upper_bar_x1 = 60;              // right end of upper bar
upper_bar_y0 = 12;              // upper bar bottom edge
upper_bar_y1 = 16;              // upper bar top edge

// Living hinge (half-ring on x < 0 side, centred at (0, 8))
hinge_cx = 0;                   // hinge centre X
hinge_cy = 8;                   // hinge centre Y
hinge_r_out = 8;                // outer radius
hinge_r_in  = 7.2;              // inner radius (0.8 mm wall)

// Pinch ridges (half-round, 1.5 mm radius, on inner faces at x = 27.5)
ridge_x = 27.5;                 // ridge centre X
ridge_r = 1.5;                  // ridge radius
lower_ridge_cy = 4;             // lower ridge centre Y (top of lower bar)
upper_rridge_cy = 12;           // upper ridge centre Y (bottom of upper bar)

// Snap latch (hangs from upper jaw right end)
latch_leg_x0 = 57;              // leg left end
latch_leg_x1 = 60;              // leg right end
latch_leg_y0 = 4.5;             // leg bottom edge
latch_leg_y1 = 12;              // leg top edge

latch_nose_x0 = 54.5;           // nose left end
latch_nose_x1 = 57;             // nose right end
latch_nose_y0 = 4.5;            // nose bottom edge
latch_nose_y1 = 5.5;            // nose top edge (0.5 mm above tongue)

// ---- 2-D profile (XY plane) ----
profile = union() {
    // Lower jaw: bar + thinner tongue
    square([lower_bar_x1 - lower_bar_x0, lower_bar_y1 - lower_bar_y0],
           center = [false, false], origin = [lower_bar_x0, lower_bar_y0]);
    square([lower_tongue_x1 - lower_tongue_x0, lower_tongue_y1 - lower_tongue_y0],
           center = [false, false], origin = [lower_tongue_x0, lower_tongue_y0]);

    // Upper jaw: bar
    square([upper_bar_x1 - upper_bar_x0, upper_bar_y1 - upper_bar_y0],
           center = [false, false], origin = [upper_bar_x0, upper_bar_y0]);

    // Snap latch: leg + nose
    square([latch_leg_x1 - latch_leg_x0, latch_leg_y1 - latch_leg_y0],
           center = [false, false], origin = [latch_leg_x0, latch_leg_y0]);
    square([latch_nose_x1 - latch_nose_x0, latch_nose_y1 - latch_nose_y0],
           center = [false, false], origin = [latch_nose_x0, latch_nose_y0]);

    // Living hinge: half-ring on the x < 0 side
    difference() {
        circle(hinge_r_out, center = [hinge_cx, hinge_cy]);
        circle(hinge_r_in,  center = [hinge_cx, hinge_cy]);
    }
    // keep only the x < 0 half of the ring
    intersection() {
        difference() {
            circle(hinge_r_out, center = [hinge_cx, hinge_cy]);
            circle(hinge_r_in,  center = [hinge_cx, hinge_cy]);
        }
        square(2 * hinge_r_out + 2, center = [true, true],
               origin = [-hinge_r_out - 1, -hinge_r_out - 1]);
    }

    // Pinch ridges: half-round bumps on the inner faces
    // Lower ridge: bulges upward from y = 4
    intersection() {
        circle(ridge_r, center = [ridge_x, lower_ridge_cy]);
        square(2 * ridge_r + 2, center = [true, true],
               origin = [ridge_x - ridge_r - 1, lower_ridge_cy]);
    }
    // Upper ridge: bulges downward from y = 12
    intersection() {
        circle(ridge_r, center = [ridge_x, upper_rridge_cy]);
        square(2 * ridge_r + 2, center = [true, true],
               origin = [ridge_x - ridge_r - 1, upper_rridge_cy - 2 * ridge_r - 1]);
    }
};

// ---- Extrude 8 mm along Z (print orientation, resting on z = 0) ----
linear_extrude(height = extrude_h, center = false, convexity = 10) {
    profile;
}