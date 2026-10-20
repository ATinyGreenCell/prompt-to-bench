// Snap-on clip for 12.7 mm lab stand rod and 6 mm ID tubing
// Printed flat (Z = 10 mm extrusion of XY profile)

// Global settings
$fn = 64;
height = 10; // Extrusion height in Z

// Rod ring dimensions
rod_id = 12.7; // Inner diameter of rod ring
rod_wall = 3; // Wall thickness of rod ring
rod_od = rod_id + 2 * rod_wall; // Outer diameter of rod ring (18.7 mm)

// Rod ring cutout dimensions
rod_cutout_width = 10; // Width of the opening on the -X side
rod_cutout_half_width = rod_cutout_width / 2; // Half-width for symmetric bounds

// Tubing ring dimensions
tubing_id = 6; // Inner diameter of tubing ring
tubing_wall = 2; // Wall thickness of tubing ring
tubing_od = tubing_id + 2 * tubing_wall; // Outer diameter of tubing ring (10 mm)
tubing_center_x = 15; // X-coordinate of tubing ring center

// Tubing ring cutout dimensions
tubing_cutout_width = 4.5; // Width of the opening on the +X side
tubing_cutout_half_width = tubing_cutout_width / 2; // Half-width for symmetric bounds

// Bridge dimensions
bridge_x_start = 8; // Start X of the bridge
bridge_x_end = 12; // End X of the bridge
bridge_width = 6; // Width of the bridge in Y
bridge_half_width = bridge_width / 2; // Half-width for symmetric bounds

// Safety margin for cuts (ensures no coplanar faces)
cut_margin = 0.5;

// Main module
linear_extrude(height = height, center = false, convexity = 10) {
    union() {
        // Rod ring centered at origin
        difference() {
            // Outer circle of rod ring
            circle(r = rod_od / 2);
            // Inner hole of rod ring
            circle(r = rod_id / 2);
            // Cutout on -X side: extends from x = -infinity to x = 0, y = -5 to 5
            // We use a large rectangle to ensure it cuts through the ring
            translate([-rod_od, 0])
                square([rod_od + cut_margin, rod_cutout_width + 2 * cut_margin], center = true);
        }

        // Tubing ring centered at (15, 0)
        difference() {
            // Outer circle of tubing ring
            translate([tubing_center_x, 0])
                circle(r = tubing_od / 2);
            // Inner hole of tubing ring
            translate([tubing_center_x, 0])
                circle(r = tubing_id / 2);
            // Cutout on +X side: extends from x = 15 to +infinity, y = -2.25 to 2.25
            translate([tubing_center_x + tubing_od, 0])
                square([tubing_od + cut_margin, tubing_cutout_width + 2 * cut_margin], center = true);
        }

        // Solid bridge between x = 8 and x = 12, width 6 mm in Y
        translate([bridge_x_start, 0])
            square([bridge_x_end - bridge_x_start, bridge_width], center = false);
    }
}