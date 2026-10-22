$fn = 64;

// Dimensions
rod_id = 12.7;        // inner diameter of rod ring (mm)
rod_wall = 3;         // wall thickness of rod ring (mm)
rod_od = rod_id + 2 * rod_wall;  // outer diameter of rod ring (mm)
tubing_id = 6;        // inner diameter of tubing ring (mm)
tubing_wall = 2;      // wall thickness of tubing ring (mm)
tubing_od = tubing_id + 2 * tubing_wall;  // outer diameter of tubing ring (mm)
clip_height = 10;     // height of the entire clip (Z)

// Opening dimensions
rod_opening_half_width = 5;   // half of 10 mm opening (mm)
tubing_opening_half_width = 2.25; // half of 4.5 mm opening (mm)

// Calculate centers
rod_center_x = 0;
rod_center_y = 0;
tubing_center_x = 15;
tubing_center_y = 0;

// Bridge parameters
bridge_width = 6;     // width of bridge in Y-direction (mm)
bridge_x_start = 8;   // start x-coordinate of bridge
bridge_x_end = 12;    // end x-coordinate of bridge

// Rod ring with opening (starting at z=0)
module rod_ring_with_opening() {
    difference() {
        // Outer cylinder (from z=0 to z=clip_height)
        cylinder(h = clip_height, d = rod_od);
        // Inner cylinder (hole)
        translate([0, 0, -0.01])
            cylinder(h = clip_height + 0.02, d = rod_id);
        // Opening cut: remove x < 0 and -5 < y < 5
        translate([-100, -rod_opening_half_width - 0.01, -0.01])
            cube([100, 2 * rod_opening_half_width + 0.02, clip_height + 0.02]);
    }
}

// Tubing ring with opening (starting at z=0)
module tubing_ring_with_opening() {
    difference() {
        // Outer cylinder (from z=0 to z=clip_height)
        translate([tubing_center_x, tubing_center_y, 0])
            cylinder(h = clip_height, d = tubing_od);
        // Inner cylinder (hole)
        translate([tubing_center_x, tubing_center_y, -0.01])
            cylinder(h = clip_height + 0.02, d = tubing_id);
        // Opening cut: remove x > 15 and -2.25 < y < 2.25
        translate([15 + 0.01, -tubing_opening_half_width - 0.01, -0.01])
            cube([100, 2 * tubing_opening_half_width + 0.02, clip_height + 0.02]);
    }
}

// Bridge between rings (from z=0 to z=clip_height)
module bridge() {
    y_start = -bridge_width / 2;
    y_end = bridge_width / 2;
    
    translate([bridge_x_start, y_start, 0])
        cube([bridge_x_end - bridge_x_start, bridge_width, clip_height]);
}

// Assemble the clip
module clip() {
    union() {
        rod_ring_with_opening();
        tubing_ring_with_opening();
        bridge();
    }
}

clip();