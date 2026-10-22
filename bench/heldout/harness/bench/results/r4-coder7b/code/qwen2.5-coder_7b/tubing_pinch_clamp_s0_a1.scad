// Dimensions in millimeters
$fn = 64;

tongue_width = 56;
tongue_height = 4;
tongue_thickness = 1;
bar_length = 60;
bar_height = 16;
bar_thickness = 1;
hinge_radius_small = 7.2;
hinge_radius_large = 8;
hinge_thickness = 0.8;
ridge_radius = 1.5;
latch_leg_width = 3;
latch_leg_length = 3;
latch_nose_width = 3;
latch_nose_height = 1;
latch_nose_offset = 2;

// Lower jaw
lower_jaw = cube([tongue_width, tongue_height, bar_thickness]);
tongue = translate([0, 0, -tongue_thickness]) cube([tongue_width, tongue_height, tongue_thickness]);
lower_ridge = translate([27.5, 4, -bar_thickness/2]) cylinder(r=ridge_radius, h=bar_thickness);

// Upper jaw
upper_jaw = translate([0, bar_height-bar_thickness, 0]) cube([bar_length, bar_height, bar_thickness]);
upper_ridge = translate([27.5, 12, -bar_thickness/2]) cylinder(r=ridge_radius, h=bar_thickness);

// Hinge
hinge_small = rotate_extrude() translate([-hinge_radius_small, 0, 0]) circle(r=hinge_radius_small);
hinge_large = rotate_extrude() translate([-hinge_radius_large, 0, 0]) circle(r=hinge_radius_large);
hinge = difference() {
    union() { hinge_small; translate([0, 0, -hinge_thickness/2]) cube([hinge_radius_large*2, hinge_thickness, hinge_thickness]); }
    translate([0, 8, 0]) cylinder(r=1.5, h=hinge_thickness);
};

// Latch
latch_leg = translate([bar_length-bar_thickness, bar_height-bar_thickness, -bar_thickness/2]) cube([latch_leg_width, latch_leg_length, bar_thickness]);
latch_nose = translate([bar_length-latch_nose_offset-bar_thickness, bar_height-bar_thickness, -bar_thickness/2+latch_nose_height]) cube([latch_nose_width, latch_nose_height, bar_thickness]);

// Final model
model = union() {
    lower_jaw;
    tongue;
    lower_ridge;
    upper_jaw;
    upper_ridge;
    hinge;
    translate([0, 16, -bar_thickness/2]) rotate_extrude() translate([-latch_leg_width/2, 0, 0]) circle(r=latch_leg_width/2);
    latch_leg;
    translate([bar_length-latch_nose_offset-bar_thickness, bar_height-bar_thickness, -bar_thickness/2+latch_nose_height]) cube([latch_nose_width, latch_nose_height, bar_thickness]);
};

// Extrude to 8 mm
final_model = linear_extrude(height=8) model;

// Center the model on the origin
translate([-tongue_width/2, -bar_height/2, 0]) final_model;