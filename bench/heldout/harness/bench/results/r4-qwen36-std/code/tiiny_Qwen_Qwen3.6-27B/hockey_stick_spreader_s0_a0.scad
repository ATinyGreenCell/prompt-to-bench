// L-shaped (hockey-stick) cell spreader for plating bacteria
// Dimensions measured in mm

// Handle dimensions
handle_length = 150;
handle_width = 6;
handle_thickness = 4;

// Foot dimensions
foot_length = 40;
foot_width = 5;
foot_thickness = 2.5;

// Boss dimensions
boss_diameter = 6;
boss_height = 4;

// Hanging hole
hole_diameter = 4;
hole_x = 143;

// Angle between handle (+X) and foot (120 deg CCW from +X)
foot_angle = 120;

// Resolution for curved shapes
$fn = 64;

// Main union of parts
union() {
    // Handle: lies along +X axis, centred in Y, z=0 to thickness
    translate([handle_length / 2, 0, 0])
        cube([handle_length, handle_width, handle_thickness], center = false);

    // Foot: rotated 120 degrees around Z, centred in its local Y, z=0 to foot_thickness
    rotate([0, 0, foot_angle])
        translate([foot_length / 2, 0, 0])
            cube([foot_length, foot_width, foot_thickness], center = false);

    // Boss at origin: cylinder centred at x=0, y=0, z=0 to boss_height
    translate([0, 0, 0])
        cylinder(h = boss_height, r = boss_diameter / 2, center = false);
}

// Hanging hole through handle at x=143, y=0
// Drill through the full height of the handle (and boss if it overlaps, but boss is at origin)
// The hole goes through z=0 to z=handle_thickness (and slightly more to ensure clean cut)
difference() {
    // This difference is applied to the whole model above, but we need to structure it properly.
    // Actually, in OpenSCAD, difference() applies to the first child and subtracts subsequent children.
    // So we must put the entire union inside a difference() with the hole.
}

// Correct structure: wrap everything in a difference()
// Re-writing the structure properly:

difference() {
    union() {
        // Handle
        translate([handle_length / 2, 0, 0])
            cube([handle_length, handle_width, handle_thickness], center = false);

        // Foot
        rotate([0, 0, foot_angle])
            translate([foot_length / 2, 0, 0])
                cube([foot_length, foot_width, foot_thickness], center = false);

        // Boss
        translate([0, 0, 0])
            cylinder(h = boss_height, r = boss_diameter / 2, center = false);
    }

    // Hanging hole: cylinder extending past the handle thickness
    translate([hole_x, 0, -0.5])
        cylinder(h = handle_thickness + 1, r = hole_diameter / 2, center = false);
}