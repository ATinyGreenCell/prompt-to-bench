// Replacement knob for hotplate stirrer - D-shaft fit, grip grooves, and pointer.

// Dimensions
shaft_d  = 6.0;      // Shaft diameter (for reference)
knob_d   = 30.0;     // Knob outer diameter
knob_h   = 15.0;     // Knob height
bore_h   = 12.0;     // Bore depth
bore_d   = 6.2;      // Bore circle diameter
bore_flat = 4.7;     // Distance from flat to opposite side of bore circle
grooves_n = 18;      // Number of grip grooves
groove_d = 2.0;      // Groove diameter
pointer_w = 1.5;     // Pointer groove width
pointer_d = 1.0;     // Pointer groove depth

$fn = 128;

// Calculate bore geometry
bore_r = bore_d / 2;
bore_flat_offset = bore_r - bore_flat; // Distance from circle center to flat cut

// Create the main knob body
difference() {
    // Main cylinder
    cylinder(h = knob_h, d = knob_d);

    // D-shaped bore
    // We create the D-shape by taking a full cylinder and subtracting the flat part.
    // The flat part is a cylinder of diameter (bore_d - bore_flat) centered on the axis?
    // No, the flat is a plane. The material removed is the part of the circle where x < -bore_flat_offset.
    // This is equivalent to subtracting a cylinder of diameter (bore_d - bore_flat) that is offset?
    // Actually, the simplest way to make a D-hole is to subtract a cylinder of diameter (bore_d - bore_flat)
    // from a cylinder of diameter bore_d, but shifted so the flat face is created.
    // The flat face is at x = -bore_flat_offset.
    // The circle extends to x = -bore_r.
    // The width of the flat part is bore_r - bore_flat_offset = bore_flat.
    // Wait, the distance from flat to opposite side is bore_flat.
    // So the flat is at x = -bore_flat_offset. The opposite side is at x = +bore_r.
    // Distance = bore_r - (-bore_flat_offset) = bore_r + bore_flat_offset = bore_flat.
    // So bore_flat_offset = bore_flat - bore_r.
    // Let's re-calculate:
    // Distance from flat (x_flat) to opposite side (x_max = bore_r) is bore_flat.
    // x_max - x_flat = bore_flat => bore_r - x_flat = bore_flat => x_flat = bore_r - bore_flat.
    // Since the flat is on the left, x_flat should be negative.
    // bore_r = 3.1. bore_flat = 4.7.
    // x_flat = 3.1 - 4.7 = -1.6.
    // So the flat is at x = -1.6.
    // The circle goes from x = -3.1 to x = 3.1.
    // The flat part is the region x < -1.6.
    // To cut this out, we subtract a cylinder of diameter 2 * (bore_r - x_flat) = 2 * (3.1 - (-1.6)) = 2 * 4.7 = 9.4?
    // No, the flat part is the intersection of the circle and x < x_flat.
    // This shape is not a simple cylinder.
    // However, we can approximate it by subtracting a cylinder of diameter (bore_d - bore_flat) centered at x = x_flat?
    // No, let's use the polygon method for the cross section.
    // We need to generate points for the circle arc on the right side and the flat line.
    
    // Let's define the D-shape polygon vertices.
    // We want the shape to be the circle MINUS the left part (x < x_flat).
    // Vertices (clockwise):
    // 1. Start at bottom of flat: (x_flat, -bore_r)
    // 2. Go along flat to top: (x_flat, bore_r)
    // 3. Go along circle arc from top to bottom on the right side.
    //    Angles from 90 to -90 (or 270).
    //    Points: (bore_r * cos(a), bore_r * sin(a)) for a from 90 to -90.
    
    // Generate points for the circle arc
    // We need points from 90 degrees to -90 degrees (clockwise).
    // Let's generate 64 points for the arc.
    arc_points = [for (i = [0 : 63]) let(a = 90 - i * 360 / 64) [bore_r * cos(a), bore_r * sin(a)]];
    
    // Add the flat line points
    // The flat line goes from (x_flat, -bore_r) to (x_flat, bore_r).
    // We need to connect the last arc point to the first flat point and vice versa.
    // The arc starts at 90 deg: (0, bore_r).
    // The arc ends at -90 deg: (0, -bore_r).
    // The flat line goes from (0, -bore_r) to (x_flat, -bore_r)? No.
    // The flat line is at x = x_flat.
    // The circle at x = x_flat has y = +/- sqrt(bore_r^2 - x_flat^2).
    // But we want the flat to be the straight line connecting the two ends of the cut.
    // The cut is defined by x < x_flat.
    // So the boundary is the line segment from (x_flat, -bore_r) to (x_flat, bore_r)?
    // No, the circle intersects x = x_flat at y = +/- sqrt(bore_r^2 - x_flat^2).
    // Let's calculate the intersection y.
    y_intersect = sqrt(bore_r * bore_r - x_flat * x_flat);
    
    // The vertices for the D-shape (clockwise):
    // 1. (x_flat, -y_intersect)
    // 2. (x_flat, y_intersect)
    // 3. Arc from (0, y_intersect) to (0, -y_intersect) on the right side?
    // No, the arc should be the full circle minus the flat part.
    // The flat part is the chord from (x_flat, -y_intersect) to (x_flat, y_intersect).
    // The shape is the circle MINUS the segment defined by the chord.
    // So the boundary is:
    // 1. Line from (x_flat, -y_intersect) to (x_flat, y_intersect).
    // 2. Arc from (x_flat, y_intersect) to (x_flat, -y_intersect) going through the right side (positive X).
    
    // Let's generate the arc points for the right side.
    // Start angle: atan2(y_intersect, x_flat).
    // End angle: atan2(-y_intersect, x_flat).
    // We go clockwise (decreasing angle).
    
    start_angle = atan2(y_intersect, x_flat);
    end_angle = atan2(-y_intersect, x_flat);
    
    // Generate points
    d_shape_points = [for (i = [0 : 127]) let(a = start_angle - i * (start_angle - end_angle) / 128) [bore_r * cos(a), bore_r * sin(a)]];
    
    // Add the flat line points
    // We need to close the loop.
    // The last point of the arc is (x_flat, -y_intersect).
    // The first point of the arc is (x_flat, y_intersect).
    // The flat line connects them.
    // So the polygon is:
    // [flat_bottom, flat_top, arc_points...]
    // Wait, the arc_points list goes from start_angle to end_angle.
    // start_angle is in Q1 (positive x, positive y).
    // end_angle is in Q4 (positive x, negative y).
    // So the arc goes from top-right to bottom-right.
    // The flat line connects (x_flat, y_intersect) to (x_flat, -y_intersect).
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect), arc_points... ]
    // But arc_points starts at (x_flat, y_intersect) and ends at (x_flat, -y_intersect).
    // So we just need to prepend the flat line segment?
    // No, the arc_points already includes the start and end points.
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect) ] + [arc_points[1:] ]
    // Wait, arc_points[0] is (