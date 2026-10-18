// Snap-on clip for lab stand rod and tubing.
// Printed flat: 10 mm tall extrusion (Z) of a 2-D profile in the XY plane.
// Orientation: Rests on XY plane at z = 0, builds upward (+Z). Centred on origin.

$fn = 64;

// Dimensions
rod_id   = 12.7;   // Rod inner diameter
rod_wall = 3;      // Rod ring wall thickness
rod_od   = rod_id + 2 * rod_wall; // Rod outer diameter (18.7)

tube_id  = 6;      // Tubing inner diameter
tube_wall = 2;     // Tubing wall thickness
tube_od  = tube_id + 2 * tube_wall; // Tubing outer diameter (10)

tube_x   = 15;     // Tubing ring center X
bridge_w = 6;      // Bridge width in Y
bridge_x_start = 8; // Bridge start X
bridge_x_end   = 12; // Bridge end X
height    = 10;    // Extrusion height (Z)

// Helper to create a ring with a cutout on one side
// ring_id: inner diameter
// ring_od: outer diameter
// cut_width: width of the cutout (Y dimension)
// cut_side: -1 for left (-X), 1 for right (+X)
// cut_center_y: center of the cutout in Y
module ring_with_cut(ring_id, ring_od, cut_width, cut_side, cut_center_y) {
    difference() {
        // Solid ring
        difference() {
            cylinder(h = height, d = ring_od);
            translate([0, 0, -0.01]) cylinder(h = height + 0.02, d = ring_id);
        }
        
        // Cutout rectangle
        // Calculate X range for the cutout
        // If cut_side is -1, cut is on the left (x < ring_center).
        // If cut_side is 1, cut is on the right (x > ring_center).
        // The prompt implies the cut starts from the center line outwards.
        // For rod: "everything with x < 0 ... is removed". So cut is x < 0.
        // For tube: "x > 15 ... is removed". So cut is x > 15.
        
        cut_y_min = cut_center_y - cut_width / 2;
        cut_y_max = cut_center_y + cut_width / 2;
        
        // Determine X range
        if (cut_side == -1) {
            // Cut on left side (negative X relative to center)
            // Extends from center (0) to the left edge of the ring
            cut_x_max = 0;
            cut_x_min = -rod_od / 2 - 0.1; // Extend slightly past the edge
        } else {
            // Cut on right side (positive X relative to center)
            // Extends from center (0) to the right edge of the ring
            cut_x_min = 0;
            cut_x_max = rod_od / 2 + 0.1; // Extend slightly past the edge
        }
        
        translate([cut_x_min, cut_y_min, -0.01]) 
            cube([cut_x_max - cut_x_min + 0.02, cut_y_max - cut_y_min + 0.02, height + 0.02]);
    }
}

// Main assembly
difference() {
    union() {
        // 1. Rod Ring (Centered at 0,0)
        // Cut on -X side, 10mm wide (y=-5 to 5), centered at y=0
        ring_with_cut(rod_id, rod_od, 10, -1, 0);
        
        // 2. Tubing Ring (Centered at 15,0)
        // Cut on +X side, 4.5mm wide (y=-2.25 to 2.25), centered at y=0
        translate([tube_x, 0, 0]) {
            ring_with_cut(tube_id, tube_od, 4.5, 1, 0);
        }
        
        // 3. Solid Bridge
        // Joins the two rings without blocking either ring's hole.
        // x from 8 to 12, y from -3 to 3 (6 mm wide), z from 0 to 10.
        translate([bridge_x_start, -bridge_w / 2, 0]) 
            cube([bridge_x_end - bridge_x_start, bridge_w, height]);
    }
}