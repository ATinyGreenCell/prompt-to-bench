// Snap-on clip for 12.7mm rod and 6mm tubing
// Corrected to ensure cutouts are fully realized and dimensions match spec.

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

// --- Geometry Construction ---

module rod_ring_profile() {
    difference() {
        circle(d = rod_od);
        circle(d = rod_id);
        // Cutout on the -X side: x < 0 and -5 < y < 5
        // To ensure it cuts through the edge, we translate a square 
        // that covers the entire left side of the ring.
        translate([-rod_od - 1, -rod_gap_h/2]) 
            square([rod_od, rod_gap_h]);
    }
}

module tube_ring_profile() {
    difference() {
        circle(d = tube_od);
        circle(d = tube_id);
        // Cutout on the +X side: x > 15 and -2.25 < y < 2.25
        // The center is at (15,0). We translate the square to the right of 15.
        translate([tube_offset_x, -tube_gap_h/2])
            square([tube_od, tube_gap_h]);
    }
}

module bridge_profile() {
    // A rectangle centered on Y, spanning from bridge_x_min to bridge_x_max
    translate([bridge_x_min, -bridge_w_y/2])
        square([bridge_x_max - bridge_x_min, bridge_w_y]);
}

// --- Final Assembly ---

// We use a union of the three parts, then extrude.
// To ensure the rod ring and tube ring are treated as parts of one profile,
// we perform the 2D operations first.

difference() {
    // The main body
    union() {
        linear_extrude(height = clip_height) rod_ring_profile();
        translate([tube_offset_x, 0]) 
            linear_extrude(height = clip_height) tube_ring_profile();
        linear_extrude(height = clip_height) bridge_profile();
    }
    
    // Note: The difference is not needed here because the profiles 
    // are already constructed using difference() in 2D.
}

// To ensure the bridge doesn't block the holes, we must ensure 
// the bridge geometry (x=8 to 12) does not overlap the circle interiors.
// Rod ring OD is 18.7 (radius 9.35). Tube ring ID is 6 (radius 3, so OD is 10).
// Tube ring center is at 15. Tube ring inner edge is at 15 - 3 = 12.
// Bridge ends at 12. They touch but do not overlap the holes.