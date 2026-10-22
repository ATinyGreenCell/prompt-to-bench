// Pinch clamp for silicone tubing - living hinge + snap latch
// 2-D profile in XY, extruded along Z. Coordinates as specified by user.

$fn = 64;

thk        = 8;      // extrusion depth along Z

// Lower jaw
low_len    = 50;     // lower bar length (x 0..50)
low_t      = 4;      // lower bar thickness (y 0..4)
tongue_x1  = 56;     // tongue end x
tongue_y0  = 2.5;    // tongue bottom y

// Upper jaw
up_len     = 60;     // upper bar length (x 0..60)
up_y0      = 12;     // upper bar bottom y
up_y1      = 16;     // upper bar top y

// Hinge half-ring
hinge_cy   = 8;      // hinge centre y (centre x = 0)
hinge_ro   = 8;      // outer radius
hinge_ri   = 7.2;    // inner radius (0.8 mm wall)
hinge_ov   = 0.5;    // overlap into jaws for a clean union

// Pinch ridges
ridge_x    = 27.5;   // ridge x position
ridge_r    = 1.5;    // ridge radius
ridge_y_lo = 4;       // lower ridge centre y
ridge_y_up = 12;      // upper ridge centre y

// Latch
leg_x0     = 57;     // leg left x
leg_x1     = 60;     // leg right x
leg_y0     = 4.5;    // leg bottom y
nose_x0    = 54.5;   // nose left x
nose_y1    = 5.5;    // nose top y

module profile() {
    union() {
        // lower jaw bar
        translate([0, 0]) square([low_len, low_t]);
        // tongue
        translate([low_len - 0.01, tongue_y0])
            square([tongue_x1 - low_len + 0.01, low_t - tongue_y0]);
        // upper jaw bar
        translate([0, up_y0]) square([up_len, up_y1 - up_y0]);
        // hinge half-ring (x < 0 side)
        intersection() {
            difference() {
                translate([0, hinge_cy]) circle(r = hinge_ro);
                translate([0, hinge_cy]) circle(r = hinge_ri);
            }
            translate([-hinge_ro - 1, 0])
                square([hinge_ro + 1 + hinge_ov, up_y1]);
        }
        // pinch ridges
        translate([ridge_x, ridge_y_lo]) circle(r = ridge_r);
        translate([ridge_x, ridge_y_up]) circle(r = ridge_r);
        // latch leg (overlaps upper jaw)
        translate([leg_x0, leg_y0])
            square([leg_x1 - leg_x0, up_y0 - leg_y0 + 0.5]);
        // latch nose
        translate([nose_x0, leg_y0])
            square([leg_x0 - nose_x0 + 0.01, nose_y1 - leg_y0]);
    }
}

linear_extrude(height = thk) profile();