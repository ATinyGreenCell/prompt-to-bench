// Replacement knob for hotplate stirrer - D-shaft fit, grip grooves, and top pointer.

// Dimensions
shaft_d  = 6.0;
knob_d   = 30.0;
knob_h   = 15.0;
bore_h   = 12.0;
bore_d   = 6.2;
flat_w   = 4.7; // Width of the flat side of the D-bore
groove_n = 18;
groove_d = 2.0;
pointer_w = 1.5;
pointer_d = 1.0; // Depth of pointer groove

$fn = 96;

// Calculate D-bore geometry
// The D-shape is defined by a circle of diameter bore_d, but with a flat chord.
// The distance from the flat to the opposite arc is flat_w.
// Let R be the radius of the circle. The chord is at a distance 'h' from the center.
// The distance from the flat to the far arc is R + h = flat_w.
// The half-chord length is flat_w / 2.
// By Pythagoras: R^2 = (flat_w/2)^2 + h^2.
// Substitute h = flat_w - R:
// R^2 = (flat_w/2)^2 + (flat_w - R)^2
// R^2 = (flat_w/2)^2 + flat_w^2 - 2*flat_w*R + R^2
// 0 = (flat_w/2)^2 + flat_w^2 - 2*flat_w*R
// 2*flat_w*R = (flat_w/2)^2 + flat_w^2 = flat_w^2 * (1/4 + 1) = 5/4 * flat_w^2
// R = (5/8) * flat_w

R_bore = (5 / 8) * flat_w;
h_bore = flat_w - R_bore; // Distance from center to flat plane

// Main body: Cylinder
// Oriented with flat side facing +Y (so it sits on Z=0 with the flat side down? 
// No, user said "side that faces the hotplate down". 
// If the knob is printed with the D-side down, the flat part of the D is on the Z=0 plane.
// So the cylinder is centered at Z = knob_h/2. The flat face is at Z=0.
// The D-shape is in the XY plane. The flat is along the X-axis? Or Y-axis?
// Let's assume the flat is along the X-axis for symmetry, so the "point" of the D is at Y = R_bore.
// The flat is at Y = -h_bore.
// Wait, if the flat is on the bottom (Z=0), then the D-shape is extruded along Z.
// The D-shape is in the XY plane. The flat side is at Y = -h_bore.
// The cylinder is centered at Y=0.
// So the flat face is at Y = -h_bore? No, the flat face is the bottom of the knob.
// The knob sits on the bed. The bottom face is the flat part of the D.
// So the bottom face is a rectangle? No, it's a D-shape.
// The D-shape is the cross-section.
// Let's define the D-shape in the XY plane.
// Center of circle at (0,0).
// Flat side is a line segment from (-flat_w/2, -h_bore) to (flat_w/2, -h_bore).
// The arc goes from (flat_w/2, -h_bore) around to (-flat_w/2, -h_bore) via the top.
// The bottom of the knob is this flat line segment.
// So the knob sits on the line Y = -h_bore.
// We need to translate the whole thing up by h_bore so the flat face is at Z=0.
// Actually, let's just build the D-shape centered at (0, -h_bore) and extrude it.
// Then translate it up by h_bore so the flat face is at Z=0.

module d_shape() {
    // Polygon points: start at left flat, go up arc, end at right flat, go back along flat.
    // Left flat: (-flat_w/2, -h_bore)
    // Right flat: (flat_w/2, -h_bore)
    // Arc: circle of radius R_bore centered at (0,0).
    // Points on arc: (R_bore*cos(theta), R_bore*sin(theta))
    // Start of arc (right): (flat_w/2, -h_bore) -> theta = -acos((flat_w/2)/R_bore)
    // End of arc (left): (-flat_w/2, -h_bore) -> theta = acos((flat_w/2)/R_bore)
    
    // Let's calculate the start angle
    // cos(theta) = (flat_w/2) / R_bore
    // theta_start = -acos(flat_w / (2 * R_bore))
    // theta_end = acos(flat_w / (2 * R_bore))
    
    // We can just list points manually or use a loop.
    // Let's use a loop for the arc.
    
    points = [
        [-flat_w/2, -h_bore], // Start left
        [for (i = [0 : 359]) 
            let(a = i * 360 / 360)
            [R_bore * cos(a), R_bore * sin(a)]
        ],
        [flat_w/2, -h_bore] // End right (duplicate start for closed loop logic if needed, but polygon needs distinct points)
    ];
    
    // Filter points to keep the top arc (y > -h_bore)
    // We need to construct the polygon manually to ensure order.
    // 1. Left flat point
    // 2. Arc points from right to left (counter-clockwise)
    // 3. Right flat point
    
    // Calculate angles
    // cos(theta) = (flat_w/2) / R_bore
    // theta_max = acos(flat_w / (2 * R_bore))
    // We want the arc from -theta_max to theta_max going over the top?
    // No, the flat is at the bottom. The arc is the top part.
    // The flat is at y = -h_bore. The circle center is at (0,0).
    // The points on the circle with y = -h_bore are at x = +/- 2.35.
    // The arc we want is the part of the circle with y > -h_bore.
    // So angles from -theta_max to theta_max? No, that's the bottom.
    // Angles from theta_max to 360-theta_max.
    // Let's just generate points from 0 to 360 and keep those with y > -h_bore.
    // But we need to connect the flat.
    
    // Let's generate the arc points first.
    arc_points = [for (i = [0 : 359]) 
        let(a = i * 360 / 360)
        [R_bore * cos(a), R_bore * sin(a)]
    ];
    
    // Filter points to keep the top arc (y > -h_bore)
    // We need to be careful with the boundary.
    top_arc = [for (p in arc_points) if (p[1] > -h_bore) p];
    
    // Sort top_arc by angle to ensure smooth curve
    // Actually, the loop above generates them in order.
    // But we need to close the loop with the flat.
    // The flat points are (-flat_w/2, -h_bore) and (flat_w/2, -h_bore).
    // The arc starts at (flat_w/2, -h_bore) (angle -theta_max) and ends at (-flat_w/2, -h_bore) (angle theta_max).
    // Wait, if we go from -theta_max to theta_max, we are going the short way (bottom).
    // We need to go the long way (top).
    // So we go from theta_max to 360-theta_max.
    
    // Let's rebuild the polygon points explicitly.
    // 1. Left flat: (-flat_w/2, -h_bore)
    // 2. Arc points from theta_max to 360-theta_max (which is -theta_max)
    // 3. Right flat: (flat_w/2, -h_bore)
    
    // Calculate theta_max
    theta_max = acos(flat_w / (2 * R_bore));
    
    // Generate arc points from theta_max to 360-theta_max
    arc_list = [for (i = [0 : 359])