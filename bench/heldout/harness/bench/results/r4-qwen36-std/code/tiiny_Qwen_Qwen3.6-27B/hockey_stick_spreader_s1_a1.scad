// L-shaped (hockey-stick) cell spreader for plating bacteria
// Dimensions measured with calipers

// Handle dimensions
handle_length = 150;
handle_width = 6;
handle_thickness = 4;

// Spreading foot dimensions
foot_length = 40;
foot_width = 5;
foot_thickness = 2.5;

// Boss dimensions
boss_diameter = 6;
boss_height = 4;

// Hanging hole dimensions
hole_diameter = 4;
hole_x = 143;
hole_y = 0;

// Angle of the foot relative to +X axis (120 degrees counter-clockwise)
foot_angle = 120;

// Quality of curved shapes
$fn = 64;

// The part rests on the XY plane at z = 0 and builds upward (+Z).
// The joint is at the origin (0,0,0).
// The handle extends from x=0 to x=150 along the +X axis.
// The foot extends from the origin at 120 degrees from +X.

difference() {
    union() {
        // Handle: bar from x=0 to x=150, y=-3 to 3, z=0 to 4
        // Centered in Y at 0, so y goes from -handle_width/2 to handle_width/2
        translate([0, -handle_width/2, 0])
            cube([handle_length, handle_width, handle_thickness], center = false);

        // Spreading foot: bar starting at origin, pointing 120 degrees from +X
        // Length 40, width 5, thickness 2.5
        // We model the foot as a cube aligned with X, then rotate it.
        // The cube is defined from x=0 to x=foot_length, y=-foot_width/2 to foot_width/2, z=0 to foot_thickness
        rotate([0, 0, foot_angle])
            translate([0, -foot_width/2, 0])
                cube([foot_length, foot_width, foot_thickness], center = false);

        // Boss: cylinder at origin, diameter 6, height 4
        // Centered at x=0, y=0, starting at z=0
        translate([0, 0, 0])
            cylinder(h = boss_height, r = boss_diameter/2, center = false);
    }

    // Hanging hole: 4mm diameter, through the handle at x=143, y=0
    // The hole goes through the z-direction.
    // Extend slightly past the handle thickness (4mm) to ensure clean cut.
    // The handle is at z=0 to z=4. We cut from z=-0.5 to z=4.5.
    translate([hole_x, hole_y, -0.5])
        cylinder(h = handle_thickness + 1, r = hole_diameter/2, center = false);
}