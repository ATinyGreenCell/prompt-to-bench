// Knob for hotplate stirrer replacement
// Dimensions in millimetres

// Overall knob dimensions
knob_diam = 30;
knob_h = 15;

// D-shaped bore dimensions
shaft_diam = 6.2;
shaft_flat_dist = 4.7; // Distance from flat to opposite side of circle
shaft_depth = 12;

// Grip grooves
groove_count = 18;
groove_diam = 2;

// Pointer groove
pointer_width = 1.5;
pointer_depth = 1;
pointer_len = 15; // Runs from centre to outer edge

// Derived dimensions
knob_r = knob_diam / 2;
shaft_r = shaft_diam / 2;
// Flat position relative to circle center
// Circle top is at y = shaft_r. Flat is 4.7 mm from top.
// y_flat = shaft_r - shaft_flat_dist
y_flat = shaft_r - shaft_flat_dist;

// Groove geometry
// Half-cylinder centered on outer surface means groove axis is at radius knob_r
// Groove extends 1 mm in and 1 mm out.

// Pointer geometry
// Centered on the flat line y = y_flat
// Runs from centre (x=0) to outer edge (x=knob_r)
// Box centered at x = pointer_len/2, y = y_flat, z = knob_h

$fn = 64;

module knob_body() {
    // Main cylinder body
    cylinder(h = knob_h, d = knob_diam, center = false);
}

module knob() {
    difference() {
        knob_body();

        // D-shaped blind bore
        // Cylinder of diameter 6.2, depth 12
        // Cut by a flat plane at y = y_flat
        // The flat is at y = y_flat. The cut removes material where y < y_flat.
        // We use a box to cut the cylinder.
        translate([0, y_flat, 0]) {
            // Cylinder for the bore
            cylinder(h = shaft_depth + 0.01, d = shaft_diam, center = false);
            // Box to cut the flat side
            // Width 10 covers the diameter. Height covers depth.
            // Centered at y_flat, so it cuts everything below y_flat.
            cube([10, 10, shaft_depth + 0.01], center = true);
        }

        // Grip grooves
        // 18 evenly spaced vertical grooves
        // Half-cylinder centered on outer surface
        for (i = [0:groove_count-1]) {
            rotate(i * (360 / groove_count)) {
                translate([knob_r, 0, 0]) {
                    cylinder(h = knob_h, d = groove_diam, center = true);
                }
            }
        }

        // Pointer groove
        // 1.5 mm wide, 1 mm deep, from centre to outer edge
        // Centered on the flat side y = y_flat
        translate([pointer_len / 2, y_flat, knob_h]) {
            cube([pointer_len, pointer_width, pointer_depth], center = false);
        }
    }
}

knob();