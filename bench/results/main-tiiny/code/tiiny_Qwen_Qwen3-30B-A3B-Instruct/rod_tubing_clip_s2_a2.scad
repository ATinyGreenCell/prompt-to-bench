$fn = 64;

// Dimensions
rod_diameter = 12.7;           // Inner diameter of rod ring
rod_wall = 3;                 // Wall thickness of rod ring
rod_outer_diameter = rod_diameter + 2 * rod_wall;  // 18.7 mm

tubing_inner_diameter = 6;  // Inner diameter of tubing ring
tubing_wall = 2;              // Wall thickness of tubing ring
tubing_outer_diameter = tubing_inner_diameter + 2 * tubing_wall;  // 10 mm

bridge_width_y = 6;           // Width of bridge in Y direction
bridge_start_x = 8;           // Start X of bridge
bridge_end_x = 12;            // End X of bridge

// Rod ring: centered at origin, with -X side opening
rod_ring_inner_radius = rod_diameter / 2;
rod_ring_outer_radius = rod_outer_diameter / 2;

// Tubing ring: centered at (15, 0), with +X side opening
tubing_ring_center_x = 15;
tubing_ring_center_y = 0;
tubing_ring_inner_radius = tubing_inner_diameter / 2;
tubing_ring_outer_radius = tubing_outer_diameter / 2;

// Opening dimensions
rod_opening_width = 10;     // Width of opening in rod ring (-X side)
rod_opening_half_y = rod_opening_width / 2;  // -5 to +5

tubing_opening_width = 4.5;    // Width of opening in tubing ring (+X side)
tubing_opening_half_y = tubing_opening_width / 2;  // -2.25 to +2.25

// Bridge: solid connection between rings, 6 mm wide in Y, from x=8 to x=12
bridge_y_min = -bridge_width_y / 2;
bridge_y_max = bridge_width_y / 2;

// Correct the orientation: the entire part must be printed flat on the bed at z = 0,
// with the bottom at z = 0 and height 10 mm (z = 0 to z = 10).
// The original model was centered at z = 0 (from -5 to +5), so we need to shift it up by 5 mm.
// However, the bridge and rings must be aligned properly in X and Y.

// Build the clip with correct vertical positioning: shift entire model up by 5 mm so that z = 0 is the bottom.
// The total height is 10 mm, so we want the bottom at z = 0 and top at z = 10.

module clip() {
    // Rod ring with -X side opening
    difference() {
        // Outer ring (full circle)
        cylinder(h = 10, r = rod_ring_outer_radius, center = true);
        // Inner hole (full circle)
        cylinder(h = 10, r = rod_ring_inner_radius, center = true);
        // Cut out the opening: a rectangle from x = -rod_ring_outer_radius to x = 0, y = -5 to 5
        // Use a slightly larger rectangle to ensure full removal (0.01 mm past face)
        translate([0, 0, -0.01])
        cube([rod_ring_outer_radius * 2 + 0.02, rod_opening_width + 0.02, 10.02], center = false);
    }

    // Tubing ring with +X side opening
    difference() {
        // Outer ring (full circle)
        cylinder(h = 10, r = tubing_ring_outer_radius, center = true);
        // Inner hole (full circle)
        cylinder(h = 10, r = tubing_ring_inner_radius, center = true);
        // Cut out the opening: a rectangle from x = 15 to x = 15 + tubing_ring_outer_radius, y = -2.25 to 2.25
        // Use a slightly larger rectangle to ensure full removal
        translate([tubing_ring_center_x, 0, -0.01])
        cube([tubing_ring_outer_radius * 2 + 0.02, tubing_opening_width + 0.02, 10.02], center = false);
    }

    // Bridge: solid rectangle connecting the two rings
    // From x = 8 to 12, y = -3 to 3 (6 mm wide), z = 0 to 10
    // Must be placed at z = 0 to 10, so we center it at z = 5
    translate([bridge_start_x + (bridge_end_x - bridge_start_x)/2, 0, 5])
    cube([bridge_end_x - bridge_start_x, bridge_width_y, 10], center = false);
}

// The entire model is currently centered at z = 0 (from -5 to +5), so we need to shift it up by 5 mm
// to place the bottom at z = 0.
// Apply the vertical shift only once, to the entire clip.
translate([0, 0, 5])
clip();