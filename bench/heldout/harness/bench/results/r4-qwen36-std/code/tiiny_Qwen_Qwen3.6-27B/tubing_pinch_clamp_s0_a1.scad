// Pinch Clamp for Silicone Tubing (up to 6.4 mm)
// Designed for FDM printing, flat orientation (extruded along Z)

// Global settings
$fn = 64; // High resolution for smooth curves
extrusion_height = 8; // Thickness of the clamp along Z

// Lower Jaw Dimensions
lower_jaw_x_start = 0;
lower_jaw_x_end = 50;
lower_jaw_y_start = 0;
lower_jaw_y_end = 4;

// Lower Jaw Tongue Dimensions
tongue_x_start = 50;
tongue_x_end = 56;
tongue_y_start = 2.5;
tongue_y_end = 4;

// Upper Jaw Dimensions
upper_jaw_x_start = 0;
upper_jaw_x_end = 60;
upper_jaw_y_start = 12;
upper_jaw_y_end = 16;

// Hinge Dimensions
hinge_center_x = 0;
hinge_center_y = 8;
hinge_inner_radius = 7.2;
hinge_outer_radius = 8;
hinge_thickness = hinge_outer_radius - hinge_inner_radius; // 0.8 mm

// Pinch Ridge Dimensions
ridge_radius = 1.5;
ridge_x_pos = 27.5;
lower_ridge_center_y = 4;
upper_ridge_center_y = 12;

// Latch Dimensions
latch_leg_x_start = 57;
latch_leg_x_end = 60;
latch_leg_y_start = 4.5;
latch_leg_y_end = 12;

latch_nose_x_start = 54.5;
latch_nose_x_end = 57;
latch_nose_y_start = 4.5;
latch_nose_y_end = 5.5;

// Extrude the profile along Z
linear_extrude(height = extrusion_height, convexity = 10) {
    // Lower Jaw
    translate([lower_jaw_x_start, lower_jaw_y_start])
        square([lower_jaw_x_end - lower_jaw_x_start, lower_jaw_y_end - lower_jaw_y_start]);

    // Lower Jaw Tongue
    translate([tongue_x_start, tongue_y_start])
        square([tongue_x_end - tongue_x_start, tongue_y_end - tongue_y_start]);

    // Upper Jaw
    translate([upper_jaw_x_start, upper_jaw_y_start])
        square([upper_jaw_x_end - upper_jaw_x_start, upper_jaw_y_end - upper_jaw_y_start]);

    // Hinge (Half-ring on x < 0 side)
    // We create a full annulus and then intersect with x < 0 half-plane
    intersection() {
        // The annulus
        difference() {
            translate([hinge_center_x, hinge_center_y])
                circle(r = hinge_outer_radius);
            translate([hinge_center_x, hinge_center_y])
                circle(r = hinge_inner_radius);
        }
        // Large square covering x < 0
        translate([-100, -100])
            square([100, 200]); // Covers x from -100 to 0, y from -100 to 100
    }

    // Pinch Ridges
    // Lower ridge: centered at (ridge_x_pos, lower_ridge_center_y)
    translate([ridge_x_pos, lower_ridge_center_y])
        circle(r = ridge_radius);

    // Upper ridge: centered at (ridge_x_pos, upper_ridge_center_y)
    translate([ridge_x_pos, upper_ridge_center_y])
        circle(r = ridge_radius);

    // Latch Leg
    translate([latch_leg_x_start, latch_leg_y_start])
        square([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start]);

    // Latch Nose
    translate([latch_nose_x_start, latch_nose_y_start])
        square([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start]);
}