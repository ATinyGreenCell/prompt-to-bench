// Dimensions
rod_inner_diameter = 12.7; // Inner diameter of the lab stand rod
rod_wall_thickness = 3;    // Wall thickness of the rod ring
rod_outer_diameter = rod_inner_diameter + 2 * rod_wall_thickness; // Outer diameter of the rod ring
rod_ring_height = 10;      // Height of the rod ring extrusion
tubing_inner_diameter = 6; // Inner diameter of the tubing
tubing_wall_thickness = 2; // Wall thickness of the tubing ring
tubing_outer_diameter = tubing_inner_diameter + 2 * tubing_wall_thickness; // Outer diameter of the tubing ring
tubing_ring_height = 10;   // Height of the tubing ring extrusion
bridge_width = 6;          // Width of the bridge connecting the two rings
bridge_height = 10;        // Height of the bridge
rod_ring_x_offset = 0;     // X offset of the rod ring center
rod_ring_y_offset = 0;     // Y offset of the rod ring center
tubing_ring_x_offset = 15; // X offset of the tubing ring center
tubing_ring_y_offset = 0;  // Y offset of the tubing ring center
rod_slot_width = 10;       // Width of the slot in the rod ring
rod_slot_height = 10;      // Height of the slot in the rod ring
rod_slot_y_offset = 5;     // Y offset of the slot in the rod ring
tubing_slot_width = 4.5;   // Width of the slot in the tubing ring
tubing_slot_height = 10;   // Height of the slot in the tubing ring
tubing_slot_y_offset = 2.25; // Y offset of the slot in the tubing ring

$fn = 64;

// Rod ring with slot
rod_ring = difference() {
    cylinder(h = rod_ring_height, r = rod_outer_diameter / 2, center = true);
    cylinder(h = rod_ring_height, r = rod_inner_diameter / 2, center = true);
    translate([rod_ring_x_offset - rod_slot_width / 2, 0, 0])
        cube(size = [rod_slot_width, 2 * rod_slot_y_offset, rod_slot_height + 1], center = true);
}

// Tubing ring with slot
tubing_ring = difference() {
    translate([tubing_ring_x_offset, tubing_ring_y_offset, 0])
        cylinder(h = tubing_ring_height, r = tubing_outer_diameter / 2, center = true);
    translate([tubing_ring_x_offset, tubing_ring_y_offset, 0])
        cylinder(h = tubing_ring_height, r = tubing_inner_diameter / 2, center = true);
    translate([tubing_ring_x_offset + tubing_slot_width / 2, 0, 0])
        cube(size = [tubing_slot_width, 2 * tubing_slot_y_offset, tubing_slot_height + 1], center = true);
}

// Bridge connecting the two rings
bridge = cube(size = [bridge_height, bridge_width, rod_ring_height + 1], center = true);

// Final assembly
union() {
    rod_ring;
    tubing_ring;
    translate([10, 0, 0]) bridge; // Center the bridge between the two rings
}