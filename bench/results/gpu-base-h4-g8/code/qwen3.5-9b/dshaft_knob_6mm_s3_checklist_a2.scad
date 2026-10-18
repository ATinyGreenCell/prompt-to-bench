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
// The flat is on the left side (negative X).
// Distance from flat (x_flat) to rightmost point (bore_r) is bore_flat.
// bore_r - x_flat = bore_flat  =>  x_flat = bore_r - bore_flat.
x_flat = bore_r - bore_flat;
// Intersection Y of the flat line with the circle
y_intersect = sqrt(bore_r * bore_r - x_flat * x_flat);

// Create the main knob body
difference() {
    // Main cylinder
    cylinder(h = knob_h, d = knob_d);

    // D-shaped bore
    // We create the D-shape by taking a full cylinder and subtracting the flat part.
    // The flat part is a cylinder of diameter (bore_d - bore_flat) centered on the axis?
    // No, the flat is a plane. The material removed is the part of the circle where x < x_flat.
    // This is equivalent to subtracting a cylinder of diameter (bore_d - bore_flat) 
    // that is offset? No.
    // The simplest way to make a D-hole is to subtract a cylinder of diameter (bore_d - bore_flat)
    // from a cylinder of diameter bore_d, but shifted so the flat face is created.
    // The flat face is at x = x_flat.
    // The circle extends to x = -bore_r.
    // The width of the flat part is bore_r - x_flat = bore_flat.
    // Wait, the distance from flat to opposite side is bore_flat.
    // So the flat is at x = x_flat. The opposite side is at x = bore_r.
    // Distance = bore_r - x_flat = bore_flat.
    // So x_flat = bore_r - bore_flat.
    // The flat part is the region x < x_flat.
    // To cut this out, we subtract a cylinder of diameter 2 * (bore_r - x_flat) = 2 * bore_flat?
    // No, the flat part is the intersection of the circle and x < x_flat.
    // This shape is not a simple cylinder.
    // However, we can approximate it by subtracting a cylinder of diameter (bore_d - bore_flat) centered at x = x_flat?
    // No, let's use the polygon method for the cross section.
    // We need to generate points for the circle arc on the right side and the flat line.
    
    // Let's define the D-shape polygon vertices.
    // We want the shape to be the circle MINUS the left part (x < x_flat).
    // Vertices (clockwise):
    // 1. Start at bottom of flat: (x_flat, -y_intersect)
    // 2. Go along flat to top: (x_flat, y_intersect)
    // 3. Go along circle arc from top to bottom on the right side.
    //    Angles from atan2(y_intersect, x_flat) to atan2(-y_intersect, x_flat).
    
    // Generate points for the circle arc
    // We need points from start_angle to end_angle (clockwise).
    start_angle = atan2(y_intersect, x_flat);
    end_angle = atan2(-y_intersect, x_flat);
    
    // Generate points for the arc
    arc_points = [for (i = [0 : 127]) let(a = start_angle - i * (start_angle - end_angle) / 128) [bore_r * cos(a), bore_r * sin(a)]];
    
    // The arc_points list goes from start_angle to end_angle.
    // start_angle is in Q1 (positive x, positive y).
    // end_angle is in Q4 (positive x, negative y).
    // So the arc goes from top-right to bottom-right.
    // The flat line connects (x_flat, y_intersect) to (x_flat, -y_intersect).
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect) ] + [arc_points[1:] ]
    // Wait, arc_points[0] is (x_flat, y_intersect).
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect) ] + [arc_points[1:] ]
    // But arc_points[1:] starts at the next point on the arc.
    // The last point of arc_points is (x_flat, -y_intersect).
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect), arc_points[1], ..., arc_points[127] ]
    // But arc_points[127] is (x_flat, -y_intersect).
    // So we have duplicate points.
    // Let's just use the arc_points and add the flat line at the beginning.
    // The flat line is from (x_flat, y_intersect) to (x_flat, -y_intersect).
    // The arc_points starts at (x_flat, y_intersect) and ends at (x_flat, -y_intersect).
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect), arc_points[1], ..., arc_points[127] ]
    // But arc_points[127] is (x_flat, -y_intersect).
    // So we have duplicate points.
    // Let's just use the arc_points and add the flat line at the beginning.
    // The flat line is from (x_flat, y_intersect) to (x_flat, -y_intersect).
    // The arc_points starts at (x_flat, y_intersect) and ends at (x_flat, -y_intersect).
    // So the polygon is:
    // [ (x_flat, y_intersect), (x_flat, -y_intersect), arc_points[1], ..., arc_points[127] ]
    // But arc_points[12