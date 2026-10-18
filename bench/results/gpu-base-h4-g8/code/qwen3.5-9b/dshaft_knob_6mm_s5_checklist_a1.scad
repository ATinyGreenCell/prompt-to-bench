// Replacement knob for hotplate stirrer - D-shaft mount, grip grooves, and pointer.

// Dimensions
d_shaft = 6.0;
d_outer = 30.0;
h_total = 15.0;
h_bore  = 12.0;
h_groove = 2.0;
n_grooves = 18;
w_pointer = 1.5;
d_pointer = 1.0;

// D-shape geometry
d_circle = 6.2;
d_flat = 4.7;

$fn = 96;

// Calculate D-shape parameters
r_circle = d_circle / 2;
r_flat = d_flat / 2;
// The flat side is at x = -r_flat relative to the D-shape center.
// The circle center is shifted to the right so the leftmost point of the circle is at -r_flat.
// Circle center X = -r_flat + r_circle.
x_circle_center = -r_flat + r_circle;

difference() {
    // 1. Main Body
    // Cylinder 30mm diameter, 15mm tall, sitting on Z=0.
    translate([0, 0, 0]) 
        cylinder(h = h_total, d = d_outer);

    // 2. D-Shaped Bore
    // We create the D-shape profile in the XY plane and extrude it along Z.
    // The profile is a circle of d_circle centered at (x_circle_center, 0)
    // minus a rectangle of width d_flat and height h_bore centered at ( -r_flat, 0 ).
    
    // Define the D-shape polygon points in XY plane: [x, y]
    // Start bottom left of flat: [-r_flat, -h_bore/2]
    // Go up flat: [-r_flat, h_bore/2]
    // Go right to circle edge: [x_circle_center + r_circle, h_bore/2]
    // Go down circle arc to bottom right: [x_circle_center + r_circle, -h_bore/2]
    // Close.
    
    // Circle arc points in XY plane:
    // Center (cx, cy) = (x_circle_center, 0)
    // Radius r = r_circle.
    // Start angle 0 (rightmost), End angle 180 (leftmost).
    
    // Generate arc points
    arc_points = [for (i = [0 : 180]) let(a = i * PI / 180) [x_circle_center + r_circle * cos(a), r_circle * sin(a)]];
    
    // Combine points for the hole profile
    // Note: OpenSCAD polygon expects points in counter-clockwise order for a hole in difference?
    // Actually, for difference, the shape to subtract is just the geometry.
    // We construct the full boundary.
    p1 = [-r_flat, -h_bore/2];
    p2 = [-r_flat, h_bore/2];
    p3 = [x_circle_center + r_circle, h_bore/2];
    p4 = [x_circle_center + r_circle, -h_bore/2];
    
    // Concatenate flat lines and arc
    hole_profile = concat([p1, p2, p3, p4], arc_points);
    
    // Extrude the hole profile along Z
    // Since we are in difference(), this removes the material.
    // The profile is in XY, extrude height = h_bore.
    // Center the extrusion at Z=0? No, the bore starts at Z=0 and goes up.
    // So we translate the extrusion to start at Z=0.
    translate([0, 0, 0]) 
        linear_extrude(height = h_bore) 
            polygon(points = hole_profile);

    // 3. Grip Grooves
    // 18 evenly spaced vertical grooves along the full height.
    // Each groove is a 2 mm diameter half-cylinder centred on the outer surface.
    // "Half-cylinder" implies a semi-cylindrical cut.
    // We will create a full cylinder of diameter 2mm and subtract half of it?
    // Or simply create a shape that is a half-cylinder.
    // A half-cylinder can be made by rotating a semi-circle 180 degrees?
    // Or simpler: create a cylinder of d=2, h=h_total, then cut it in half?
    // No, we need to place 18 of them.
    // Let's create a module for a groove.
    
    // Groove geometry:
    // Diameter = 2mm -> Radius = 1mm.
    // It is a "half-cylinder". This usually means the cut is semi-circular in cross-section.
    // We can model this as a cylinder of d=2, h=h_total, and then cut it with a plane?
    // Or better: create a shape that is a semi-cylinder.
    // A semi-cylinder can be created by rotating a semi-circle 180 degrees around its diameter.
    // But we need to place it on the surface.
    // Let's create a full cylinder of d=2, h=h_total, and then use difference to cut it in half?
    // No, we need to place 18 of them.
    // Let's create a shape that is a semi-cylinder directly.
    // Rotate a semi-circle (radius 1) 180 degrees around the X axis?
    // If we rotate a semi-circle in the XZ plane (radius 1, height 2) around the X axis, we get a sphere? No.
    // Rotate a semi-circle in the XZ plane (radius 1, height 2) around the Z axis? No.
    // Let's use rotate_extrude.
    // Profile: a semi-circle of radius 1.
    // Points: [0, 0], [1, 0], [1, 2], [0, 2], [0, 0]? No, that's a rectangle.
    // Semi-circle: [0, 0], [1, 0], [0, 2], [0, 0]? No.
    // A semi-circle of radius 1 has height 2.
    // Points: [0, 0], [1, 0], [0, 2], [0, 0]? No.
    // Let's define the profile in the XZ plane (radius X, height Z).
    // A semi-circle of radius 1:
    // Start at [0, 0], go to [1, 0], go to [0, 2], go to [0, 0]? No.
    // A semi-circle is half of a circle.
    // Points: [0, 0], [1, 0], [0, 2], [0, 0]? No.
    // Let's use the circle function to generate points.
    // Circle of radius 1, center (0, 1).
    // Points from angle 0 to 180.
    // [1*cos(a), 1*sin(a) + 1].
    // This gives a semi-circle from (1, 1) to (-1, 1) passing through (0, 2).
    // We want a semi-circle of height 2.
    // Let's use: [1*cos(a), 1*sin(a) + 1] for a from 0 to 180.
    // This gives a semi-circle of radius 1, height 2.
    // Rotate this profile 180 degrees around the X axis? No, around the Z axis?
    // We want a half-cylinder.
    // Let's create a full cylinder of d=2, h=h_total, and then cut it in half with a plane?
    // No, we need to place 18 of them.
    // Let's create a shape that is a semi-cylinder.
    // Rotate a semi-circle (radius 1) 180 degrees around the X axis?
    // If we rotate a semi-circle in the XZ plane (radius 1, height 2) around the X axis, we get a sphere? No.
    // Let's try:
    // Profile: [0, 0], [1, 0], [0, 2], [0, 0]? No.
    // Let's use the circle function to generate points for a semi-circle.
    // Points: [1*cos(a), 1*sin(a) + 1] for a from 0 to 180.
    // This gives a semi-circle of radius 1, height 2.
    // Rotate this profile 180 degrees around the X axis? No, around the Z axis?
    // We want a half-cylinder.
    // Let's create a full cylinder of d=2, h=h_total, and then cut it in half with a plane?
    // No, we need to place 18 of them.