// Snap-on clip for lab stand rod and tubing.
// Printed flat: 10 mm tall extrusion (Z) of a 2-D profile in the XY plane.
// Orientation: Rests on XY plane at z=0, builds upward. Centred on origin.

// Rod dimensions
rod_id = 12.7;   // Inner diameter of rod ring
rod_wall = 3;    // Wall thickness of rod ring
rod_od = rod_id + 2 * rod_wall; // Outer diameter of rod ring (18.7 mm)

// Tubing dimensions
tube_id = 6;     // Inner diameter of tubing ring
tube_wall = 2;   // Wall thickness of tubing ring
tube_od = tube_id + 2 * tube_wall; // Outer diameter of tubing ring (10 mm)

// Geometry parameters
height = 10;     // Extrusion height (Z)
bridge_x_start = 8;
bridge_x_end = 12;
bridge_y = 6;    // Width of bridge in Y

// Rod ring opening
rod_opening_width = 10;
rod_opening_y = 5; // Half width of opening in Y (-5 to 5)

// Tubing ring opening
tube_opening_width = 4.5;
tube_opening_y = tube_opening_width / 2; // 2.25

// Difference offset to ensure clean cuts
diff_offset = 0.1;

$fn = 64;

// Module to create the rod ring with opening
module rod_ring() {
    // Outer boundary: Full circle
    outer_path = [
        [rod_od/2, 0],
        [rod_od/2, rod_od/2],
        [-rod_od/2, rod_od/2],
        [-rod_od/2, -rod_od/2],
        [rod_od/2, -rod_od/2]
    ];
    
    // Inner void: Union of inner circle and rectangular opening on -X side
    // The opening is defined as x < 0 and |y| < rod_opening_y
    // We construct the polygon for the void by combining the circle and the rectangle.
    // Start at top of circle, go to top of opening, down opening, to bottom of circle.
    void_path = [
        [0, rod_id/2],
        [-rod_opening_y, rod_opening_y],
        [-rod_opening_y, -rod_opening_y],
        [0, -rod_id/2]
    ];
    
    // Create the ring by extruding the area between outer and inner paths
    // We use difference: Start with full outer ring, subtract the void.
    // Since we are in a module, we need to be careful with the context.
    // We will create the solid outer ring and subtract the void polygon.
    
    // Full outer ring (annulus)
    // We can create this by subtracting the inner circle from the outer circle in 2D,
    // but since we need to subtract the void (which includes the opening),
    // it's easier to define the void as a single polygon and subtract it from the full annulus.
    
    // Let's build the full annulus first.
    // Annulus = Outer Circle - Inner Circle
    // Then Annulus_with_cut = Annulus - Void_Polygon
    
    // Actually, the void polygon defined above is the union of the inner circle and the rectangular cut.
    // So if we subtract this void_path from the full outer circle, we get the ring with the cut.
    // But the void_path only covers the left side. The right side of the inner circle is still there.
    // Wait, the void_path I defined:
    // [0, 6.35] -> [-5, 5] -> [-5, -5] -> [0, -6.35] -> close.
    // This polygon is the union of the circle (radius 6.35) and the rectangle (x<0, |y|<5)?
    // No, a polygon is a single closed loop.
    // The loop [0, 6.35] -> [-5, 5] -> [-5, -5] -> [0, -6.35] -> [0, 6.35]
    // describes a shape that is the circle MINUS the rectangle? Or the rectangle MINUS the circle?
    // Let's visualize:
    // (0, 6.35) is top of circle.
    // (-5, 5) is top-left of opening.
    // (-5, -5) is bottom-left of opening.
    // (0, -6.35) is bottom of circle.
    // The path goes from top of circle, left to top of opening, down to bottom of opening, right to bottom of circle.
    // This encloses the region to the LEFT of this path.
    // The region to the left includes the rectangle and the part of the circle to the left of the rectangle?
    // No, the circle bulges out to x = -6.35. The rectangle stops at x = -5.
    // So the region enclosed by this path includes the rectangle AND the crescent of the circle to the left of x=-5.
    // It does NOT include the part of the circle to the right of x=0.
    // So this polygon represents: (Circle) UNION (Rectangle)? No.
    // It represents the area bounded by the path.
    // The path goes clockwise?
    // (0, 6.35) -> (-5, 5) -> (-5, -5) -> (0, -6.35) -> (0, 6.35).
    // This is a counter-clockwise loop if we consider the interior to be on the left.
    // The interior is the region containing (-1, 0).
    // This region is the union of the rectangle and the left part of the circle.
    // But we want to remove the INNER CIRCLE entirely, plus the rectangular cut.
    // The inner circle is x^2 + y^2 < 6.35^2.
    // The rectangular cut is x < 0, |y| < 5.
    // The union of these two is the void.
    // The polygon I defined does NOT cover the right part of the inner circle (x > 0).
    // So I need to add the right part of the inner circle to the void.
    // The void is the full inner circle PLUS the rectangular cut.
    // Since the rectangular cut is inside the circle (mostly), the union is just the circle?
    // No, the rectangular cut extends to x = -5. The circle extends to x = -6.35.
    // The rectangle is INSIDE the circle.
    // So the union of the circle and the rectangle is just the circle.
    // But the problem says "everything with x < 0 and -5 < y < 5 is removed from this ring".
    // This implies the material of the ring (between rod_id and rod_od) is removed in that region.
    // So the void is the UNION of:
    // 1. The inner circle (radius rod_id/2).
    // 2. The rectangular region (x < 0, |y| < rod_opening_y).
    // Since the rectangle is inside the circle, the union is just the circle.
    // This would mean no cut in the ring wall.
    // Re-reading: "with a 10 mm wide opening cut out of its -X side (everything with x < 0 and -5 < y < 5 is removed from this ring)"
    // "Removed from this ring" means the material of the ring is removed.
    // The ring material is where rod_id/2 < r < rod_od/2.
    // So we remove the intersection of (Ring Material) AND (x < 0, |y| < 5).
    // This creates a gap in the ring wall.
    // So the void to subtract is:
    // (Inner Circle) UNION (Rectangle x<0, |y|<5).
    // Since the rectangle is inside the inner circle, the union is just the inner circle.
    // This implies the cut is inside the hole, not in the ring wall.
    // But the user says "cut out of its -X side". Usually this means a gap in the ring.
    // If the rectangle is inside the hole, there is no gap in the ring wall.
    // Unless the "ring" refers to the whole shape including the hole?
    // Let's assume the user wants a gap in the ring wall.
    // For a gap in the wall, the rectangle must extend OUTSIDE the inner circle.
    // But the rectangle is defined by |y| < 5. The inner circle radius is 6.35.
    // So at y=0, the circle goes to x=-6.35. The rectangle goes to x=0 (if we define it as x<0).
    // Wait, "everything with x < 0 and -5 < y < 5 is