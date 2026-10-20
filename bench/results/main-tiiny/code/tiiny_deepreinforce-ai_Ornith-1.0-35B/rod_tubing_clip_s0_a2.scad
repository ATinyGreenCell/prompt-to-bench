// --- Dimensions ---
// Rod ring inner diameter
rod_id = 12.7;
// Rod ring wall thickness
rod_wall = 3;
// Rod ring outer diameter
rod_od = rod_id + 2 * rod_wall; // 18.7

// Rod ring opening width (Y direction)
rod_opening_y = 10;
// Rod ring opening extent in X (from -X side)
rod_opening_x = 5; // Remove everything with x < 0 and -5 < y < 5

// Tubing ring inner diameter
tube_id = 6;
// Tubing ring wall thickness
tube_wall = 2;
// Tubing ring outer diameter
tube_od = tube_id + 2 * tube_wall; // 10

// Tubing ring center position
tube_cx = 15;
tube_cy = 0;

// Tubing ring opening width (Y direction)
tube_opening_y = 4.5;
// Tubing ring opening extent in X (from +X side)
tube_opening_x = 2.25; // Remove everything with x > 15 and -2.25 < y < 2.25

// Bridge width (Y direction)
bridge_y = 6;
// Bridge X extent
bridge_x_start = 8;
bridge_x_end = 12;

// Extrusion height (Z)
height = 10;

// --- Model ---
$fn = 64;

module rod_ring() {
    difference() {
        // Outer cylinder
        cylinder(h = height, d = rod_od, center = false);
        // Inner cylinder (hole)
        cylinder(h = height + 0.1, d = rod_id, center = false);
        // Opening cutout: remove x < 0, -5 < y < 5
        translate([-rod_od/2 - 0.1, 0, 0])
            cube([rod_od/2 + 0.1, rod_opening_y + 0.1, height + 0.1], center = false);
    }
}

module tubing_ring() {
    difference() {
        // Outer cylinder
        translate([tube_cx, tube_cy, 0])
            cylinder(h = height, d = tube_od, center = false);
        // Inner cylinder (hole)
        translate([tube_cx, tube_cy, 0])
            cylinder(h = height + 0.1, d = tube_id, center = false);
        // Opening cutout: remove x > 15, -2.25 < y < 2.25
        translate([tube_cx - tube_od/2 - 0.1, 0, 0])
            cube([tube_od/2 + 0.1, tube_opening_y + 0.1, height + 0.1], center = false);
    }
}

module bridge() {
    translate([bridge_x_start, 0, 0])
        cube([bridge_x_end - bridge_x_start, bridge_y, height], center = false);
}

// Combine all parts
union() {
    rod_ring();
    tubing_ring();
    bridge();
}