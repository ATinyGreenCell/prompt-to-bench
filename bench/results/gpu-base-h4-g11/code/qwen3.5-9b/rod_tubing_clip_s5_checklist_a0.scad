// Snap-on clip for lab stand rod and tubing.
// Printed flat: 10 mm tall extrusion of a 2-D profile in the XY plane.
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

module rod_ring() {
    // Create the ring with an opening on the -X side
    // We define the outer boundary and the inner boundary (hole + opening)
    
    // Outer boundary: Full circle
    path_outer = [
        [rod_od/2, 0],
        [rod_od/2, rod_od/2],
        [-rod_od/2, rod_od/2],
        [-rod_od/2, -rod_od/2],
        [rod_od/2, -rod_od/2]
    ];
    
    // Inner boundary: Hole on +X side + Opening on -X side
    // Hole: x > 0, radius = rod_id/2
    // Opening: x < 0, y between -rod_opening_y and rod_opening_y
    
    // Construct the inner path as a polygon
    // Start at top of hole, go around hole, then cut the opening
    
    // Top of hole to top of opening
    p1 = [rod_id/2, rod_id/2];
    p2 = [-rod_opening_y, rod_opening_y];
    
    // Top of opening to top of outer ring (left side)
    p3 = [-rod_od/2, rod_od/2];
    
    // Left side of outer ring
    p4 = [-rod_od/2, -rod_od/2];
    
    // Bottom of outer ring to bottom of opening
    p5 = [-rod_opening_y, -rod_opening_y];
    
    // Bottom of opening to bottom of hole
    p6 = [rod_id/2, -rod_id/2];
    
    // Close the loop back to start
    p7 = [rod_id/2, rod_id/2];
    
    inner_path = [p1, p2, p3, p4, p5, p6, p7];
    
    // Create the shape by extruding the area between outer and inner paths
    // Since we are using difference, we can just create the full outer ring
    // and subtract the inner void.
    
    // Full outer ring (solid)
    translate([0, 0, 0]) 
        difference() {
            // Outer solid
            union() {
                // Top face
                translate([0, 0, 0]) 
                    polygon(path_outer);
                // Bottom face
                translate([0, 0, -height]) 
                    polygon(path_outer);
                // Side walls (approximated by extruding the ring)
                // Actually, simpler to just extrude the 2D profile
            }
            
            // Subtract the inner void (hole + opening)
            translate([0, 0, 0]) 
                polygon(inner_path);
        }
    
    // Wait, the above logic is flawed for a simple polygon extrusion.
    // Let's use a simpler approach: Define the full outer ring, then subtract the inner hole and the opening.
    
    // Full outer ring (solid cylinder-like but flat)
    // We will build the 2D profile first, then extrude.
    
    // Profile: Outer circle minus Inner circle minus Opening rectangle
    // Since polygon doesn't support boolean ops directly, we build the profile as a union of shapes
    // and then subtract the voids.
    
    // Actually, the cleanest way in OpenSCAD for a ring with a cut is:
    // 1. Create the full outer ring (annulus).
    // 2. Subtract the inner hole.
    // 3. Subtract the opening rectangle.
    
    // Step 1: Full annulus
    // We can't easily make an annulus with a cut using just polygon without complex pathing.
    // Let's try the path approach again but correctly.
    
    // Path for the inner void:
    // Start at top of hole, go around hole, then cut the opening.
    // The opening is a rectangle from x = -rod_opening_y to x = 0 (approx) or just defined by y limits.
    // The problem says "everything with x < 0 and -5 < y < 5 is removed".
    // So the opening is a rectangle from x = -infinity to x = 0, y = -5 to 5.
    // But we only care about the part inside the ring.
    // So the opening is the rectangle: x from -rod_id/2 to 0, y from -5 to 5.
    
    // Let's redefine the inner path to include the rectangular cut.
    // The inner boundary of the ring is a circle of radius rod_id/2.
    // The opening is a rectangle attached to the left side of this circle.
    
    // Path points:
    // Start at top of hole (0, rod_id/2)
    // Go to top of opening (-rod_opening_y, rod_opening_y) -> wait, rod_opening_y is 5, rod_id/2 is 6.35.
    // So the opening is wider than the hole radius? No, rod_id is 12.7, so radius is 6.35.
    // Opening is 10 wide, so half-width is 5.
    // So the opening is inside the hole radius.
    
    // Correct path:
    // Start at (0, 6.35)
    // Go to (-5, 5)
    // Go to (-5, -5)
    // Go to (0, -6.35)
    // Close to (0, 6.35)
    
    // But this creates a shape that is the hole MINUS the opening.
    // We want the ring to have the opening.
    // So the void is the hole PLUS the opening.
    // The void is the union of the circle (radius 6.35) and the rectangle (x<0, |y|<5).
    // Since the rectangle is inside the circle, the void is just the circle.
    // Wait, the problem says "everything with x < 0 and -5 < y < 5 is removed from this ring".
    // This implies the material is removed from the ring itself, not just the hole.
    // So the ring has a gap.
    
    // The ring is defined by:
    // Outer: radius 9.35
    // Inner: radius 6.35
    // Cut: x < 0, |y| < 5
    
    // So the void is the union of:
    // 1. Circle radius 6.35
    // 2. Rectangle: x from -9.35 to 0, y from -5 to 5
    
    // Let's construct the polygon for the void.
    // Start at top of circle (0, 6.35)
    // Go to top of rectangle (-5, 5)
    // Go to bottom of rectangle (-5, -5)
    // Go to bottom of circle (0, -6.35)
    // Close to (0, 6.35)
    
    // This polygon represents the void.
    // We subtract this polygon from the full annulus.
    
    void_path = [
        [0, rod_id/2],
        [-rod_opening_y, rod_opening_y],
        [-rod_opening_y, -rod_opening_y],
        [0, -rod_id/2]
    ];
    
    // Full annulus
    // We can create the annulus by subtracting the inner circle from the outer circle.
    // But we need to do this in 2D first, then extrude.
    
    // Let's create the full outer circle and subtract the void.
    // The full outer circle