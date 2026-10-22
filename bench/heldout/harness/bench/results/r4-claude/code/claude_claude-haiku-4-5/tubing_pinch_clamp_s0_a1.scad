$fn = 64;

// Dimensions (mm)
extrusion_height = 8;  // Z-direction extrusion height

// Lower jaw main bar
lower_jaw_x = 50;
lower_jaw_y = 4;

// Tongue (extension of lower jaw)
tongue_x_start = 50;
tongue_x_end = 56;
tongue_y_start = 2.5;
tongue_y_end = 4;

// Upper jaw bar
upper_jaw_x = 60;
upper_jaw_y_start = 12;
upper_jaw_y_end = 16;

// Living hinge (half-ring annulus on x < 0 side)
hinge_cx = 0;
hinge_cy = 8;
hinge_r_inner = 7.2;
hinge_r_outer = 8;

// Pinch ridges (half-round)
pinch_x = 27.5;
pinch_r = 1.5;
lower_pinch_y = 4;   // Top of lower jaw
upper_pinch_y = 12;  // Bottom of upper jaw

// Latch leg (hangs from upper jaw)
latch_leg_x_start = 57;
latch_leg_x_end = 60;
latch_leg_y_start = 4.5;
latch_leg_y_end = 12;

// Latch nose (0.5 mm above tongue)
latch_nose_x_start = 54.5;
latch_nose_x_end = 57;
latch_nose_y_start = 4.5;
latch_nose_y_end = 5.5;

// Centering offsets
center_x = -26;
center_y = -8;

// Half-ring annulus (left semicircle only)
module hinge_half_ring(cx, cy, r_inner, r_outer) {
    points = [
        for (i = 90; i <= 270; i += 5) [cx + r_outer * cos(i), cy + r_outer * sin(i)],
        for (i = 270; i >= 90; i -= 5) [cx + r_inner * cos(i), cy + r_inner * sin(i)]
    ];
    polygon(points);
}

// Upper semicircle (for lower jaw pinch ridge)
module semicircle_up(cx, cy, r) {
    points = [
        for (i = 0; i <= 180; i += 5) [cx + r * cos(i), cy + r * sin(i)]
    ];
    polygon(points);
}

// Lower semicircle (for upper jaw pinch ridge)
module semicircle_down(cx, cy, r) {
    points = [
        for (i = 0; i <= 180; i += 5) [cx + r * cos(i), cy - r * sin(i)]
    ];
    polygon(points);
}

// 2D profile definition
module profile_2d() {
    translate([center_x, center_y]) {
        union() {
            // Lower jaw main bar
            square([lower_jaw_x, lower_jaw_y]);
            
            // Tongue
            translate([tongue_x_start, tongue_y_start])
                square([tongue_x_end - tongue_x_start, tongue_y_end - tongue_y_start]);
            
            // Upper jaw bar
            translate([0, upper_jaw_y_start])
                square([upper_jaw_x, upper_jaw_y_end - upper_jaw_y_start]);
            
            // Living hinge
            hinge_half_ring(hinge_cx, hinge_cy, hinge_r_inner, hinge_r_outer);
            
            // Lower jaw pinch ridge
            semicircle_up(pinch_x, lower_pinch_y, pinch_r);
            
            // Upper jaw pinch ridge
            semicircle_down(pinch_x, upper_pinch_y, pinch_r);
            
            // Latch leg
            translate([latch_leg_x_start, latch_leg_y_start])
                square([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start]);
            
            // Latch nose
            translate([latch_nose_x_start, latch_nose_y_start])
                square([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start]);
        }
    }
}

// Extrude 2D profile to create 3D part
linear_extrude(height = extrusion_height)
    profile_2d();