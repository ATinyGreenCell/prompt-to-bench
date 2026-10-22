// Snap-on clip for 12.7 mm lab stand rod and 6 mm ID tubing
// Printed flat (10 mm tall extrusion in Z)

// Dimensions
rod_id = 12.7;          // Inner diameter of rod ring
rod_wall = 3;           // Wall thickness of rod ring
rod_od = rod_id + 2 * rod_wall; // Outer diameter of rod ring (18.7 mm)

tube_id = 6;            // Inner diameter of tubing ring
tube_wall = 2;          // Wall thickness of tubing ring
tube_od = tube_id + 2 * tube_wall; // Outer diameter of tubing ring (10 mm)

tube_center_x = 15;     // X position of tubing ring center

bridge_x_start = 8;     // Start of bridge (X)
bridge_x_end = 12;      // End of bridge (X)
bridge_width = 6;       // Width of bridge (Y)

rod_slot_width = 10;    // Width of opening in rod ring (Y)
rod_slot_half = rod_slot_width / 2;

tube_slot_width = 4.5;  // Width of opening in tubing ring (Y)
tube_slot_half = tube_slot_width / 2;

extrusion_height = 10;  // Height of the part in Z

$fn = 64;

linear_extrude(height = extrusion_height, center = false, convexity = 10) {
    union() {
        // Rod ring (centered at origin)
        difference() {
            circle(r = rod_od / 2);
            circle(r = rod_id / 2);
            // Cut out the -X side opening: x < 0 and -rod_slot_half < y < rod_slot_half
            // We use a large rectangle extending to -infinity in X, bounded in Y
            translate([-rod_od, -rod_slot_half])
                square([rod_od * 2, rod_slot_width]);
        }

        // Tubing ring (centered at x = 15, y = 0)
        difference() {
            translate([tube_center_x, 0])
                circle(r = tube_od / 2);
            translate([tube_center_x, 0])
                circle(r = tube_id / 2);
            // Cut out the +X side opening: x > 15 and -tube_slot_half < y < tube_slot_half
            // Rectangle starting at x = 15, extending to +infinity
            translate([tube_center_x, -tube_slot_half])
                square([tube_od * 2, tube_slot_width]);
        }

        // Solid bridge between x = 8 and x = 12, width 6 mm in Y
        translate([bridge_x_start, -bridge_width / 2])
            square([bridge_x_end - bridge_x_start, bridge_width]);
    }
}