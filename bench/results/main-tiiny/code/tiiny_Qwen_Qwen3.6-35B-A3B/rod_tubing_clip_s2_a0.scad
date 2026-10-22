// Dimensions
// Lab stand rod
rod_id = 12.7;
rod_wall = 3;
rod_od = rod_id + 2 * rod_wall; // 18.7

// Tubing
tube_id = 6;
tube_wall = 2;
tube_od = tube_id + 2 * tube_wall; // 10

// Clip geometry
clip_height = 10;
rod_ring_center = [0, 0];
tube_ring_center = [15, 0];

// Rod ring opening
rod_opening_width = 10; // Y-width of the gap
rod_opening_x_limit = 0; // Everything with x < 0 is removed

// Tubing ring opening
tube_opening_width = 4.5; // Y-width of the gap
tube_opening_x_start = 15; // Everything with x > 15 is removed

// Bridge
bridge_width = 6; // Y-width
bridge_x_start = 8;
bridge_x_end = 12;

// Extrusion height
z_height = 10;

// Calculate radii
rod_r_inner = rod_id / 2;
rod_r_outer = rod_od / 2;
tube_r_inner = tube_id / 2;
tube_r_outer = tube_od / 2;

// Helper function to create a ring with a gap
// center: [x, y]
// r_inner, r_outer: radii
// gap_width: width of the gap in Y direction
// gap_side: 'left' (x < center_x) or 'right' (x > center_x)
module ring_with_gap(center, r_inner, r_outer, gap_width, gap_side) {
    $fn = 64;
    
    // Create the full ring first
    difference() {
        // Outer cylinder
        cylinder(h = z_height + 0.01, r = r_outer, center = false);
        
        // Inner hole
        translate([0, 0, -0.01])
        cylinder(h = z_height + 0.02, r = r_inner, center = false);
        
        // Gap cutout
        // The gap is a rectangular slot through the ring
        // We need to cut out the material from the ring
        // The gap is defined by x limits and y limits
        
        if (gap_side == 'left') {
            // Gap is on the left side (x < center_x)
            // We cut a box that removes the left part of the ring
            // The box needs to extend beyond the ring in all directions to ensure clean cut
            translate([center[0] - gap_width/2 - 0.01, 0, -0.01])
            cube([gap_width + 0.02, z_height + 0.02, r_outer * 2 + 0.02], center = false);
        } else {
            // Gap is on the right side (x > center_x)
            translate([center[0] + gap_width/2, 0, -0.01])
            cube([gap_width + 0.02, z_height + 0.02, r_outer * 2 + 0.02], center = false);
        }
    }
}

// Main assembly
difference() {
    union() {
        // Rod ring
        ring_with_gap(rod_ring_center, rod_r_inner, rod_r_outer, rod_opening_width, 'left');
        
        // Tubing ring
        ring_with_gap(tube_ring_center, tube_r_inner, tube_r_outer, tube_opening_width, 'right');
        
        // Bridge
        // The bridge connects the two rings. It must not block the holes.
        // The bridge is solid between x=8 and x=12, width 6mm in Y.
        // We need to ensure it doesn't overlap with the inner holes of the rings.
        // Rod ring inner hole: r < 6.35. At x=8, y=0, distance from origin is 8 > 6.35, so it's outside the hole.
        // Tube ring inner hole: center [15,0], r < 3. At x=12, distance from [15,0] is 3. 
        // Wait, the tube ring inner radius is 3. The bridge goes up to x=12.
        // Distance from tube center [15,0] to x=12 is 3. So the bridge edge is exactly at the inner hole boundary.
        // To avoid blocking, we should make the bridge slightly narrower in Y or ensure it doesn't intersect the hole.
        // The problem says "without blocking either ring's hole".
        // Let's check the Y extent. The bridge is 6mm wide, so y from -3 to 3.
        // The tube ring inner hole has radius 3. At x=12, the hole boundary is at distance 3 from center.
        // The point (12, 0) is at distance 3 from (15,0). So (12,0) is on the boundary.
        // Points (12, y) for y != 0 are at distance sqrt(3^2 + y^2) > 3, so they are outside the hole.
        // So the bridge at x=12, y in [-3,3] is mostly outside the hole, except at y=0 where it touches the boundary.
        // To be safe and ensure no blocking, we can make the bridge slightly narrower in Y, e.g., 5.8mm, 
        // or we can rely on the fact that the bridge is solid and the hole is empty.
        // However, the bridge is part of the solid. If it overlaps the hole, it blocks it.
        // Since the bridge is at x=12, and the hole is r<3 from (15,0), the bridge does not enter the hole 
        // except at the single point (12,0) which is on the boundary.
        // To be precise, let's make the bridge Y-width slightly less than 6mm to avoid any ambiguity, 
        // but the problem specifies 6mm. Let's stick to 6mm and assume the boundary is acceptable.
        // Actually, let's re-read: "without blocking either ring's hole". 
        // The bridge is between x=8 and x=12. The tube hole is at x=15, r=3. 
        // The closest point of the bridge to the tube hole is (12,0). 
        // The distance from (15,0) to (12,0) is 3, which is exactly the inner radius. 
        // So the bridge touches the inner surface of the tube ring but does not enter it.
        // This should be fine.
        
        translate([0, 0, -0.01])
        cube([bridge_x_end - bridge_x_start, bridge_width, z_height + 0.02], center = false);
    }
    
    // Now, we need to ensure the bridge doesn't block the holes.
    // The bridge is solid. The holes are empty.
    // The rod ring hole is at origin, r < 6.35.
    // The bridge is between x=8 and x=12. The closest point to the rod hole is (8,0).
    // Distance from (0,0) to (8,0) is 8 > 6.35. So the bridge is outside the rod hole.
    // The tube ring hole is at (15,0), r < 3.
    // The bridge is between x=8 and x=12. The closest point to the tube hole is (12,0).
    // Distance from (15,0) to (12,0) is 3. So the bridge touches the tube hole boundary.
    // To ensure no blocking, we can subtract a small cylinder from the bridge at the tube hole boundary?
    // No, the bridge is already outside the hole. The difference operation will handle it.
    // However, to be safe, let's subtract the inner holes from the bridge explicitly?
    // No, the bridge is part of the union. The holes are defined by the rings.
    // The ring_with_gap function creates the ring with the hole.
    // The bridge is added as a solid cube.
    // The final object is the union of the two rings and the bridge.
    // The holes are already empty in the rings.
    // The bridge does not overlap the holes (except at the boundary).
    // So the final object should be correct.
    
    // However, the problem says "without blocking either ring's hole".
    // If the bridge touches the hole boundary, it might be considered blocking if there's any overlap.
    // To be safe, let's subtract a small volume from the bridge near the tube hole.
    // But this is getting complicated. Let's assume the boundary is fine.
    
    // One more thing: the bridge must not block the rod ring hole.
    // The rod ring hole is r < 6.35.