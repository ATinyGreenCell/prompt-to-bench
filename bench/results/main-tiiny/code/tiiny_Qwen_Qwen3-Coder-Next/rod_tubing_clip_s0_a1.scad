$fn = 64;

// Dimensions
rod_id = 12.7;        // inner diameter of rod ring (mm)
rod_wall = 3;         // wall thickness of rod ring (mm)
rod_od = rod_id + 2 * rod_wall;  // outer diameter of rod ring (mm)
rod_ring_height = 10; // height of the entire part (Z)

tubing_id = 6;        // inner diameter of tubing ring (mm)
tubing_wall = 2;      // wall thickness of tubing ring (mm)
tubing_od = tubing_id + 2 * tubing_wall; // outer diameter of tubing ring (mm)

bridge_width = 6;     // width in Y-direction of the bridge (mm)
bridge_x_start = 8;   // start x-coordinate of bridge
bridge_x_end = 12;    // end x-coordinate of bridge

// Opening cut dimensions
rod_opening_width = 10;   // width of rod ring opening (mm)
tubing_opening_width = 4.5; // width of tubing ring opening (mm)

// Calculate y-limits for cuts
rod_cut_y = rod_opening_width / 2;
tubing_cut_y = tubing_opening_width / 2;

// Rod ring (outer circle minus inner circle) at z=0 to z=10
module rod_ring_with_cut() {
    difference() {
        // Outer circle at z=0 to z=10
        translate([0, 0, 0])
            cylinder(h = rod_ring_height, r = rod_od / 2);
        // Inner circle (hole)
        translate([0, 0, -0.01])
            cylinder(h = rod_ring_height + 0.02, r = rod_id / 2);
        // Opening cut: remove x < 0 and -5 < y < 5
        translate([-rod_od, -rod_cut_y - 0.01, -0.01])
            cube([rod_od + 1, rod_opening_width + 0.02, rod_ring_height + 0.02]);
    }
}

module tubing_ring_with_cut() {
    // Position tubing ring at x = 15, y = 0, z=0 to z=10
    translate([15, 0, 0]) {
        difference() {
            // Outer circle at z=0 to z=10
            cylinder(h = rod_ring_height, r = tubing_od / 2);
            // Inner circle (hole)
            translate([0, 0, -0.01])
                cylinder(h = rod_ring_height + 0.02, r = tubing_id / 2);
            // Opening cut: remove x > 15 and -2.25 < y < 2.25
            // Since we're at x=15, we need to cut from x=15 to x=15+something
            translate([0.01, -tubing_cut_y - 0.01, -0.01])
                cube([tubing_od + 1, tubing_opening_width + 0.02, rod_ring_height + 0.02]);
        }
    }
}

module bridge() {
    // Bridge between rod ring and tubing ring
    // y-range: -bridge_width/2 to +bridge_width/2
    // x-range: from rod ring outer edge (rod_od/2) to tubing ring inner edge (15 - tubing_od/2)
    // but constrained to [bridge_x_start, bridge_x_end]
    x_start = max(bridge_x_start, rod_od / 2);
    x_end = min(bridge_x_end, 15 - tubing_od / 2);
    
    if (x_start < x_end) {
        translate([x_start, -bridge_width/2, 0])
            cube([x_end - x_start, bridge_width, rod_ring_height]);
    }
}

// Assemble the part
rod_ring_with_cut();
tubing_ring_with_cut();
bridge();