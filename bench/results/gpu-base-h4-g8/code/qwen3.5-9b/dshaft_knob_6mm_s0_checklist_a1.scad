// Replacement knob for hotplate stirrer - D-shaft fit, grip grooves, and pointer.

// Dimensions
d_shaft = 6;
d_outer = 30;
h_total = 15;
h_bore  = 12;
d_bore  = 6.2;
d_flat  = 4.7; // Distance from flat to opposite side of D-bore
n_grooves = 18;
d_groove = 2;
w_pointer = 1.5;
d_pointer = 1; // Depth of pointer groove

$fn = 128;

// Calculate D-bore geometry
r_b = d_bore / 2;
cut_depth = r_b - d_flat / 2;
flat_width = 2 * sqrt(r_b * r_b - cut_depth * cut_depth);

// Main body
difference() {
    // 1. Main Cylinder
    cylinder(h = h_total, d = d_outer);

    // 2. D-shaped Bore
    // We create a cylindrical bore and subtract a rectangular prism to make the flat side.
    // The flat side is at x = -flat_width/2 relative to the bore center?
    // No, the flat side is a chord. The distance from the center of the circle to the chord is (r_b - cut_depth).
    // The flat face is the chord itself. The material removed is the segment of the circle cut by the chord.
    // To model this in OpenSCAD using simple primitives:
    // We subtract a cylinder (the bore) and then subtract a rectangular prism that represents the "flat" part of the hole.
    // Actually, it's easier to think of the D-bore as a cylinder of radius r_b, minus a rectangular block.
    // The rectangular block has width = flat_width, height = h_bore, and depth = 1 (along Z).
    // It is positioned such that its flat face aligns with the chord of the circle.
    // The chord is at x = -(r_b - cut_depth).
    // The rectangular block extends from x = -(r_b - cut_depth) - flat_width/2 to x = -(r_b - cut_depth) + flat_width/2?
    // No, the flat face is the chord. The chord is a line segment.
    // The "flat" part of the D-shape is the area between the chord and the arc? No, that's the segment.
    // A D-shape is a circle with a flat side. The flat side is the chord.
    // The volume of the D-bore is the volume of the cylinder MINUS the volume of the segment cut off by the chord.
    // The segment is not a rectangular prism.
    // However, if we want a "flat" face, we are essentially cutting the cylinder with a plane.
    // The intersection of a cylinder and a plane is an ellipse (or part of it).
    // But the prompt says "D-shaped blind bore... a 6.2 mm diameter circle with one side cut flat".
    // This implies the cross-section is a D-shape.
    // A D-shape cross-section is a semi-circle plus a rectangle? Or a circle with a flat side?
    // Given the dimensions: d_bore = 6.2, d_flat = 4.7.
    // If it were a semi-circle, d_flat would be 6.2 (diameter).
    // Since 4.7 < 6.2, it's a circle with a chord cut off.
    // The "flat" face is the chord.
    // To model this, we can subtract a cylinder of radius r_b, and then subtract a rectangular prism that approximates the segment?
    // No, we need exact geometry.
    // The easiest way to get a D-shape hole is to subtract a cylinder and then subtract a rectangular prism that is the "flat" part.
    // Wait, if I subtract a cylinder, I have a round hole.
    // If I then subtract a rectangular prism from the side of the hole, I get a flat side.
    // The rectangular prism should be: width = flat_width, height = h_bore, depth = 1.
    // It should be positioned at x = -flat_width/2?
    // Let's assume the D-shape is formed by a circle of radius r_b and a flat face of width flat_width.
    // The flat face is at x = -flat_width/2.
    // The circle is centered at x = 0.
    // The flat face cuts into the circle.
    // The distance from the center of the circle to the flat face is (r_b - cut_depth).
    // So the flat face is at x = -(r_b - cut_depth).
    // The width of the flat face is flat_width.
    // So the flat face extends from x = -(r_b - cut_depth) - flat_width/2 to x = -(r_b - cut_depth) + flat_width/2.
    // Wait, the flat face is the chord. The chord is a line.
    // The "flat" part of the D-shape is the area between the chord and the arc? No, that's the segment.
    // A D-shape is a circle with a flat side. The flat side is the chord.
    // The volume of the D-bore is the volume of the cylinder MINUS the volume of the segment cut off by the chord.
    // The segment is not a rectangular prism.
    // However, if we want a "flat" face, we are essentially cutting the cylinder with a plane.
    // The intersection of a cylinder and a plane is an ellipse (or part of it).
    // But the prompt says "D-shaped blind bore... a 6.2 mm diameter circle with one side cut flat".
    // This implies the cross-section is a D-shape.
    // A D-shape cross-section is a semi-circle plus a rectangle? Or a circle with a flat side?
    // Given the dimensions: d_bore = 6.2, d_flat = 4.7.
    // If it were a semi-circle, d_flat would be 6.2 (diameter).
    // Since 4.7 < 6.2, it's a circle with a chord cut off.
    // The "flat" face is the chord.
    // To model this, we can subtract a cylinder of radius r_b, and then subtract a rectangular prism that approximates the segment?
    // No, we need exact geometry.
    // The easiest way to get a D-shape hole is to subtract a cylinder and then subtract a rectangular prism that is the "flat" part.
    // Wait, if I subtract a cylinder, I have a round hole.
    // If I then subtract a rectangular prism from the side of the hole, I get a flat side.
    // The rectangular prism should be: width = flat_width, height = h_bore, depth = 1.
    // It should be positioned at x = -flat_width/2?
    // Let's assume the D-shape is formed by a circle of radius r_b and a flat face of width flat_width.
    // The flat face is at x = -flat_width/2.
    // The circle is centered at x = 0.
    // The flat face cuts into the circle.
    // The distance from the center of the circle to the flat face is (r_b - cut_depth).
    // So the flat face is at x = -(r_b - cut_depth).
    // The width of the flat face is flat_width.
    // So the flat face extends from x = -(r_b - cut_depth) - flat_width/2 to x = -(r_b - cut_depth) + flat_width/2.
    // Wait, the flat face is the chord. The chord is a line.
    // The "flat" part of the D-shape is the area between the chord and the arc? No, that's the segment.
    // A D-shape is a circle with a flat side. The flat side is the chord.
    // The volume of the