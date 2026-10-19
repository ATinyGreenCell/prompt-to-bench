// Snap-on clip for 12.7mm rod and 6mm tubing
// Corrected: Subtraction is performed on the final union to ensure holes are actually cut.

// --- Dimensions ---
rod_id      = 12.7;    // Inner diameter of the rod ring
rod_wall    = 3.0;     // Wall thickness of the rod ring
rod_od      = rod_id + 2 * rod_wall; // 18.7 mm

rod_gap_w   = 10.0;    // Width of the opening in the rod ring
rod_gap_h   = 10.0;    // Height of the opening in the rod ring

tube_id     = 6.0;     // Inner diameter of the tubing ring
tube_wall   = 2.0;     // Wall thickness of the tubing ring
tube_od     = tube_id + 2 * tube_wall; // 10.0 mm

tube_gap_w  = 4.5;     // Width of the opening in the tubing ring
tube_gap_h  = 4.5;     // Height of the tubing ring opening

bridge_w_y  = 6.0;     // Width of the bridge along the Y axis
bridge_x_min = 8.0;    // Start of the bridge on X axis
bridge_x_max = 12.0;   // End of the bridge on X axis

clip_height = 10.0;    // Extrusion height (Z)
tube_offset_x = 15.0;  // X-coordinate of the tubing ring center

$fn = 64;

// --- 2D Profiles (Solid only) ---

module rod_ring_solid() {
    difference() {
        circle(d = rod_od);
        circle(d = rod_id);
    }
}

module tube_ring_solid() {
    difference() {
        circle(d = tube_od);
        circle(d = tube_id);
    }
}

module bridge_solid() {
    translate([bridge_x_min, -bridge_w_y/2])
        square([bridge_x_max - bridge_x_min, bridge_w_y]);
}

// --- Final Assembly ---

// We build the solid body first, then subtract the gaps.
difference() {
    // The solid body
    linear_extrude(height = clip_height) {
        union() {
            rod_ring_solid();
            translate([tube_offset_x, 0]) tube_ring_solid();
            bridge_solid();
        }
    }

    // 1. Rod ring cutout: x < 0 and -5 < y < 5
    // We use a large rectangle to ensure it cuts through the edge.
    // The spec says "everything with x < 0 and -5 < y < 5 is removed".
    translate([-rod_od - 1, -5]) 
        linear_extrude(height = clip_height + 2) 
            square([rod_od, 10]);

    // 2. Tubing ring cutout: x > 15 and -2.25 < y < 2.25
    // The spec says "x > 15 and -2.25 < y < 2.25 is removed".
    translate([tube_offset_x, -2.25]) 
        linear_extrude(height = clip_height + 2) 
            square([tube_od, 4.5]);
}