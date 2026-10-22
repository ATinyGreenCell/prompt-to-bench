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

// Main union of all parts
union() {
    // Handle: centered in Y, extending from x=0 to x=150
    // To center on origin in X and Y as per rules, we translate the handle
    // The handle goes from x=0 to x=150, so its center in X is at 75
    // We translate it so that the joint is at the origin
    translate([-handle_length/2, 0, 0])
        cube([handle_length, handle_width, handle_thickness], center = false);

    // Spreading foot: rotated 120 degrees from +X axis
    // The foot starts at the origin and extends outward
    // We model it as a cube and then rotate it
    rotate([0, 0, foot_angle])
        translate([0, -foot_width/2, 0])
            cube([foot_length, foot_width, foot_thickness], center = false);

    // Boss at the origin: cylinder centered at origin
    // The boss joins the handle and foot at the origin
    translate([0, 0, 0])
        cylinder(h = boss_height, r = boss_diameter/2, center = false);

    // Hanging hole through the handle
    // The hole is at x=143, y=0, going through the handle thickness
    // We subtract a cylinder that extends slightly past the handle
    difference() {
        // Empty placeholder - the difference will be applied to the whole union
        // Actually, we need to restructure to apply the hole subtraction
    }
}

// Corrected approach: use difference on the entire union
difference() {
    union() {
        // Handle
        translate([-handle_length/2, 0, 0])
            cube([handle_length, handle_width, handle_thickness], center = false);

        // Spreading foot
        rotate([0, 0, foot_angle])
            translate([0, -foot_width/2, 0])
                cube([foot_length, foot_width, foot_thickness], center = false);

        // Boss
        translate([0, 0, 0])
            cylinder(h = boss_height, r = boss_diameter/2, center = false);
    }

    // Hanging hole: cylinder extending through the handle
    // Position the hole at x=143, y=0
    // The hole goes through the z-direction (through the thickness)
    // Extend slightly past the handle thickness (4mm) to ensure clean cut
    translate([hole_x - handle_length/2, hole_y, -0.5])
        cylinder(h = handle_thickness + 1, r = hole_diameter/2, center = false);
}