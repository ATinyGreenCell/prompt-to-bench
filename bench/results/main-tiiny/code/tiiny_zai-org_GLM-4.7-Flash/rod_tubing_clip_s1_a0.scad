$fn = 64;

// Dimensions
rod_od = 18.7;       // Outer diameter of the rod ring
rod_id = 12.7;       // Inner diameter of the rod ring
rod_wall = 3;        // Wall thickness of the rod ring
rod_gap_width = 10;  // Width of the opening on the -X side
rod_gap_y_limit = 5; // Y-limit of the opening on the -X side

tube_id = 6;         // Inner diameter of the tubing ring
tube_wall = 2;       // Wall thickness of the tubing ring
tube_gap_width = 4.5;// Width of the opening on the +X side
tube_gap_y_limit = 2.25; // Y-limit of the opening on the +X side

bridge_x_start = 8;  // X start of the bridge
bridge_x_end = 12;   // X end of the bridge
bridge_y_width = 6;  // Width of the bridge in Y

height = 10;         // Height of the extrusion

// Derived Dimensions
rod_gap_x_limit = rod_gap_width / 2;
tube_gap_x_limit = tube_gap_width / 2;
tube_x_center = 15;  // X position of the tubing ring

// --- Main Part ---
module clip_profile() {
    union() {
        // 1. Rod Ring (with opening on -X side)
        // We create a full ring and subtract the gap
        rod_ring = cylinder(d = rod_od, h = height, center = true);
        rod_gap = cube([rod_gap_width, rod_gap_y_limit * 2, height + 0.1], center = true);
        difference() {
            rod_ring;
            translate([-rod_gap_x_limit, 0, 0]) rod_gap;
        }

        // 2. Tubing Ring (with opening on +X side)
        // Positioned at x = 15
        tube_ring = cylinder(d = tube_id + (tube_wall * 2), h = height, center = true);
        tube_gap = cube([tube_gap_width, tube_gap_y_limit * 2, height + 0.1], center = true);
        translate([tube_x_center, 0, 0]) {
            difference() {
                tube_ring;
                translate([tube_gap_x_limit, 0, 0]) tube_gap;
            }
        }

        // 3. Solid Bridge
        // Joins the two rings from x=8 to x=12
        bridge = cube([bridge_x_end - bridge_x_start, bridge_y_width, height + 0.1], center = true);
        translate([(bridge_x_start + bridge_x_end) / 2, 0, 0]) bridge;
    }
}

// Render the part
clip_profile();