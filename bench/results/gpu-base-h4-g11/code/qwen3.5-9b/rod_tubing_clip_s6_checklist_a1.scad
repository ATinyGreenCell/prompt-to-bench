// Snap-on clip for lab stand rod and tubing.
// Printed flat: 10 mm tall extrusion of a 2-D profile in the XY plane.
// Orientation: Rests on XY plane at z=0, builds upward. Centred on origin.

// Dimensions
rod_id   = 12.7;   // Inner diameter of rod ring
rod_wall = 3;      // Wall thickness of rod ring
rod_od   = rod_id + 2 * rod_wall; // Outer diameter of rod ring (18.7)

tubing_id = 6;     // Inner diameter of tubing ring
tubing_wall = 2;   // Wall thickness of tubing ring
tubing_od = tubing_id + 2 * tubing_wall; // Outer diameter of tubing ring (10)

bridge_w = 6;      // Width of the solid bridge (Y dimension)
bridge_x_start = 8; // Start X of bridge (relative to rod ring center)
bridge_x_end = 12;  // End X of bridge (relative to rod ring center)

clip_height = 10;  // Extrusion height (Z)

$fn = 64;

// Offset to ensure all geometry is on the positive X side for rotate_extrude.
// The leftmost point of the rod ring is at x = -rod_od/2 + rod_wall = -9.35 + 3 = -6.35.
// We shift everything by +7 mm to ensure x > 0.
shift_x = 7; 

// Module to create a ring with a specific opening cutout
// cx, cy: Center of the ring (in local coordinates before shift)
// id, od: Inner and outer diameters
// cut_width: Width of the opening
// cut_side: 1 for +X side, -1 for -X side
module ring_with_cut(cx, cy, id, od, cut_width, cut_side) {
    // Create the full ring
    difference() {
        rotate_extrude() {
            translate([cx, cy]) circle(d = od / 2);
        }
        // Cutout: A rectangle extruded through the ring
        // The cutout is defined by x > cx + cut_side*(cut_width/2) or x < cx - cut_side*(cut_width/2)
        // We create a rectangle in the profile plane that spans the cut width
        translate([cx + cut_side * (cut_width / 2), cy, 0]) {
            cube([cut_width, od, clip_height + 1]);
        }
    }
}

// Main assembly
difference() {
    union() {
        // 1. Rod ring (centred at origin in local coords)
        // Opening on -X side: x < 0 and -5 < y < 5
        // Cut width = 10 mm
        ring_with_cut(0, 0, rod_id, rod_od, 10, -1);

        // 2. Tubing ring (centred at x=15, y=0 in local coords)
        // Opening on +X side: x > 15 and -2.25 < y < 2.25
        // Cut width = 4.5 mm
        ring_with_cut(15, 0, tubing_id, tubing_od, 4.5, 1);

        // 3. Solid bridge between x=8 and x=12, width 6 mm (Y)
        // This bridge connects the two rings but does not block the holes.
        // It is a simple rectangular block.
        translate([bridge_x_start, -bridge_w / 2, 0]) {
            cube([bridge_x_end - bridge_x_start, bridge_w, clip_height + 1]);
        }
    }
    
    // Apply the global shift to move the entire assembly to positive X
    translate([shift_x, 0, 0]) {
        // The union above is re-created here with the shift applied to the centers
        // Actually, it's cleaner to just translate the whole union.
        // However, since we are inside a difference() with a union(), 
        // we must translate the union itself.
        // Let's restructure slightly to translate the union.
    }
}

// Restructured to apply shift correctly to the whole assembly
difference() {
    translate([shift_x, 0, 0]) {
        union() {
            // 1. Rod ring (centred at origin in local coords)
            ring_with_cut(0, 0, rod_id, rod_od, 10, -1);

            // 2. Tubing ring (centred at x=15, y=0 in local coords)
            ring_with_cut(15, 0, tubing_id, tubing_od, 4.5, 1);

            // 3. Solid bridge between x=8 and x=12, width 6 mm (Y)
            translate([bridge_x_start, -bridge_w / 2, 0]) {
                cube([bridge_x_end - bridge_x_start, bridge_w, clip_height + 1]);
            }
        }
    }
}