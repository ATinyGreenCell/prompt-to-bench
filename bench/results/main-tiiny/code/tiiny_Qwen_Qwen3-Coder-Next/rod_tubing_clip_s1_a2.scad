$fn = 64;

// Dimensions
rod_id = 12.7;        // inner diameter of rod ring (mm)
rod_wall = 3;         // wall thickness of rod ring (mm)
rod_od = rod_id + 2 * rod_wall;  // outer diameter of rod ring (mm)
rod_opening_width = 10;  // width of opening cut from -X side (mm)

tubing_id = 6;        // inner diameter of tubing ring (mm)
tubing_wall = 2;      // wall thickness of tubing ring (mm)
tubing_od = tubing_id + 2 * tubing_wall;  // outer diameter of tubing ring (mm)
tubing_opening_width = 4.5;  // width of opening cut from +X side (mm)

bridge_x_start = 8;   // start x-coordinate of bridge (mm)
bridge_x_end = 12;    // end x-coordinate of bridge (mm)
bridge_width = 6;     // width of bridge in Y-direction (mm)

height = 10;

// Rod ring with opening - centered at origin, bottom at z=0
module rod_ring_with_opening() {
    difference() {
        // Outer circle (bottom at z=0)
        cylinder(h = height, r = rod_od / 2);
        // Inner circle (hole)
        cylinder(h = height + 0.02, r = rod_id / 2);
        // Opening cut: remove x < 0 and -5 < y < 5 from the ring only
        // Use intersection with ring region to avoid cutting too much
        intersection() {
            translate([-rod_od - 1, -rod_opening_width/2, -0.01])
                cube([rod_od + 2, rod_opening_width, height + 0.02]);
            // Ring region: outside inner circle, inside outer circle
            difference() {
                cylinder(h = height + 0.02, r = rod_od / 2);
                cylinder(h = height + 0.02, r = rod_id / 2);
            }
        }
    }
}

// Tubing ring with opening - centered at (15, 0), bottom at z=0
module tubing_ring_with_opening() {
    translate([15, 0, 0]) {
        difference() {
            // Outer circle (bottom at z=0)
            cylinder(h = height, r = tubing_od / 2);
            // Inner circle (hole)
            cylinder(h = height + 0.02, r = tubing_id / 2);
            // Opening cut: remove x > 15 and -2.25 < y < 2.25 from the ring only
            intersection() {
                translate([tubing_od + 1, -tubing_opening_width/2, -0.01])
                    cube([tubing_od + 2, tubing_opening_width, height + 0.02]);
                // Ring region: outside inner circle, inside outer circle
                difference() {
                    cylinder(h = height + 0.02, r = tubing_od / 2);
                    cylinder(h = height + 0.02, r = tubing_id / 2);
                }
            }
        }
    }
}

// Solid bridge between rings - bottom at z=0
module bridge() {
    // Bridge is 6 mm wide in Y (from -3 to +3), from x=8 to x=12
    // Position it so it connects the rings without blocking holes
    translate([bridge_x_start, -bridge_width / 2, 0])
        cube([bridge_x_end - bridge_x_start, bridge_width, height]);
}

// Assemble the clip
rod_ring_with_opening();
tubing_ring_with_opening();
bridge();